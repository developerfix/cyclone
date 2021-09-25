import 'package:Siuu/models/community.dart';
import 'package:Siuu/widgets/avatars/community_avatar.dart';
import 'package:flutter/material.dart';
import 'widgets/community_actions/community_actions.dart';
import 'widgets/community_buttons.dart';
import 'widgets/community_categories.dart';
import 'widgets/community_description.dart';
import 'widgets/community_details/community_details.dart';
import 'widgets/community_name.dart';
import 'widgets/community_title.dart';

class OBMemoryCard extends StatelessWidget {
  final Memory crew;

  OBMemoryCard(this.crew);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 30.0, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              OBMemoryAvatar(
                crew: crew,
                size: OBAvatarSize.large,
                isZoomable: true,
              ),
              Expanded(child: OBMemoryActions(crew)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OBMemoryTitle(crew),
              OBMemoryName(crew),
              OBMemoryDescription(crew),
              const SizedBox(
                height: 15,
              ),
              OBMemoryDetails(crew),
              OBMemoryCategories(crew),
              const SizedBox(
                height: 10,
              ),
              OBMemoryButtons(
                crew: crew,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
