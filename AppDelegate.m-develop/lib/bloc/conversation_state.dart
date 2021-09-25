part of 'conversation_bloc.dart';

abstract class ConversationState {
  const ConversationState();
}

class ConversationLoadInProgress extends ConversationState {}

class ConversationLoadSuccess extends ConversationState {
  final List<Message> messages;

  ConversationLoadSuccess({@required this.messages});

  @override
  String toString() => 'ConversationLoadSuccess { messages: $messages }';
}

class ConversationEmpty extends ConversationState {}

class ConversationLoadFailure extends ConversationState {}
