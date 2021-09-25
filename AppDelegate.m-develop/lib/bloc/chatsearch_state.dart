part of 'chatsearch_bloc.dart';

@immutable
abstract class ChatsearchState {
  final List<String> usersId;

  ChatsearchState({this.usersId});
}

class ChatsearchInitial extends ChatsearchState {}

class ChatsearchLoaded extends ChatsearchState {
  ChatsearchLoaded(List<String> usersId) : super(usersId: usersId);
}

class ChatsearchClosed extends ChatsearchState {
  final bool fromBackButton;

  ChatsearchClosed(this.fromBackButton);
}

class ChatsearchInLoading extends ChatsearchState {}
