part of 'audioplayer_cubit.dart';

@immutable
abstract class AudioPlayerState {
  final String currentAudioPath;

  AudioPlayerState({this.currentAudioPath});
}

class AudioPlayerInitial extends AudioPlayerState {
  AudioPlayerInitial() : super(currentAudioPath: null);
}

class AudioPlayerPlay extends AudioPlayerState {
  final String currentAudioPath;
  AudioPlayerPlay({@required this.currentAudioPath})
      : super(currentAudioPath: currentAudioPath);
}

class AudioPlayerPause extends AudioPlayerState {
  final String currentAudioPath;
  AudioPlayerPause({@required this.currentAudioPath})
      : super(currentAudioPath: currentAudioPath);
}
