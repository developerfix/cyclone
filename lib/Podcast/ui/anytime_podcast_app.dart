import 'package:cyclone/Podcast/api/podcast/mobile_podcast_api.dart';
import 'package:cyclone/Podcast/bloc/discovery/discovery_bloc.dart';
import 'package:cyclone/Podcast/bloc/podcast/audio_bloc.dart';
import 'package:cyclone/Podcast/bloc/podcast/episode_bloc.dart';
import 'package:cyclone/Podcast/bloc/podcast/podcast_bloc.dart';
import 'package:cyclone/Podcast/bloc/search/search_bloc.dart';
import 'package:cyclone/Podcast/bloc/settings/settings_bloc.dart';
import 'package:cyclone/Podcast/bloc/ui/pager_bloc.dart';
import 'package:cyclone/Podcast/core/chrome.dart';
import 'package:cyclone/Podcast/l10n/L.dart';
import 'package:cyclone/Podcast/repository/repository.dart';
import 'package:cyclone/Podcast/repository/sembast/sembast_repository.dart';
import 'package:cyclone/Podcast/services/audio/audio_player_service.dart';
import 'package:cyclone/Podcast/services/audio/mobile_audio_player_service.dart';
import 'package:cyclone/Podcast/services/download/download_service.dart';
import 'package:cyclone/Podcast/services/download/mobile_download_manager.dart';
import 'package:cyclone/Podcast/services/download/mobile_download_service.dart';
import 'package:cyclone/Podcast/services/podcast/mobile_podcast_service.dart';
import 'package:cyclone/Podcast/services/podcast/podcast_service.dart';
import 'package:cyclone/Podcast/services/settings/mobile_settings_service.dart';
import 'package:cyclone/Podcast/ui/library/discovery.dart';
import 'package:cyclone/Podcast/ui/library/downloads.dart';
import 'package:cyclone/Podcast/ui/library/library.dart';
import 'package:cyclone/Podcast/ui/podcast/mini_player.dart';
import 'package:cyclone/Podcast/ui/search/search.dart';
import 'package:cyclone/Podcast/ui/themes.dart';
import 'package:cyclone/Podcast/ui/widgets/search_slide_route.dart';
import 'package:cyclone/utils/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

var theme = Themes.lightTheme().themeData;

// ignore: must_be_immutable
class AnytimePodcastApp extends StatefulWidget {
  final Repository repository;
  final MobilePodcastApi podcastApi;
  DownloadService downloadService;
  PodcastService podcastService;
  AudioPlayerService audioPlayerService;
  SettingsBloc settingsBloc;
  MobileSettingsService mobileSettingsService;

  AnytimePodcastApp(this.mobileSettingsService)
      : repository = SembastRepository(),
        podcastApi = MobilePodcastApi() {
    downloadService = MobileDownloadService(
      repository: repository,
      downloadManager: MobileDownloaderManager(),
    );
    podcastService = MobilePodcastService(
      api: podcastApi,
      repository: repository,
      settingsService: mobileSettingsService,
    );
    audioPlayerService = MobileAudioPlayerService(
      repository: repository,
      settingsService: mobileSettingsService,
      podcastService: podcastService,
    );
    settingsBloc = SettingsBloc(mobileSettingsService);
  }

  @override
  _AnytimePodcastAppState createState() => _AnytimePodcastAppState();
}

class _AnytimePodcastAppState extends State<AnytimePodcastApp> {
  ThemeData theme;

