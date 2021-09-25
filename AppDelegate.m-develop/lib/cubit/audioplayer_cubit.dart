import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
part 'audioplayer_state.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  final AudioPlayer player = AudioPlayer();

  ValueNotifier<int> currentPos = ValueNotifier(0);
  ValueNotifier<int> startPosition = ValueNotifier(0);
  String currentStopedAudioPath = '';

  AudioPlayerCubit() : super(AudioPlayerInitial()) {
    player.onAudioPositionChanged.listen((event) {
      currentPos.value = event.inMilliseconds;
    });
    player.onPlayerCompletion.listen((event) {
      stop();
    });
  }

  void playPause({String path}) async {
    if (player.state == PlayerState.PLAYING) {
      if (path == state.currentAudioPath) {
        pause();
      } else {
        play(path);
      }
    } else {
      if (player.state == PlayerState.PAUSED) {
        if (path == state.currentAudioPath) {
          resume();
        } else {
          play(path);
        }
      } else {
        play(path);
      }
    }
  }

  void play(path) async {
    try {
      currentStopedAudioPath = '';
      // audioPlayer.seekToPlayer(Duration(milliseconds: startPosition.value));

      currentPos.value = startPosition.value;
      int result = await player.play(path,
          position: Duration(milliseconds: startPosition.value));
      startPosition.value = 0;
      log('play result : $result');

      if (result == 1) {
        emitPlay(path);
      } else {
        stop();
      }
    } catch (e) {
      stop();
    }
  }

  void pause() async {
    AudioPlayerPlay s = state as AudioPlayerPlay;
    emitPause(s.currentAudioPath);
    int result = await player.pause();
    log('pause result : $result');
  }

  void resume() async {
    try {
      AudioPlayerPause s = state as AudioPlayerPause;
      emitPlay(s.currentAudioPath);
      int result = await player.resume();
      log('resume result : $result');
    } catch (e) {
      stop();
    }
  }

  void stop() async {
    startPosition.value = 0;
    currentStopedAudioPath = '';
    try {
      int result = await player.stop();
      log('stop result : $result');
      emitStop();
    } catch (e) {}
  }

  void emitPlay(path) => emit(AudioPlayerPlay(currentAudioPath: path));

  void emitPause(path) => emit(AudioPlayerPause(currentAudioPath: path));

  void emitStop() => emit(AudioPlayerInitial());

  void onSeek(double position) {
    pause();
    currentPos.value = position.toInt();
  }

  void onSeekEnd(double position) {
    currentPos.value = position.toInt();
    player.seek(Duration(milliseconds: position.toInt()));
    resume();
  }

  void setStartPos(double position, String path) {
    currentStopedAudioPath = path;
    startPosition.value = position.toInt();
  }

  @override
  Future<void> close() {
    log('player bloc closed');
    stop();
    currentPos.dispose();
    startPosition.dispose();
    try {
      player.dispose();
    } catch (e) {}
    return super.close();
  }
}
