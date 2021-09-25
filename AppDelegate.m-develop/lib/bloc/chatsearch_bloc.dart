import 'dart:async';
import 'package:Siuu/consts/firebase_consts.dart';
import 'package:Siuu/utils/firestore_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'chatsearch_event.dart';
part 'chatsearch_state.dart';

class ChatsearchBloc extends Bloc<ChatsearchEvent, ChatsearchState> {
  ChatsearchBloc() : super(ChatsearchClosed(true));

  @override
  Stream<ChatsearchState> mapEventToState(
    ChatsearchEvent event,
  ) async* {
    if (event is ChatSearchOpen) {
      yield ChatsearchInitial();
    } else if (event is ChatSearchFetch) {
      yield* _mapChatSearchFetchToState(event);
    } else if (event is ChatSearchClose) {
      yield ChatsearchClosed(event.fromBackButton);
    }
  }

  Stream<ChatsearchState> _mapChatSearchFetchToState(
      ChatSearchFetch event) async* {
    if (event.name.isNotEmpty) {
      yield ChatsearchInLoading();
      List<String> res = await firestore
          .collection(conversationsPath)
          .where(nameCaseSearchField, arrayContains: event.name)
          .orderBy(newMessageTimestampField)
          .get()
          .then((value) => value.docs.map((e) => e.id).toList());

      yield ChatsearchLoaded(res);
    } else {
      yield ChatsearchInitial();
    }
  }
}
