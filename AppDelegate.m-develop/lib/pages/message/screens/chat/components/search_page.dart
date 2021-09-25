import 'package:Siuu/bloc/chatsearch_bloc.dart';
import 'package:Siuu/pages/message/components/custom_progress.dart';

import 'search_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsearchBloc, ChatsearchState>(
      builder: (_, ChatsearchState state) {
        if (state is ChatsearchLoaded) {
          if (state.usersId.isEmpty) {
            return Container(
              color: Colors.white,
              child: Center(
                  child: Text(
                'No results found.',
                style: TextStyle(color: Colors.grey, fontSize: 22),
              )),
            );
          }
          return SearchList(state.usersId);
        }
        if (state is ChatsearchInLoading) {
          return Container(
            color: Colors.white,
            child: CustomCircularIndicator(),
          );
        }
        if (state is ChatsearchClosed) {
          return Container(height: 0, width: 0);
        }
        return Container(color: Colors.white);
      },
    );
  }
}
