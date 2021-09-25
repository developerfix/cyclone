import 'dart:async';

import 'package:Siuu/bloc/conversation_bloc.dart';
import 'package:Siuu/consts/firebase_consts.dart';
import 'package:Siuu/models/message_model.dart';
import 'package:Siuu/models/user_model.dart';
import 'package:Siuu/pages/message/components/custom_progress.dart';
import 'package:Siuu/res/colors.dart';
import 'package:declarative_animated_list/declarative_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'widgets/message_item.dart';

class MessagesList extends StatefulWidget {
  final ChatUser user;
  MessagesList({@required this.user});

  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList>
    with TickerProviderStateMixin {
  AutoScrollController scrollController;
  double width;
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    scrollController = context.read<ConversationBloc>().scrollController;

    animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  void _onLoading() =>
      context.read<ConversationBloc>().add(ConversationLoadedMore());

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width * 0.75;
    return BlocBuilder<ConversationBloc, ConversationState>(
      builder: (_, ConversationState state) {
        return _buildWithState(state);
      },
    );
  }

  bool _isFirstLoad = true;
  Widget _buildWithState(ConversationState state) {
    if (state is ConversationEmpty)
      return Center(child: Text('Say Hi to ${widget.user.name}'));
    if (state is ConversationLoadFailure) return Center(child: Text('error'));
    if (state is ConversationLoadInProgress) return CustomCircularIndicator();
    if (state is ConversationLoadSuccess) {
      List<Message> _msgs = List.from((state).messages);
      if (_msgs.isEmpty)
        return Center(child: Text('Say Hi to ${widget.user.name}'));
      if (_isFirstLoad) {
        _isFirstLoad = false;
        Timer(Duration(milliseconds: 200), () {
          animationController.forward();
        });
      }
      return FadeTransition(
        opacity: animation,
        child: Stack(
          children: [
            SmartRefresher(
              child: DeclarativeList<Message>(
                insertDuration: const Duration(milliseconds: 500),
                removeDuration: const Duration(milliseconds: 500),
                items: _msgs,
                itemBuilder: (_, __, int index, Animation<double> animation) {
                  return MessageItem(
                    index: index,
                    scrollController: scrollController,
                    currentMessage: _msgs[index],
                    nextMessage:
                        index < _msgs.length - 1 ? _msgs[index + 1] : null,
                    user: widget.user,
                    width: width,
                  );
                },
                removeBuilder: (_, __, ___, Animation<double> animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: Container(height: 30),
                  );
                },
                scrollController: scrollController,
                reverse: true,
              ),
              onLoading: _onLoading,
              enablePullDown: true,
              enablePullUp: true,
              controller: context.read<ConversationBloc>().refreshController,
              header: CustomHeader(height: 0, builder: (_, __) => Container()),
              footer: ClassicFooter(
                noDataText: 'No more messages',
              ),
            ),
            ValueListenableBuilder(
                valueListenable: context.read<ConversationBloc>().posInStart,
                builder: (_, posInstart, __) {
                  if (posInstart) return Container();
                  return Positioned(
                    child: FloatingActionButton(
                        onPressed: () => scrollController.jumpTo(0),
                        backgroundColor: Color(accentColor2),
                        mini: true,
                        child: Icon(
                          Icons.arrow_downward_outlined,
                        )),
                    bottom: 10,
                    right: 10,
                  );
                })
          ],
        ),
      );
    }
    return Container();
  }
}
