import 'dart:async';
import 'dart:developer';
import 'package:Siuu/consts/firebase_consts.dart';
import 'package:Siuu/repository/conversation_repository.dart';
import 'package:Siuu/utils/firestore_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'typing_state.dart';

class TypingCubit extends Cubit<TypingState> {
  StreamSubscription streamSub;
  final String userId;

  TypingCubit(this.userId) : super(TypingFalse()) {
    streamSub = firestore
        .doc(specificConversationPath(userId))
        .snapshots()
        .listen((event) {
      bool isWriting = event.data().containsKey(isWritingField)
          ? event.get(isWritingField)
          : false;

      emit(isWriting ? TypingTrue() : TypingFalse());
    });
  }

  void toggleTyping(bool isTyping) {
    if (isTyping && (state is TypingTrue)) return;
    ConversationRepository.toggleIsTyping(userId, isTyping);
  }

  @override
  Future<void> close() {
    ConversationRepository.toggleIsTyping(userId, false);
    log('Typing cubit closed');
    streamSub.cancel();
    return super.close();
  }
}
