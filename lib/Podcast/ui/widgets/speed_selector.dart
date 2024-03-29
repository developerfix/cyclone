import 'package:cyclone/Podcast/bloc/settings/settings_bloc.dart';
import 'package:cyclone/Podcast/entities/app_settings.dart';
import 'package:cyclone/Podcast/l10n/L.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This widget allows the user to change the playback speed. Selecting the playback
/// speed icon will open a dialog box showing the speed options available.
class SpeedSelectorWidget extends StatefulWidget {
  final ValueChanged<double> onChanged;

  SpeedSelectorWidget({this.onChanged});

  @override
  _SpeedSelectorWidgetState createState() => _SpeedSelectorWidgetState();
}

class _SpeedSelectorWidgetState extends State<SpeedSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    var settingsBloc = Provider.of<SettingsBloc>(context);

    var speeds = {
      0: 0.5,
      1: 1.0,
      2: 1.25,
      3: 1.5,
      4: 2.0,
    };

    return StreamBuilder<AppSettings>(
        stream: settingsBloc.settings,
        initialData: AppSettings.sensibleDefaults(),
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Slight temporary hack, but ensures the button is still centrally aligned.
              Text(' ',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Theme.of(context).buttonColor,
                  )),
              IconButton(
                constraints: const BoxConstraints(
                  maxHeight: 24.0,
                  minHeight: 24.0,
                  maxWidth: 24.0,
                  minWidth: 24.0,
                ),
                tooltip: L.of(context).playbackSpeedLabel,
                padding: const EdgeInsets.all(0.0),
                icon: Icon(
                  Icons.speed,
                  size: 24.0,
                  color: Theme.of(context).buttonColor,
                ),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(
                            L.of(context).playbackSpeedLabel,
                          ),
                          content: StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: List<Widget>.generate(speeds.length,
                                    (int index) {
                                  return RadioListTile<double>(
                                    title: Text('x${speeds[index]}'),
                                    value: speeds[index],
                                    groupValue: snapshot.data.playbackSpeed,
                                    onChanged: (double value) {
                                      setState(() {
                                        settingsBloc.setPlaybackSpeed(value);

                                        if (widget.onChanged != null) {
                                          widget.onChanged(value);
                                        }

                                        Navigator.pop(context);
                                      });
                                    },
                                  );
                                }),
                              );
                            },
                          ));
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Text(
                  'x${snapshot.data.playbackSpeed}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Theme.of(context).buttonColor,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
