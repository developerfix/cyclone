import 'dart:async';

import 'package:cyclone/Podcast/bloc/podcast/audio_bloc.dart';
import 'package:cyclone/Podcast/l10n/L.dart';
import 'package:cyclone/Podcast/services/audio/audio_player_service.dart';
import 'package:cyclone/Podcast/ui/widgets/speed_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

/// Builds a transport control bar for rewind, play and fast-forward.
/// See [NowPlaying].
class PlayerTransportControls extends StatefulWidget {
  @override
  _PlayerTransportControlsState createState() =>
      _PlayerTransportControlsState();
}

class _PlayerTransportControlsState extends State<PlayerTransportControls>
    with SingleTickerProviderStateMixin {
  AnimationController _playPauseController;
  StreamSubscription<AudioState> _audioStateSubscription;
  bool init = true;

  @override
  void initState() {
    super.initState();

    final audioBloc = Provider.of<AudioBloc>(context, listen: false);

    _playPauseController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    /// Seems a little hacky, but when we load the form we want the play/pause
    /// button to be in the correct state. If we are building the first frame,
    /// just set the animation controller to the correct state; for all other
    /// frames we want to animate. Doing it this way prevents the play/pause
    /// button from animating when the form is first loaded.
    _audioStateSubscription = audioBloc.playingState.listen((event) {
      if (event == AudioState.playing || event == AudioState.buffering) {
        if (init) {
          _playPauseController.value = 1;
          init = false;
        } else {
          _playPauseController.forward();
        }
      } else {
        if (init) {
          _playPauseController.value = 0;
          init = false;
        } else {
          _playPauseController.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    _audioStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    final theme = Theme.of(context);
    final effectiveVisualDensity = theme.visualDensity;

    var unadjustedConstraints = const BoxConstraints(
      minWidth: 24.0,
      minHeight: 24.0,
    );

    final adjustedConstraints =
        effectiveVisualDensity.effectiveConstraints(unadjustedConstraints);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: StreamBuilder<AudioState>(
          stream: audioBloc.playingState,
          builder: (context, snapshot) {
            final audioState = snapshot.data;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ConstrainedBox(
                  constraints: adjustedConstraints,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    return snapshot.data == AudioState.buffering
                        ? null
                        : _rewind(audioBloc);
                  },
                  tooltip: L.of(context).rewindButtonLabel,
                  padding: const EdgeInsets.all(0.0),
                  icon: Icon(
                    Icons.replay_30,
                    size: 48.0,
                    color: Theme.of(context).buttonColor,
                  ),
                ),
                _PlayButton(
                    audioState: audioState,
                    onPlay: () => _play(audioBloc),
                    onPause: () => _pause(audioBloc),
                    playPauseController: _playPauseController),
                IconButton(
                  onPressed: () {
                    return snapshot.data == AudioState.buffering
                        ? null
                        : _fastforward(audioBloc);
                  },
                  padding: const EdgeInsets.all(0.0),
                  icon: Icon(
                    Icons.forward_30,
                    size: 48.0,
                    color: Theme.of(context).buttonColor,
                  ),
                ),
                SpeedSelectorWidget(
                  onChanged: (double value) {
                    audioBloc.playbackSpeed(value);
                  },
                ),
              ],
            );
          }),
    );
  }

  void _play(AudioBloc audioBloc) {
    audioBloc.transitionState(TransitionState.play);
  }

  void _pause(AudioBloc audioBloc) {
    audioBloc.transitionState(TransitionState.pause);
  }

  void _rewind(AudioBloc audioBloc) {
    audioBloc.transitionState(TransitionState.rewind);
  }

  void _fastforward(AudioBloc audioBloc) {
    audioBloc.transitionState(TransitionState.fastforward);
  }
}

class _PlayButton extends StatelessWidget {
  final AudioState audioState;
  final Function() onPlay;
  final Function() onPause;
  final AnimationController playPauseController;

  const _PlayButton(
      {Key key,
      this.audioState,
      this.onPlay,
      this.onPause,
      this.playPauseController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playing = audioState == AudioState.playing;
    final bufferring = audioState == null || audioState == AudioState.buffering;

    // in case we are buffering show progress indicator.
    if (bufferring) {
      return Tooltip(
          message: playing
              ? L.of(context).pauseButtonLabel
              : L.of(context).playButtonLabel,
          child: TextButton(
            style: TextButton.styleFrom(
              shape: CircleBorder(
                  side: BorderSide(
                      color: Theme.of(context).backgroundColor, width: 0.0)),
              padding: const EdgeInsets.all(8.0),
            ),
            onPressed: null,
            child: SpinKitRing(
              lineWidth: 2.0,
              color: Theme.of(context).primaryColor,
              size: 60,
            ),
          ));
    }

    return Tooltip(
      message: playing
          ? L.of(context).pauseButtonLabel
          : L.of(context).playButtonLabel,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: CircleBorder(
              side: BorderSide(
                  color: Theme.of(context).highlightColor, width: 0.0)),
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.orange
              : Colors.grey[800],
          primary: Theme.of(context).brightness == Brightness.light
              ? Colors.orange
              : Colors.grey[800],
          padding: const EdgeInsets.all(8.0),
        ),
        onPressed: () {
          if (playing) {
            onPause();
          } else {
            onPlay();
          }
        },
        child: AnimatedIcon(
          size: 60.0,
          icon: AnimatedIcons.play_pause,
          color: Colors.white,
          progress: playPauseController,
        ),
      ),
    );
  }
}
