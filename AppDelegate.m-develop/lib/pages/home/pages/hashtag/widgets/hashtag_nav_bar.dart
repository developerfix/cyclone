import 'package:Siuu/models/hashtag.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/widgets/hashtag.dart';
import 'package:Siuu/widgets/more_buttons/hashtag_more_button.dart';
import 'package:Siuu/widgets/nav_bars/image_nav_bar.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/posts_count.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBHashtagNavBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final Hashtag hashtag;
  final String rawHashtagName;

  const OBHashtagNavBar({Key key, this.hashtag, this.rawHashtagName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    final Color hashtagTextColor =
        openbookProvider.utilsService.parseHexColor(hashtag.textColor);

    return StreamBuilder(
        stream: hashtag.updateSubject,
        initialData: hashtag,
        builder: (BuildContext context, AsyncSnapshot<Hashtag> snapshot) {
          var hashtag = snapshot.data;

          return hashtag.image != null
              ? OBImageNavBar(
                  trailing: OBHashtagMoreButton(
                    hashtag: hashtag,
                  ),
                  imageSrc: hashtag.image,
                  middle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      OBHashtag(
                        textStyle: TextStyle(color: Colors.white),
                          hashtag: hashtag, rawHashtagName: rawHashtagName),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Text(
                          '·',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      OBPostsCount(
                        hashtag.postsCount,
                        color: Colors.white,
                        showZero: true,
                      )
                    ],
                  ),
                  textColor: hashtagTextColor)
              : OBThemedNavigationBar(
                  trailing: OBHashtagMoreButton(
                    hashtag: hashtag,
                  ),
                  middle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      OBHashtag(
                        hashtag: hashtag,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: OBText('·'),
                      ),
                      OBPostsCount(
                        hashtag.postsCount,
                        showZero: true,
                      )
                    ],
                  ));
        });
  }

  bool get fullObstruction {
    return true;
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(44);
  }

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}