  @override
  void initState() {
    super.initState();

    widget.settingsBloc.settings.listen((event) {
      setState(() {
        var newTheme = event.theme == 'dark'
            ? Themes.darkTheme().themeData
            : Themes.lightTheme().themeData;

        /// Only update the theme if it has changed.
        if (newTheme != theme) {
          theme = newTheme;

          if (event.theme == 'dark') {
            Chrome.transparentDark();
          } else {
            Chrome.transparentLight();
          }
        }
      });
    });

    if (widget.mobileSettingsService.themeDarkMode) {
      theme = Themes.darkTheme().themeData;

      Chrome.transparentDark();
    } else {
      Chrome.transparentLight();

      theme = Themes.lightTheme().themeData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SearchBloc>(
          create: (_) => SearchBloc(
              podcastService: MobilePodcastService(
            api: widget.podcastApi,
            repository: widget.repository,
            settingsService: widget.mobileSettingsService,
          )),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<DiscoveryBloc>(
          create: (_) => DiscoveryBloc(
              podcastService: MobilePodcastService(
            api: widget.podcastApi,
            repository: widget.repository,
            settingsService: widget.mobileSettingsService,
          )),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<EpisodeBloc>(
          create: (_) => EpisodeBloc(
              podcastService: MobilePodcastService(
                api: widget.podcastApi,
                repository: widget.repository,
                settingsService: widget.mobileSettingsService,
              ),
              audioPlayerService: widget.audioPlayerService),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<PodcastBloc>(
          create: (_) => PodcastBloc(
              podcastService: widget.podcastService,
              audioPlayerService: widget.audioPlayerService,
              downloadService: widget.downloadService),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<PagerBloc>(
          create: (_) => PagerBloc(),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<AudioBloc>(
          create: (_) =>
              AudioBloc(audioPlayerService: widget.audioPlayerService),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<SettingsBloc>(
          create: (_) => widget.settingsBloc,
          dispose: (_, value) => value.dispose(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          const LocalisationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('de', ''),
        ],
        theme: theme,
        home: AnytimeHomePage(title: 'Cyclone Podcasts'),
      ),
    );
  }
}

class AnytimeHomePage extends StatefulWidget {
  final String title;
  final bool topBarVisible;
  final bool inlineSearch;

  AnytimeHomePage(
      {this.title, this.topBarVisible = true, this.inlineSearch = false});

  @override
  _AnytimeHomePageState createState() => _AnytimeHomePageState();
}

class _AnytimeHomePageState extends State<AnytimeHomePage>
    with WidgetsBindingObserver {
  final log = Logger('_AnytimeHomePageState');
  Widget library;

  @override
  void initState() {
    super.initState();

    final audioBloc = Provider.of<AudioBloc>(context, listen: false);

    WidgetsBinding.instance.addObserver(this);

    audioBloc.transitionLifecycleState(LifecyleState.resume);
  }

  @override
  void dispose() {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    audioBloc.transitionLifecycleState(LifecyleState.pause);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);

    switch (state) {
      case AppLifecycleState.resumed:
        audioBloc.transitionLifecycleState(LifecyleState.resume);
        break;
      case AppLifecycleState.paused:
        audioBloc.transitionLifecycleState(LifecyleState.pause);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pager = Provider.of<PagerBloc>(context);
    final searchBloc = Provider.of<EpisodeBloc>(context);
    final backgroundColour = Theme.of(context).scaffoldBackgroundColor;
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      backgroundColor: backgroundColour,
      body: Column(
        children: <Widget>[
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverVisibility(
                  visible: widget.topBarVisible,
                  sliver: SliverAppBar(
                    title: TitleWidget(),
                    brightness: brightness,
                    // backgroundColor: backgroundColour,
                    floating: false,
                    pinned: true,
                    snap: false,
                    // actions: <Widget>[
                    //   IconButton(
                    //     tooltip: L.of(context).search_button_label,
                    //     icon: Icon(Icons.search),
                    //     onPressed: () async {
                    //       await Navigator.push(
                    //         context,
                    //         SlideRightRoute(widget: Search()),
                    //       );
                    //     },
                    //   ),
                    // ],
                  ),
                ),
                StreamBuilder<int>(
                    stream: pager.currentPage,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      return _fragment(snapshot.data, searchBloc);
                    }),
              ],
            ),
          ),
          MiniPlayer(),
        ],
      ),
      bottomNavigationBar: StreamBuilder<int>(
          stream: pager.currentPage,
          initialData: 0,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).bottomAppBarColor,
              selectedIconTheme: Theme.of(context).iconTheme,
              selectedItemColor: Theme.of(context).iconTheme.color,
              unselectedItemColor:
                  HSLColor.fromColor(Theme.of(context).bottomAppBarColor)
                      .withLightness(0.8)
                      .toColor(),
              currentIndex: snapshot.data,
              onTap: pager.changePage,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_music),
                  label: L.of(context).library,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore),
                  label: L.of(context).discover,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.file_download),
                  label: L.of(context).downloads,
                ),
              ],
            );
          }),
    );
  }

  Widget _fragment(int index, EpisodeBloc searchBloc) {
    if (index == 0) {
      return Library();
    } else if (index == 1) {
      return Discovery(inlineSearch: widget.inlineSearch);
    } else {
      return Downloads();
    }
  }
}

class TitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: linearGradient),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/svg/logo.svg'),
                SizedBox(
                  width: 10,
                ),
                new Text(
                  "Cyclone Podcasts",
                  style: TextStyle(
                      fontFamily: "Billabong",
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                      color: Colors.white),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              tooltip: L.of(context).searchButtonLabel,
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () async {
                await Navigator.push(
                  context,
                  SlideRightRoute(widget: Search()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
