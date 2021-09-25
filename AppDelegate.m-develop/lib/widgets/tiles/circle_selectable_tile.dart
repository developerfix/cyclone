import 'package:Siuu/libs/pretty_count.dart';
import 'package:Siuu/models/circle.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/circle_color_preview.dart';
import 'package:Siuu/widgets/fields/checkbox_field.dart';
import 'package:flutter/material.dart';

import '../../provider.dart';

class OBCircleSelectableTile extends StatelessWidget {
  final Circle circle;
  final OnCirclePressed onCirclePressed;
  final bool isSelected;
  final bool isDisabled;

  const OBCircleSelectableTile(this.circle,
      {Key key, this.onCirclePressed, this.isSelected, this.isDisabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int usersCount = circle.usersCount;
    LocalizationService localizationService = OpenbookProvider.of(context).localizationService;
    String prettyCount =  getPrettyCount(usersCount, localizationService);
    return OBCheckboxField(
      isDisabled: isDisabled,
      value: isSelected,
      title: circle.name,
      subtitle:
          usersCount != null ? localizationService.user__circle_peoples_count(prettyCount) : null,
      onTap: () {
        onCirclePressed(circle);
      },
      leading: SizedBox(
        height: 40,
        width: 40,
        child: Center(
          child: OBCircleColorPreview(
            circle,
            size: OBCircleColorPreviewSize.small,
          ),
        ),
      ),
    );
  }
}

typedef void OnCirclePressed(Circle pressedCircle);
