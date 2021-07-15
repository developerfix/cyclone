import 'package:cyclone/Podcast/bloc/podcast/episode_bloc.dart';
import 'package:cyclone/Podcast/entities/episode.dart';
import 'package:cyclone/Podcast/l10n/L.dart';
import 'package:cyclone/Podcast/state/bloc_state.dart';
import 'package:cyclone/Podcast/ui/widgets/episode_tile.dart';
import 'package:cyclone/Podcast/ui/widgets/platform_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Downloads extends StatefulWidget {
  @override
  _DownloadsState createState() => _DownloadsState();
}

/// Displays a list of podcast episodes that the user has downloaded.
class _DownloadsState extends State<Downloads> {
  @override
  void initState() {
    super.initState();

    final bloc = Provider.of<EpisodeBloc>(context, listen: false);

    bloc.fetchDownloads(false);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EpisodeBloc>(context);

    return StreamBuilder<BlocState>(
      stream: bloc.downloads,
      builder: (BuildContext context, AsyncSnapshot<BlocState> snapshot) {
        final state = snapshot.data;

        if (state is BlocPopulatedState) {
          return buildResults(context, state.results as List<Episode>);
        } else {
          if (state is BlocLoadingState) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  PlatformProgressIndicator(),
                ],
              ),
            );
          } else if (state is BlocErrorState) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Text('ERROR'),
            );
          }

          return SliverFillRemaining(
            hasScrollBody: false,
            child: Container(),
          );
        }
      },
    );
  }

  Widget buildResults(BuildContext context, List<Episode> episodes) {
    if (episodes.isNotEmpty) {
      return SliverList(
          delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return EpisodeTile(
            episode: episodes[index],
            download: false,
            play: true,
          );
        },
        childCount: episodes.length,
        addAutomaticKeepAlives: false,
      ));
    } else {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.cloud_download,
                size: 75,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                L.of(context).noDownloadsMessage,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }
}
