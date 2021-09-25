part of 'reply_cubit.dart';

@immutable
abstract class ReplyState {}

class ReplyEnable extends ReplyState {
  final Message msg;

  ReplyEnable(this.msg);
}

class ReplyDisable extends ReplyState {}
