import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:Siuu/story/story_view.dart';
import 'package:Siuu/story/widgets/story_view.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';

class FixedStoryView extends StatefulWidget {
  /// The pages to displayed.
  final List<StoryItem> storyItems;

  /// Callback for when a full cycle of story is shown. This will be called
  /// each time the full story completes when [repeat] is set to `true`.
  final VoidCallback onComplete;

  /// Callback for when a vertical swipe gesture is detected. If you do not
  /// want to listen to such event, do not provide it. For instance,
  /// for inline stories inside ListViews, it is preferrable to not to
  /// provide this callback so as to enable scroll events on the list view.
  final Function(Direction) onVerticalSwipeComplete;

  /// Callback for when a story is currently being shown.
  final ValueChanged<StoryItem> onStoryShow;

  /// Where the progress indicator should be placed.
  final ProgressPosition progressPosition;

  /// Should the story be repeated forever?
  final bool repeat;

  /// If you would like to display the story as full-page, then set this to
  /// `false`. But in case you would display this as part of a page (eg. in
  /// a [ListView] or [Column]) then set this to `true`.
  final bool inline;

  // Controls the playback of the stories
  final StoryController controller;

  final FocusNode textFocus;

  FixedStoryView({
    @required this.storyItems,
    @required this.controller,
    this.onComplete,
    this.onStoryShow,
    this.progressPosition = ProgressPosition.top,
    this.repeat = false,
    this.inline = false,
    this.onVerticalSwipeComplete,
    this.textFocus,
  })  : assert(storyItems != null && storyItems.length > 0,
            "[storyItems] should not be null or empty"),
        assert(progressPosition != null, "[progressPosition] cannot be null"),
        assert(
          repeat != null,
          "[repeat] cannot be null",
        ),
        assert(inline != null, "[inline] cannot be null");

  @override
  State<StatefulWidget> createState() {
    return FixedStoryViewState();
  }

  static void onVerticalDragStart(
      {StoryController controller, DragStartDetails details}) {
    controller.pause();
  }

  static void onVerticalDragCancel({StoryController controller}) {
    controller.play("");
  }

  static void onVerticalDragUpdate(
      {StoryController controller, DragUpdateDetails details}) {
    /*if (verticalDragInfo == null) {
      verticalDragInfo = VerticalDragInfo();
    }

    verticalDragInfo.update(details.primaryDelta);*/
  }

  static void onVerticalDragEnd(
      {StoryController controller, DragEndDetails details}) {
    controller.play("");
    // finish up drag cycle
    /*if (!verticalDragInfo.cancel &&
                              widget.onVerticalSwipeComplete != null) {
                            widget.onVerticalSwipeComplete(
                                verticalDragInfo.direction);
                          }

                          verticalDragInfo = null;*/
  }
}

