import 'dart:developer';
import 'package:Siuu/consts/firebase_consts.dart';
import 'package:Siuu/models/latest_message_model.dart';
import 'package:Siuu/models/message_model.dart';
import 'package:Siuu/models/user_model.dart';
import 'package:Siuu/utils/firestore_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'messaging_repository.dart';
import 'package:firestore_cache/firestore_cache.dart';

class ConversationRepository {
  final int loadMessagesLength = 40;
  DocumentSnapshot _lastDocument;
  MessagingRpository messagingRpository = MessagingRpository();

  // get messages list with a user passed on params
  Future<List<Message>> fetchMessages(String userId) async {
    final DocumentReference cacheDocRef =
        firestore.doc(specificConversationPath(userId));

    final String cacheField = 'timestamp';

    final Query query = firestore
        .collection(specificMessagesPath(userId))
        .limit(loadMessagesLength)
        .orderBy('timestamp', descending: true);

    return await FirestoreCache.getDocuments(
      query: query,
      cacheDocRef: cacheDocRef,
      firestoreCacheField: cacheField,
    ).then((snapshot) {
      List<Message> msgs = [];

      for (var i = 0; i < snapshot.docs.length; i++) {
        msgs.add(
            Message.fromMap(snapshot.docs[i].data()).copyWith(loadUrls: true));
      }
      if (snapshot.docs.length > 1)
        _lastDocument = snapshot.docs.last;
      else
        _lastDocument = null;

      if (msgs.isNotEmpty) {
        readLastMessge(userId, msgs.first.id);
      }
      return msgs;
    });
  }

  Future<List<Message>> loadMoreMessages(String userId) async {
    if (_lastDocument == null) return [];

    final DocumentReference cacheDocRef =
        firestore.doc(specificConversationPath(userId));

    final String cacheField = 'timestamp';

    final Query query = firestore
        .collection(specificMessagesPath(userId))
        .limit(loadMessagesLength)
        .orderBy('timestamp', descending: true)
        .startAfter([_lastDocument.get('timestamp')]);

    return await FirestoreCache.getDocuments(
      query: query,
      cacheDocRef: cacheDocRef,
      firestoreCacheField: cacheField,
    ).then((snapshot) {
      List<Message> msgs = [];

      for (var i = 0; i < snapshot.docs.length; i++) {
        msgs.add(
            Message.fromMap(snapshot.docs[i].data()).copyWith(loadUrls: true));
      }

      if (snapshot.docs.length > 1)
        _lastDocument = snapshot.docs.last;
      else
        _lastDocument = null;
      return msgs;
    });
  }

  Future<void> sendMessage(
      {@required Message msg, @required ChatUser reciever}) async {
    String recieverId = reciever.id;

    print('sendMessage');
    // add message to my conversation
    firestore
        .doc(
            '/messages/${currentUser.id}/conversations/$recieverId/messages/${msg.id}/')
        .set(msg.toMap())
        .then(
            (value) => firestore.doc(specificConversationPath(recieverId)).set(
                  {
                    newMessagesNumField: 0,
                    newMessageTimestampField: FieldValue.serverTimestamp(),
                    latestMessageField: LatestMessage.fromMessage(msg).toMap(),
                    nameCaseSearchField: setSearchParams(reciever.name),
                  },
                  SetOptions(merge: true),
                ));
    // add message to other user conversation
    firestore
        .doc(
            '/messages/$recieverId/conversations/${currentUser.id}/messages/${msg.id}/')
        .set(msg.toMap())
        .then((value) async {
      firestore.doc(specificRecieverConversationPath(recieverId)).set(
        {
          newMessageTimestampField: FieldValue.serverTimestamp(),
          latestMessageField: LatestMessage.fromMessage(msg).toMap()
        },
        SetOptions(merge: true),
      );

      if (!(await isChattingWithMe(recieverId))) {
        print('sendMessage not chatting with me');
        firestore.doc(specificRecieverConversationPath(recieverId)).set(
          {
            newMessagesNumField: FieldValue.increment(1),
            latestMessageReadedField: msg.id
          },
          SetOptions(merge: true),
        );
        if (!await isMuted(recieverId)) {
          Map<String, dynamic> notification = {
            'title': currentUser == null ? '' : currentUser.name ?? '',
            'body': msg.text,
            'badge': '1',
            'sound': 'default'
          };
          messagingRpository.sendNotification(notification, reciever.token);
        }
      } else {
        print('sendMessage chatting with me');
        firestore.doc(specificRecieverConversationPath(recieverId)).set(
          {newMessagesNumField: 0},
          SetOptions(merge: true),
        );
      }
    });
  }

