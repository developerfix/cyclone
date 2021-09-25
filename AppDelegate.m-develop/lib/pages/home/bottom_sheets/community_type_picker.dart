import 'package:Siuu/models/community.dart';
import 'package:Siuu/pages/home/bottom_sheets/rounded_bottom_sheet.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../provider.dart';

// The sheet is stateful as there is a stupid bug that makes CupertinoPicker
// pretty much useless without the bootstrap hack
// https://github.com/flutter/flutter/issues/28109

class OBMemoryTypePickerBottomSheet extends StatefulWidget {
  final ValueChanged<MemoryType> onTypeChanged;

  // Useless for now given the bug
  final MemoryType initialType;

  const OBMemoryTypePickerBottomSheet(
      {Key key, @required this.onTypeChanged, this.initialType})
      : super(key: key);

  @override
  OBMemoryTypePickerBottomSheetState createState() {
    return OBMemoryTypePickerBottomSheetState();
  }
}

class OBMemoryTypePickerBottomSheetState
    extends State<OBMemoryTypePickerBottomSheet> {
  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    LocalizationService _localizationService =
        openbookProvider.localizationService;
    // Hack.
    if (_needsBootstrap) {
      Future.delayed(Duration(milliseconds: 0), () {
        widget.onTypeChanged(MemoryType.values[0]);
      });
      _needsBootstrap = false;
    }

    return OBRoundedBottomSheet(
      child: SizedBox(
        height: 216,
        child: CupertinoPicker(
          backgroundColor: Colors.transparent,
          onSelectedItemChanged: (int index) {
            MemoryType newType = MemoryType.values[index];
            widget.onTypeChanged(newType);
          },
          itemExtent: 32,
          children: <Widget>[
            OBText(_localizationService.trans('community__type_public')),
            OBText(_localizationService.trans('community__type_private'))
          ],
        ),
      ),
    );
  }
}
