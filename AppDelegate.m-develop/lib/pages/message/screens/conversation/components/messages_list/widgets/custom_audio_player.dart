import 'package:Siuu/cubit/audioplayer_cubit.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAudioPlayer extends StatefulWidget {
  final String audioPath;
  final int durationInMillis;
  CustomAudioPlayer({
    @required this.audioPath,
    @required this.durationInMillis,
  });

  @override
  _CustomAudioPlayerState createState() => _CustomAudioPlayerState();
}

class _CustomAudioPlayerState extends State<CustomAudioPlayer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
      builder: (context, state) {
        return _buildWithState(state);
      },
    );
  }

  Widget _buildWithState(AudioPlayerState state) {
    AudioPlayerCubit _audioCubit = context.read<AudioPlayerCubit>();

    return Row(
      children: <Widget>[
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            isPlayIcon(state) ? Icons.play_arrow_rounded : Icons.pause_rounded,
            color: widget.audioPath == null
                ? Colors.grey.withOpacity(0.4)
                : Color(pinkColor),
            size: 46,
          ),
          onPressed: widget.audioPath == null
              ? null
              : () async {
                  _audioCubit.playPause(path: widget.audioPath);
                  // assetsAudioPlayer.
                },
        ),
        Expanded(
          child: isStoped(state)
              ? ValueListenableBuilder<int>(
                  valueListenable: _audioCubit.startPosition,
                  builder: (_, value, __) {
                    return Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _audioCubit.currentStopedAudioPath !=
                                    widget.audioPath
                                ? 0
                                : value.toDouble(),
                            max: widget.durationInMillis.toDouble(),
                            onChanged: (v) =>
                                _audioCubit.setStartPos(v, widget.audioPath),
                            activeColor: Color(pinkColor),
                            inactiveColor: Color(pinkColor).withOpacity(.2),
                          ),
                        ),
                        Text(
                          printDuration(
                            Duration(
                              milliseconds: widget.durationInMillis,
                            ),
                          ),
                        ),
                      ],
                    );
                  })
              : ValueListenableBuilder<int>(
                  valueListenable: _audioCubit.currentPos,
                  builder: (_, value, __) {
                    return Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: value > widget.durationInMillis
                                ? 0
                                : isStoped(state)
                                    ? 0
                                    : value.toDouble(),
                            max: widget.durationInMillis.toDouble(),
                            onChanged: _audioCubit.onSeek,
                            onChangeEnd: _audioCubit.onSeekEnd,
                            activeColor: Color(pinkColor),
                            inactiveColor: Color(pinkColor).withOpacity(.2),
                          ),
                        ),
                        Text(
                          printDuration(
                            Duration(
                              milliseconds: isStoped(state)
                                  ? widget.durationInMillis
                                  : value,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
        ),
      ],
    );
  }

  bool isPlayIcon(AudioPlayerState state) {
    if (state is AudioPlayerPlay) {
      return state.currentAudioPath != widget.audioPath;
    }
    return true;
  }

  bool isCurrentPath(String path) {
    return path == widget.audioPath;
  }

  bool isStoped(AudioPlayerState state) {
    return state is AudioPlayerInitial ||
        state.currentAudioPath != widget.audioPath;
  }
}
