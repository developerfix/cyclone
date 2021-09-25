import 'package:Siuu/bloc/nearbyusers_bloc.dart';
import 'package:Siuu/consts/firebase_consts.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/models/user_model.dart';
import 'package:Siuu/pages/message/components/UserAvatar.dart';
import 'package:Siuu/pages/message/components/custom_progress.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/utils/firestore_utils.dart';
import 'package:Siuu/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NearbyUsers extends StatefulWidget {
  @override
  _NearbyUsersState createState() => _NearbyUsersState();
}

class _NearbyUsersState extends State<NearbyUsers>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(accentColor),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: BlocBuilder<NearbyUsersBloc, NearbyUsersState>(
          builder: (_, NearbyUsersState state) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Nearby users',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CupertinoSwitch(
                            value: state.isActive,
                            activeColor: Color(pinkColor),
                            onChanged: (_) => context
                                .read<NearbyUsersBloc>()
                                .add(NearbyUsersToggled()),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                AnimatedSize(
                    duration: Duration(milliseconds: 200),
                    vsync: this,
                    curve: Curves.easeOutBack,
                    child: state.isActive
                        ? state is NearbyUsersInProgress
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: CustomCircularIndicator(),
                              )
                            : state is NearbyUsersLoadFailure
                                ? Center(
                                    child: Text(
                                    'We cannot fetch users nearby to you.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                  ))
                                : state is NearbyUsersLoadSuccess
                                    ? state.users.length == 0
                                        ? Center(
                                            child: Text(
                                            'No users found.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18),
                                          ))
                                        : Container(
                                            height: 120.0,
                                            child: ListView.builder(
                                              padding:
                                                  EdgeInsets.only(left: 10.0),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: state.users.length,
                                              itemBuilder: (_, int index) {
                                                ChatUser user =
                                                    state.users[index];

                                                return GestureDetector(
                                                  onTap: () =>
                                                      goToConverstation(
                                                          context, user),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            UserAvatar(
                                                                user: user),
                                                            Positioned(
                                                              child: Distance(
                                                                userId: user.id,
                                                              ),
                                                              bottom: 0,
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(height: 6.0),
                                                        Text(
                                                          user.name,
                                                          style: TextStyle(
                                                            color:
                                                                Colors.blueGrey,
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                    : Container()
                        : Container()),
              ],
            );
          },
        ),
      ),
    );
  }
}

class Distance extends StatefulWidget {
  const Distance({@required this.userId});

  final String userId;

  @override
  _DistanceState createState() => _DistanceState();
}

class _DistanceState extends State<Distance> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: firestore.doc('chatUsers/${widget.userId}').snapshots(),
        builder: (context, snapshot) {
          return AnimatedSize(
            child: !snapshot.hasData
                ? Container()
                : Container(
                    child: Text(
                      getDistance(snapshot.data.data()),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
            duration: Duration(milliseconds: 100),
            vsync: this,
          );
        });
  }
}
