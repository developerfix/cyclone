import 'dart:convert';

import 'package:Siuu/models/UserStory.dart';
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

class MemoryViewersPage extends StatefulWidget {
  final Story story;

  const MemoryViewersPage({
    @required this.story,
  });

  @override
  _MemoryViewersPageState createState() => _MemoryViewersPageState();
}

class _MemoryViewersPageState extends State<MemoryViewersPage> {
  ValueNotifier<MomentViewers> momentViewers;
  UserService userService;
  Future<MomentViewers> futuremomentViewers;

  @override
  void initState() {
    super.initState();
    momentViewers = ValueNotifier(null);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var provider = OpenbookProvider.of(context);
    userService = provider.userService;
    if (futuremomentViewers == null) {
      futuremomentViewers =
          userService.getMomentViewers(storyId: widget.story.id);
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      appBar: OBThemedNavigationBar(
        title: 'Moment Viewers ${momentViewers.value?.viewers?.length ?? 0}',
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
    return FutureBuilder<MomentViewers>(
      future: futuremomentViewers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (momentViewers.value == null) momentViewers.value = snapshot.data;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {});
          });
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: momentViewers.value?.viewers?.length ?? 0,
            itemBuilder: (context, index) {
              return momentViewer(momentViewers.value.viewers[index]);
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

  Widget momentViewer(MomentViewer momentViewer) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var openbookProvider = OpenbookProvider.of(context);
    var localizationService = openbookProvider.localizationService;
    var utilsService = openbookProvider.utilsService;
    String created =
        utilsService.timeAgo(momentViewer.viewTime, localizationService);
    return GestureDetector(
      onTap: () {
        var provider = OpenbookProvider.of(context);
        var navigationService = provider.navigationService;
        navigationService.navigateToUserProfile(
            user: momentViewer?.user, context: context);
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
                        momentViewer?.user?.profile?.avatar ?? '',
                        useDiskCache: true,
                        fallbackAssetImage:
                            'assets/images/fallbacks/avatar-fallback.jpg',
                        retryLimit: 0,
                      ),
                    ),
                    SizedBox(width: width * 0.024),
                    Text(
                      momentViewer?.user?.profile?.name ?? '',
                      style: GoogleFonts.openSans(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
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
                ),
              ],
            ),
            SizedBox(height: width * 0.024),
          ],
        ),
      ),
    );
  }
}
