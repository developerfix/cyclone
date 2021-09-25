import 'package:Siuu/bloc/chatsearch_bloc.dart';
import 'package:Siuu/consts/firebase_consts.dart';
import 'package:Siuu/pages/message/components/AnimSearchBar.dart';
import 'package:Siuu/pages/message/components/CustomAppBar.dart';
import 'package:Siuu/pages/message/components/custom_progress.dart';
import 'package:Siuu/pages/message/components/custom_scaffold.dart';
import 'package:Siuu/utils/fcm_utils.dart';
import 'components/nearby_users.dart';
import 'components/search_page.dart';
import 'components/recent_chats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatsearchBloc searchBloc;

  @override
  void initState() {
    searchBloc = BlocProvider.of<ChatsearchBloc>(context);
    flutterLocalNotificationsPlugin.cancelAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!(searchBloc.state is ChatsearchClosed)) {
          searchBloc.add(ChatSearchClose(fromBackButton: true));
          FocusScope.of(context).unfocus();
          return false;
        }
        return true;
      },
      child: CustomScaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          leading: Container(
            width: 48,
            child: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Text(
            'Messages',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          search: BlocBuilder<ChatsearchBloc, ChatsearchState>(
            builder: (context, state) {
              return AnimSearchBar(
                toggle: state is ChatsearchClosed ? 0 : 1,
                width: MediaQuery.of(context).size.width - 28,
                onOpen: () => searchBloc.add(ChatSearchOpen()),
                onClose: () => searchBloc.add(ChatSearchClose()),
                onChanged: (s) => searchBloc.add(ChatSearchFetch(s)),
              );
            },
          ),
        ),
        body: currentUser == null
            ? Center(
                child: CustomCircularIndicator(),
              )
            : Stack(
                children: [
                  Container(
                    color: Color(0xFFFFEFEE),
                    child: Column(
                      children: <Widget>[
                        NearbyUsers(),
                        Expanded(child: RecentChats()),
                      ],
                    ),
                  ),
                  SearchPage(),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    searchBloc.close();
    super.dispose();
  }
}
