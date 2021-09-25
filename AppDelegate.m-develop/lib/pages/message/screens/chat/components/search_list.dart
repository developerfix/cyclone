
import 'package:Siuu/models/user_model.dart';
import 'package:Siuu/pages/message/components/UserAvatar.dart';
import 'package:Siuu/utils/firestore_utils.dart';
import 'package:Siuu/utils/utils.dart';
import 'package:flutter/material.dart';

class SearchList extends StatelessWidget {
  final List<String> usersId;

  const SearchList(this.usersId);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
          itemCount: usersId.length,
          itemBuilder: (_, pos) {
            return FutureBuilder(
                future: fetchUser(usersId[pos], context),
                builder: (_, snapshot) {
                  ChatUser user = snapshot.data;
                  if (user == null) return Container();

                  return InkWell(
                    onTap: () => goToConverstation(context, user),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Row(children: <Widget>[
                        UserAvatar(user: user),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                user == null ? '...' : user.name,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  );
                });
          }),
    );
  }
}
