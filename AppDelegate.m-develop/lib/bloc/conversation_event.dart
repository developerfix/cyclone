part of 'conversation_bloc.dart';

abstract class ConversationEvent {
  const ConversationEvent();
}

class ConversationLoaded extends ConversationEvent {}

class ConversationLoadedMore extends ConversationEvent {}

class MessageAdded extends ConversationEvent {
  final Message msg;
  final ReplyState replyState;

  const MessageAdded(this.msg, this.replyState);

  @override
  String toString() => 'MessageAdded { Conversation: $msg }';
}

class MessageReacted extends ConversationEvent {
  final Message msg;
  final String reaction;

  const MessageReacted(this.msg, this.reaction);

  @override
  String toString() => 'MessageReacted(msg: $msg, reaction: $reaction)';
}

class MessageDeleted extends ConversationEvent {
  final Message msg;

  const MessageDeleted(this.msg);

  @override
  String toString() => 'MessageDeleted { Conversation: $msg }';
}

class MessagesReaded extends ConversationEvent {}
