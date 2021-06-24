import 'package:cyclone/Podcast/bloc/podcast/audio_bloc.dart';
import 'package:rxdart/rxdart.dart';

/// Base class for all BLoCs to give each one a dispose method
/// which can then be hooked into the dispose() call from Provider.
abstract class Bloc {
  /// Handle lifecycle events
  final PublishSubject<LifecyleState> _lifecycleSubject =
      PublishSubject<LifecyleState>(sync: true);

  Bloc() {
    _init();
  }

  void _init() {
    _lifecycleSubject.listen((state) async {
      if (state == LifecyleState.resume) {
        resume();
      } else if (state == LifecyleState.pause) {
        pause();
      } else if (state == LifecyleState.detach) {
        detach();
      }
    });
  }

  void dispose() {
    if (_lifecycleSubject.hasListener) {
      _lifecycleSubject.close();
    }
  }

  void resume() {}

  void pause() {}

  void detach() {}

  void Function(LifecyleState) get transitionLifecycleState =>
      _lifecycleSubject.sink.add;
}
