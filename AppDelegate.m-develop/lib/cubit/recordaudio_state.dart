part of 'recordaudio_cubit.dart';

@immutable
abstract class RecordaudioState {}

class RecordAudioReady extends RecordaudioState {}

class RecordAudioStarted extends RecordaudioState {}

class RecordAudioClosed extends RecordaudioState {}