  Future<void> deleteMessage(
      {@required Message msg, @required ChatUser reciever}) async {
    firestore
        .doc(
            '/messages/${currentUser.id}/conversations/${reciever.id}/messages/${msg.id}/')
        .delete();
    firestore
        .doc(
            '/messages/${reciever.id}/conversations/${currentUser.id}/messages/${msg.id}/')
        .delete();
  }

  Future<bool> isChattingWithMe(String userId) async {
    String chattingWith = await firestore
        .doc('chatUsers/$userId')
        .get()
        .then((value) => value.get('chattingWith'));
    print('sendMessage me ${currentUser.id}');
    print('sendMessage chattingWith $chattingWith');

    return currentUser.id == chattingWith;
  }

  void readLastMessge(String userId, String msgId) {
    firestore.doc(specificRecieverConversationPath(userId)).set(
      {latestMessageReadedField: msgId},
      SetOptions(merge: true),
    );
  }

  void reactToMessage({Message msg, String reaction, ChatUser reciever}) async {
    firestore
        .doc(
            '/messages/${currentUser.id}/conversations/${msg.senderId}/messages/${msg.id}')
        .update({'reaction': reaction});
    firestore
        .doc(
            '/messages/${msg.senderId}/conversations/${currentUser.id}/messages/${msg.id}')
        .update({'reaction': reaction});
    if (!msg.isMe) {
      if (!(await isChattingWithMe(msg.senderId))) {
        log('not chatting with me');
        firestore.doc(specificRecieverConversationPath(msg.senderId)).set(
          {newMessagesNumField: FieldValue.increment(1)},
          SetOptions(merge: true),
        );

        if (!await isMuted(msg.senderId)) {
          Map<String, dynamic> notification = {
            'title': currentUser == null ? '' : currentUser.name,
            'body': 'React to : ' + msg.text,
            'badge': '1',
            'sound': 'default'
          };
          messagingRpository.sendNotification(notification, reciever.token);
        }
      }
    }
  }

  void updateChattingWith(String userId) {
    firestore
        .doc('chatUsers/${currentUser.id}')
        .set({'chattingWith': userId ?? ''}, SetOptions(merge: true));
  }

  Future<bool> isMuted(String userId) async {
    bool isMuted = false;
    try {
      isMuted = await firestore
          .doc('/messages/$userId/conversations/${currentUser.id}/')
          .get()
          .then((value) => value.get(isMutedField));
    } catch (e) {
      isMuted = false;
    }

    return isMuted;
  }

  static void toggleIsTyping(String userId, bool isTyping) {
    firestore
        .doc(specificRecieverConversationPath(userId))
        .set({isWritingField: isTyping}, SetOptions(merge: true));
  }

  static Future<void> deleteConversation(String userId) async {
    return await firestore
        .collection(specificMessagesPath(userId))
        .get()
        .then((snap) async {
      for (var i = 0; i < snap.docs.length; i++) {
        await snap.docs[i].reference.delete();
      }
      return await firestore.doc(specificConversationPath(userId)).delete();
    });
  }

  static Future<bool> updateUrl({
    @required Message msg,
    @required String url,
    @required String recieverId,
  }) async {
    String urlFieldName;
    if (msg.isImage) {
      urlFieldName = 'imageUrl';
    } else if (msg.isAudio) {
      urlFieldName = 'audioUrl';
    }
    if (urlFieldName != null) {
      await firestore
          .doc(
              '/messages/${currentUser.id}/conversations/$recieverId/messages/${msg.id}/')
          .update({urlFieldName: url});
      await firestore
          .doc(
              '/messages/$recieverId/conversations/${currentUser.id}/messages/${msg.id}/')
          .update({urlFieldName: url});
      return true;
    }
    return false;
  }
}
