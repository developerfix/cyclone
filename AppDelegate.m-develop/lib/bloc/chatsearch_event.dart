part of 'chatsearch_bloc.dart';

@immutable
abstract class ChatsearchEvent {}

class ChatSearchFetch extends ChatsearchEvent {
  final String name;

  ChatSearchFetch(this.name);
}

class ChatSearchOpen extends ChatsearchEvent {}

class ChatSearchClose extends ChatsearchEvent {
  final bool fromBackButton;

  ChatSearchClose({this.fromBackButton = false});
}
