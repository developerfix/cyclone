import 'dart:async';
import 'dart:math';
import 'package:Siuu/consts/firebase_consts.dart';
import 'package:Siuu/cubit/reply_cubit.dart';
import 'package:Siuu/models/message_model.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/models/user_model.dart';
import 'package:Siuu/pages/message/screens/conversation/conversation_page.dart';
import 'package:Siuu/repository/conversation_repository.dart';
import 'package:Siuu/utils/firebase_storage_utils.dart';
import 'package:Siuu/utils/firestore_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer' as d;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

part 'conversation_event.dart';

part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  StreamSubscription messsagesStream;
  StreamSubscription reactStream;
  bool _firstMsgs = true;
  bool _firstReacts = true;
  final GlobalKey<AnimatedListState> listKey = GlobalKey();
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final AutoScrollController scrollController = AutoScrollController();
  final ConversationRepository conversationRepository =
      ConversationRepository();
  final ChatUser reciever;
  ValueNotifier<bool> posInStart = ValueNotifier(true);
  ConversationBloc({@required this.reciever})
      : super(ConversationLoadInProgress()) {
    initStreams();
    scrollController.addListener(() {
      if (scrollController.position.pixels < 40) {
        posInStart.value = true;
      } else {
        posInStart.value = false;
      }
    });
  }

  @override
  Stream<ConversationState> mapEventToState(
    ConversationEvent event,
  ) async* {
    if (event is ConversationLoaded) {
      yield* _loadedToState();
    } else if (event is ConversationLoadedMore) {
      yield* _loadedMoreToState();
    } else if (event is MessageAdded) {
      yield* _messageAddedToState(event);
    } else if (event is MessageReacted) {
      yield* _messageReactedToState(event);
    } else if (event is MessageDeleted) {
      yield* _messageDeletedToState(event);
    } else if (event is MessagesReaded) {
      yield* _messagesReadedToState();
    }
  }

  Stream<ConversationState> _loadedToState() async* {
    try {
      final List<Message> messages =
          await conversationRepository.fetchMessages(reciever.id);
      if (messages.isEmpty) {
        yield ConversationEmpty();
      } else {
        firestore
            .doc(conversationsPath + reciever.id)
            .update({newMessagesNumField: 0});
        yield ConversationLoadSuccess(messages: messages);
      }
    } catch (_) {
      yield ConversationLoadFailure();
    }
  }

  Stream<ConversationState> _loadedMoreToState() async* {
    d.log('load more');
    try {
      if (state is ConversationLoadSuccess) {
        ConversationLoadSuccess currentState =
            (state as ConversationLoadSuccess);
        final List<Message> moreMessages =
            await conversationRepository.loadMoreMessages(reciever.id);
        if (moreMessages.isNotEmpty) {
          List<Message> messages = currentState.messages;

          messages.addAll(moreMessages);

          yield ConversationLoadSuccess(messages: messages);
        }
        moreMessages.isNotEmpty
            ? refreshController.loadComplete()
            : refreshController.loadNoData();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  Stream<ConversationState> _messageAddedToState(MessageAdded event) async* {
    String _msgId =
        '${currentUser.id} - ${Random().nextInt(64)}${DateTime.now()}';

    Message msg = event.msg.copyWith(
      id: _msgId,
      senderId: currentUser.id,
      timestamp: Timestamp.now(),
      loadUrls: true,
      quotedMessage: event.replyState is ReplyEnable
          ? (event.replyState as ReplyEnable).msg
          : null,
    );

    if (state is ConversationLoadSuccess) {
      List<Message> updatedMessages =
          (state as ConversationLoadSuccess).messages.toList();
      updatedMessages.insert(0, msg);

      yield ConversationLoadSuccess(messages: updatedMessages);
      if (scrollController.position.pixels != 0) {
        scrollController.jumpTo(0);
      }
      posInStart.value = true;
    }
    if (state is ConversationEmpty) {
      yield ConversationLoadSuccess(messages: [msg]);
    }

    if (msg.isAudio || msg.isImage) {
      uploadFile(
        filePath: msg.temporaryAudioPath ?? msg.temporaryImagePath,
        fileName: '${currentUser.id} - ${reciever.id}',
        cloudDir: msg.isAudio ? audiosDirectory : imagesDirectory,
        msg: msg,
        recieverId: reciever.id,
      );
    }
    conversationRepository.sendMessage(msg: msg, reciever: reciever);
  }

  Stream<ConversationState> _messageDeletedToState(
      MessageDeleted event) async* {
    if (state is ConversationLoadSuccess) {
      List<Message> msgs = (state as ConversationLoadSuccess).messages.toList();

      int removeIndex =
          msgs.indexWhere((element) => element.id == event.msg.id);

      // AnimatedListRemovedItemBuilder builder = (context, animation) {
      //   return buildItem(
      //     animation: animation,
      //     index: removeIndex,
      //     msgs: msgs,
      //     scrollController: scrollController,
      //     user: reciever,
      //     width: (MediaQuery.of(context).size.width * 0.75),
      //   );
      // };
      msgs.removeAt(removeIndex);
      // listKey.currentState.removeItem(removeIndex, builder);

      // await Future.delayed(Duration(milliseconds: 200));
      yield ConversationLoadSuccess(messages: msgs);

      conversationRepository.deleteMessage(
        msg: event.msg,
        reciever: reciever,
      );
    }
  }

  Stream<ConversationState> _messageReactedToState(
      MessageReacted event) async* {
    conversationRepository.reactToMessage(
      msg: event.msg,
      reaction: event.reaction,
      reciever: reciever,
    );
  }

  Stream<ConversationState> _messagesReadedToState() async* {
    if (state is ConversationLoadSuccess) {
      List<Message> msgs = (state as ConversationLoadSuccess).messages.toList();
      conversationRepository.readLastMessge(reciever.id, msgs.first.id);
    }
  }

  void initStreams() {
    messsagesStream = firestore
        .collection(specificMessagesPath(reciever.id))
        .where('senderId', isNotEqualTo: currentUser.id)
        .snapshots()
        .listen((querySnapShot) async {
      if (_firstMsgs) {
        _firstMsgs = false;
        return;
      }

      Message newMsg =
          Message.fromMap(querySnapShot.docChanges.last.doc.data());

      if (newMsg != null) {
        List<Message> messages =
            (state as ConversationLoadSuccess).messages.toList();
        d.log('messages');

        Message oldMessage =
            messages.firstWhere((e) => e.id == newMsg.id, orElse: () => null);

        d.log(oldMessage.toString());
        if (oldMessage != null) {
          // check if is a reaction or delete or image/audio uploaded
          if (oldMessage.imageUrl != newMsg.imageUrl) {
            d.log('image uploaded');
            messages[messages.indexOf(oldMessage)] = newMsg;
            emit(ConversationLoadSuccess(messages: messages));
          } else if (oldMessage.audioUrl != newMsg.audioUrl) {
            d.log('audio uploaded');
            messages[messages.indexOf(oldMessage)] = newMsg;
            emit(ConversationLoadSuccess(messages: messages));
          } else if (oldMessage.reaction != newMsg.reaction) {
            d.log('react');
            messages[messages.indexOf(oldMessage)] =
                newMsg.copyWith(urlsData: oldMessage.urlsData);
            emit(ConversationLoadSuccess(messages: messages));
          } else {
            d.log('delete');
            messages.remove(oldMessage);
            emit(ConversationLoadSuccess(messages: messages));
          }
        } else {
          d.log('new Message');
          // message not exists but need to check if not loaded
          if (newMsg.dateTime.isAfter(messages.last.dateTime)) {
            messages.insert(0, newMsg.copyWith(loadUrls: true));
            emit(ConversationLoadSuccess(messages: messages));
            if (conversationIsActive)
              conversationRepository.readLastMessge(reciever.id, newMsg.id);
          }
        }
      }
    });

    reactStream = firestore
        .collection(specificMessagesPath(reciever.id))
        .where('senderId', isEqualTo: currentUser.id)
        .snapshots()
        .listen((querySnapShot) {
      if (_firstReacts) {
        _firstReacts = false;
        return;
      }

      Message newMsg =
          Message.fromMap(querySnapShot.docChanges.last.doc.data());

      if (newMsg != null) {
        List<Message> messages =
            (state as ConversationLoadSuccess).messages.toList();

        Message oldMessage =
            messages.firstWhere((e) => e.id == newMsg.id, orElse: () => null);

        if (oldMessage != null) {
          if (oldMessage.reaction != newMsg.reaction) {
            d.log('react');
            messages[messages.indexOf(oldMessage)] =
                newMsg.copyWith(urlsData: oldMessage.urlsData);
            emit(ConversationLoadSuccess(messages: messages));
          }
        }
      }
    });
  }

  @override
  Future<void> close() {
    d.log('conversation bloc closed');
    messsagesStream.cancel();
    reactStream.cancel();
    refreshController.dispose();
    scrollController.dispose();
    return super.close();
  }
}
