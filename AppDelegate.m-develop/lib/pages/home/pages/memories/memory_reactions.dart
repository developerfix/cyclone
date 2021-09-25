import 'dart:convert';

import 'package:Siuu/models/UserStory.dart';
import 'package:Siuu/models/moment_reaction.dart';
import 'package:Siuu/models/moment_reaction_list.dart';
import 'package:Siuu/models/moment_viewers.dart';
import 'package:Siuu/pages/home/pages/profile/profile_loader.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../provider.dart';

class MemoryReactionsPage extends StatefulWidget {
  final Story story;
  final String reactionType;

  const MemoryReactionsPage({
    @required this.story,
    @required this.reactionType,
  });

  @override
  _MemoryReactionsPageState createState() => _MemoryReactionsPageState();
}

class _MemoryReactionsPageState extends State<MemoryReactionsPage> {
  ValueNotifier<MomentReactionList> momentReactionList;
  UserService userService;
  Future<MomentReactionList> futureMomentReactionList;

  @override
  void initState() {
    super.initState();
    momentReactionList = ValueNotifier(null);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var provider = OpenbookProvider.of(context);
    userService = provider.userService;
    if (futureMomentReactionList == null) {
      futureMomentReactionList =
          userService.getReactionsForMoment(widget.story.id);
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      appBar: OBThemedNavigationBar(
        title:
            'Moment ${widget.reactionType} ${momentReactionList.value?.reactions?.length ?? 0}',
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.white,
        ),
        width: width,
        height: height,
        child: builder(),
      ),
    );
  }

  Widget builder() {
    return FutureBuilder<MomentReactionList>(
      future: futureMomentReactionList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (momentReactionList.value == null) {
            final myList = snapshot.data;
            myList.reactions.removeWhere(
                (element) => element.reaction != widget.reactionType);
            momentReactionList.value = myList;
          }
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {});
          });
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: momentReactionList.value?.reactions?.length ?? 0,
            itemBuilder: (context, index) {
              return momentViewer(momentReactionList.value.reactions[index]);
            },
          );
        } else {
          return Center(
            child: Container(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget momentViewer(MomentReaction momentViewer) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var openbookProvider = OpenbookProvider.of(context);
    var localizationService = openbookProvider.localizationService;
    var utilsService = openbookProvider.utilsService;
    /*String created =
        utilsService.timeAgo(momentViewer.viewTime, localizationService);*/
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ProfileLoader(userId: int.parse(momentViewer.userId)),
          ),
        );
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(height: width * 0.024),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: width * 0.024),
                    CircleAvatar(
                      radius: 32,
                      foregroundColor: Colors.white,
                      backgroundImage: AdvancedNetworkImage(
                        momentViewer?.avatar ?? '',
                        useDiskCache: true,
                        fallbackAssetImage:
                            'assets/images/fallbacks/avatar-fallback.jpg',
                        retryLimit: 0,
                      ),
                    ),
                    SizedBox(width: width * 0.024),
                    Text(
                      momentViewer?.name ?? '',
                      style: GoogleFonts.openSans(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                /*Row(
                  children: [
                    Text(
                      created ?? '',
                      style: GoogleFonts.openSans(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: width * 0.024),
                  ],
                ),*/
              ],
            ),
            SizedBox(height: width * 0.024),
          ],
        ),
      ),
    );
  }
}