class FixedStoryViewState extends State<FixedStoryView>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _currentAnimation;
  Timer _nextDebouncer;

  StreamSubscription<PlaybackState> _playbackSubscription;

  VerticalDragInfo verticalDragInfo;

  StoryItem get _currentStory =>
      widget.storyItems.firstWhere((it) => !it.shown, orElse: () => null);

  Widget get _currentView => widget.storyItems
      .firstWhere((it) => !it.shown, orElse: () => widget.storyItems.last)
      .view;

  ValueNotifier<double> _opacity;
  @override
  void initState() {
    super.initState();
    _opacity = ValueNotifier(1.0);
    // All pages after the first unshown page should have their shown value as
    // false
    final firstPage = widget.storyItems.firstWhere((it) {
      return !it.shown;
    }, orElse: () {
      widget.storyItems.forEach((it2) {
        it2.shown = false;
      });

      return null;
    });

    if (firstPage != null) {
      final lastShownPos = widget.storyItems.indexOf(firstPage);
      widget.storyItems.sublist(lastShownPos).forEach((it) {
        it.shown = false;
      });
    }

    this._playbackSubscription =
        widget.controller.playbackNotifier.listen((playbackStatus) {
      switch (playbackStatus) {
        case PlaybackState.play:
          _removeNextHold();
          this._animationController?.forward();
          _opacity.value = 1.0;
          break;

        case PlaybackState.pause:
          _holdNext(); // then pause animation
          this._animationController?.stop(canceled: false);
          _opacity.value = 0.0;
          break;

        case PlaybackState.next:
          _removeNextHold();
          _goForward();
          _opacity.value = 1.0;
          break;

        case PlaybackState.previous:
          _removeNextHold();
          _goBack();
          _opacity.value = 1.0;
          break;
      }
    });

    _play();
  }

  @override
  void dispose() {
    _clearDebouncer();

    _animationController?.dispose();
    _playbackSubscription?.cancel();

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _play() {
    _animationController?.dispose();
    // get the next playing page
    final storyItem = widget.storyItems.firstWhere((it) {
      return !it.shown;
    });

    if (widget.onStoryShow != null) {
      widget.onStoryShow(storyItem);
    }

    _animationController =
        AnimationController(duration: storyItem.duration, vsync: this);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        storyItem.shown = true;
        if (widget.storyItems.last != storyItem) {
          _beginPlay();
        } else {
          // done playing
          _onComplete();
        }
      }
    });

    _currentAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_animationController);

    widget.controller.play("");
  }

  void _beginPlay() {
    setState(() {});
    _play();
  }

  void _onComplete() {
    if (widget.onComplete != null) {
      widget.controller.pause();
      widget.onComplete();
    }

    if (widget.repeat) {
      widget.storyItems.forEach((it) {
        it.shown = false;
      });

      _beginPlay();
    }
  }

  void _goBack() {
    _animationController.stop();

    if (this._currentStory == null) {
      widget.storyItems.last.shown = false;
    }

    if (this._currentStory == widget.storyItems.first) {
      _beginPlay();
    } else {
      this._currentStory.shown = false;
      int lastPos = widget.storyItems.indexOf(this._currentStory);
      final previous = widget.storyItems[lastPos - 1];

      previous.shown = false;

      _beginPlay();
    }
  }

  void _goForward() {
    if (this._currentStory != widget.storyItems.last) {
      _animationController.stop();

      // get last showing
      final _last = this._currentStory;

      if (_last != null) {
        _last.shown = true;
        if (_last != widget.storyItems.last) {
          _beginPlay();
        }
      }
    } else {
      // this is the last page, progress animation should skip to end
      _animationController.animateTo(1.0, duration: Duration(milliseconds: 10));
    }
  }

  void _clearDebouncer() {
    _nextDebouncer?.cancel();
    _nextDebouncer = null;
  }

  void _removeNextHold() {
    _nextDebouncer?.cancel();
    _nextDebouncer = null;
  }

  void _holdNext() {
    _nextDebouncer?.cancel();
    _nextDebouncer = Timer(Duration(milliseconds: 500), () {});
  }

  @override
  Widget build(BuildContext context) {
    print('HeeelloO!!');
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          _currentView,
          ValueListenableBuilder(
            valueListenable: _opacity,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: child,
              );
            },
            child: Align(
              alignment: widget.progressPosition == ProgressPosition.top
                  ? Alignment.topCenter
                  : Alignment.bottomCenter,
              child: SafeArea(
                bottom: widget.inline ? false : true,
                // we use SafeArea here for notched and bezeles phones
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: PageBar(
                    widget.storyItems
                        .map((it) => PageData(it.duration, it.shown))
                        .toList(),
                    this._currentAnimation,
                    key: UniqueKey(),
                    indicatorHeight: widget.inline
                        ? IndicatorHeight.small
                        : IndicatorHeight.large,
                  ),
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.centerRight,
              heightFactor: 1,
              child: Container(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapDown: (details) {
                    FocusScope.of(context).unfocus();
                    widget.controller.pause();
                  },
                  onTapCancel: () {
                    print('CANCELLING');
                    widget.controller.play("");
                  },
                  onTapUp: (details) {
                    // if debounce timed out (not active) then continue anim
                    if (_nextDebouncer?.isActive == false) {
                      widget.controller.play("");
                    } else {
                      widget.controller.next();
                    }
                  },
                ),
              )),
          Align(
            alignment: Alignment.centerLeft,
            heightFactor: 1,
            child: SizedBox(
              child: Container(
                  child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (widget.textFocus != null &&
                            widget.textFocus.hasFocus == true) {
                          FocusScope.of(context).unfocus();
                          widget.controller.play("");
                        } else {
                          widget.controller.previous();
                        }
                      }),
                  width: 70),
            ),
          ),
        ],
      ),
    );
  }
}
