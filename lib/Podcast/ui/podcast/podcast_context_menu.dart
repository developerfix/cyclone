import 'package:cyclone/Podcast/bloc/podcast/podcast_bloc.dart';
import 'package:cyclone/Podcast/entities/podcast.dart';
import 'package:cyclone/Podcast/l10n/L.dart';
import 'package:cyclone/Podcast/state/bloc_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// This class is responsible for rendering the context menu on the podcast details
/// page. It returns either a [_MaterialPodcastMenu] or a [_CupertinoContextMenu}
/// instance depending upon which platform we are running on.
///
/// The target platform is based on the current [Theme]: [ThemeData.platform].
class PodcastContextMenu extends StatelessWidget {
  final Podcast podcast;

  PodcastContextMenu(this.podcast);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return _MaterialPodcastMenu(podcast);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return _CupertinoContextMenu(podcast);
    }

    // Not needed, but stops the linter complaining.
    return null;
  }
}

/// This is the material design version of the context menu. This will be rendered
/// for all platforms that are not iOS.
class _MaterialPodcastMenu extends StatelessWidget {
  final Podcast podcast;

  _MaterialPodcastMenu(this.podcast);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PodcastBloc>(context);

    return StreamBuilder<BlocState<Podcast>>(
        stream: bloc.details,
        builder: (context, snapshot) {
          return PopupMenuButton<String>(
            color: Theme.of(context).dialogBackgroundColor,
            onSelected: (event) {
              togglePlayed(value: event, bloc: bloc);
            },
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).buttonColor,
            ),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'ma',
                  enabled: podcast.subscribed,
                  child: Text(L.of(context).markEpisodesPlayedLabel),
                ),
                PopupMenuItem<String>(
                  value: 'ua',
                  enabled: podcast.subscribed,
                  child: Text(L.of(context).markEpisodesNotPlayedLabel),
                ),
              ];
            },
          );
        });
  }

  void togglePlayed({
    @required String value,
    @required PodcastBloc bloc,
  }) {
    if (value == 'ma') {
      bloc.podcastEvent(PodcastEvent.markAllPlayed);
    } else if (value == 'ua') {
      bloc.podcastEvent(PodcastEvent.clearAllPlayed);
    }
  }
}

/// This is the Cupertino context menu and is rendered only when running on
/// an iOS device.
class _CupertinoContextMenu extends StatelessWidget {
  final Podcast podcast;

  _CupertinoContextMenu(this.podcast);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PodcastBloc>(context);

    return StreamBuilder<BlocState<Podcast>>(
        stream: bloc.details,
        builder: (context, snapshot) {
          return IconButton(
            icon: Icon(CupertinoIcons.ellipsis,
                color: Theme.of(context).buttonColor),
            onPressed: () => showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                      isDefaultAction: true,
                      onPressed: () {
                        bloc.podcastEvent(PodcastEvent.markAllPlayed);
                        Navigator.pop(context, 'Cancel');
                      },
                      child: Text(L.of(context).markEpisodesPlayedLabel),
                    ),
                    CupertinoActionSheetAction(
                      isDefaultAction: true,
                      onPressed: () {
                        bloc.podcastEvent(PodcastEvent.clearAllPlayed);
                        Navigator.pop(context, 'Cancel');
                      },
                      child: Text(L.of(context).markEpisodesNotPlayedLabel),
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    },
                    child: Text(L.of(context).cancelOptionLabel),
                  ),
                );
              },
            ),
          );
        });
  }
}
