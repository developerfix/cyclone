import 'dart:developer';

import 'package:Siuu/models/message_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'reply_state.dart';

class ReplyCubit extends Cubit<ReplyState> {
  final FocusNode textFocus = FocusNode();
  final TextEditingController textController = TextEditingController();
  ReplyCubit() : super(ReplyDisable());

  void reply(Message msg) {
    emit(ReplyEnable(msg));
  }

  void closeReply() {
    if (state is ReplyEnable) emit(ReplyDisable());
  }

  @override
  Future<void> close() {
    log('reply bloc closed');
    textFocus.dispose();
    textController.dispose();
    return super.close();
  }
}
