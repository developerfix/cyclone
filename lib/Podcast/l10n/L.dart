import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'messages_all.dart';

class L {
  L(this.localeName, this.overrides);

  static Future<L> load(
      Locale locale, Map<String, Map<String, String>> overrides) {
    final name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return L(localeName, overrides);
    });
  }

  static L of(BuildContext context) {
    return Localizations.of<L>(context, L);
  }

  final String localeName;
  Map<String, Map<String, String>> overrides;

  /// Message definitions start here
  String message(String name) {
    if (overrides == null ||
        overrides.isEmpty ||
        !overrides.containsKey(name)) {
      return null;
    } else {
      return overrides[name][localeName] ??
          'Missing translation for $name and locale $localeName';
    }
  }

  /// General
  String get appTitle {
    return message('app_title') ??
        Intl.message(
          'Cyclone Podcast Player',
          name: 'app_title',
          desc: 'Full title for the application',
          locale: localeName,
        );
  }

  String get appTitleShort {
    return message('app_title_short') ??
        Intl.message(
          'Cyclone Player',
          name: 'app_title_short',
          desc: 'Title for the application',
          locale: localeName,
        );
  }

  String get library {
    return message('library') ??
        Intl.message(
          'Library',
          name: 'library',
          desc: 'Library tab label',
          locale: localeName,
        );
  }

  String get discover {
    return message('discover') ??
        Intl.message(
          'Discover',
          name: 'discover',
          desc: 'Discover tab label',
          locale: localeName,
        );
  }

  String get downloads {
    return message('downloads') ??
        Intl.message(
          'Downloads',
          name: 'downloads',
          desc: 'Downloads tab label',
          locale: localeName,
        );
  }

  /// Podcasts
  String get subscribeButtonLabel {
    return message('subscribe_button_label') ??
        Intl.message(
          'SUBSCRIBE',
          name: 'subscribe_button_label',
          desc: 'Subscribe button label',
          locale: localeName,
        );
  }

  String get unsubscribeButtonLabel {
    return message('unsubscribe_button_label') ??
        Intl.message(
          'UNSUBSCRIBE',
          name: 'unsubscribe_button_label',
          desc: 'Unsubscribe button label',
          locale: localeName,
        );
  }

  String get cancelButtonLabel {
    return message('cancel_button_label') ??
        Intl.message(
          'CANCEL',
          name: 'cancel_button_label',
          desc: 'Cancel button label',
          locale: localeName,
        );
  }

  String get okButtonLabel {
    return message('ok_button_label') ??
        Intl.message(
          'OK',
          name: 'ok_button_label',
          desc: 'OK button label',
          locale: localeName,
        );
  }

  String get subscribeLabel {
    return message('subscribe_label') ??
        Intl.message(
          'Subscribe',
          name: 'subscribe_label',
          desc: 'Subscribe label',
          locale: localeName,
        );
  }

  String get unsubscribeLabel {
    return message('unsubscribe_label') ??
        Intl.message(
          'Unsubscribe',
          name: 'unsubscribe_label',
          desc: 'Unsubscribe label',
          locale: localeName,
        );
  }

  String get unsubscribeMessage {
    return message('unsubscribe_message') ??
        Intl.message(
          'Unsubscribing will delete all downloaded episodes of this podcast.',
          name: 'unsubscribe_message',
          desc: 'Displayed when the user unsubscribes from a podcast.',
          locale: localeName,
        );
  }

  String get searchForPodcastsHint {
    return message('search_for_podcasts_hint') ??
        Intl.message(
          'Search for podcasts',
          name: 'search_for_podcasts_hint',
          desc:
              'Hint displayed on search bar when the user clicks the search icon.',
          locale: localeName,
        );
  }

  String get noSubscriptionsMessage {
    return message('no_subscriptions_message') ??
        Intl.message(
          'Tap the Discovery button below or use the search bar above to find your first podcast',
          name: 'no_subscriptions_message',
          desc:
              'Displayed on the library tab when the user has no subscriptions',
          locale: localeName,
        );
  }

  String get deleteLabel {
    return message('delete_label') ??
        Intl.message(
          'Delete',
          name: 'delete_label',
          desc: 'Delete label',
          locale: localeName,
        );
  }

  String get deleteButtonLabel {
    return message('delete_button_label') ??
        Intl.message(
          'DELETE',
          name: 'delete_button_label',
          desc: 'Delete label',
          locale: localeName,
        );
  }

  String get markPlayedLabel {
    return message('mark_played_label') ??
        Intl.message(
          'Mark As Played',
          name: 'mark_played_label',
          desc: 'Mark as played',
          locale: localeName,
        );
  }

  String get markUnplayedLabel {
    return message('mark_unplayed_label') ??
        Intl.message(
          'Mark As Unplayed',
          name: 'mark_unplayed_label',
          desc: 'Mark as unplayed',
          locale: localeName,
        );
  }

  String get deleteEpisodeConfirmation {
    return message('delete_episode_confirmation') ??
        Intl.message(
          'Are you sure you wish to delete this episode?',
          name: 'delete_episode_confirmation',
          desc:
              'User is asked to confirm when they attempt to delete an episode',
          locale: localeName,
        );
  }

  String get deleteEpisodeTitle {
    return message('delete_episode_title') ??
        Intl.message(
          'Delete Episode',
          name: 'delete_episode_title',
          desc: 'Delete label',
          locale: localeName,
        );
  }

  String get noDownloadsMessage {
    return message('no_downloads_message') ??
        Intl.message(
          'You do not have any downloaded episodes',
          name: 'no_downloads_message',
          desc:
              'Displayed on the library tab when the user has no subscriptions',
          locale: localeName,
        );
  }

  String get noSearchResultsMessage {
    return message('no_search_results_message') ??
        Intl.message(
          'No podcasts found',
          name: 'no_search_results_message',
          desc:
              'Displayed on the library tab when the user has no subscriptions',
          locale: localeName,
        );
  }

  String get noPodcastDetailsMessage {
    return message('no_podcast_details_message') ??
        Intl.message(
          'Could not load podcast episodes. Please check your connection.',
          name: 'no_podcast_details_message',
          desc:
              'Displayed on the podcast details page when the details could not be loaded',
          locale: localeName,
        );
  }

  String get playButtonLabel {
    return message('play_button_label') ??
        Intl.message(
          'Play epsiode',
          name: 'play_button_label',
          desc: 'Semantic label for the play button',
          locale: localeName,
        );
  }

  String get pauseButtonLabel {
    return message('pause_button_label') ??
        Intl.message(
          'Pause episode',
          name: 'pause_button_label',
          desc: 'Semantic label for the pause button',
          locale: localeName,
        );
  }

  String get downloadEpisodeButtonLabel {
    return message('download_episode_button_label') ??
        Intl.message(
          'Download episode',
          name: 'download_episode_button_label',
          desc: 'Semantic label for the download episode button',
          locale: localeName,
        );
  }

  String get deleteEpisodeButtonLabel {
    return message('delete_episode_button_label') ??
        Intl.message(
          'Delete episode',
          name: 'delete_episode_button_label',
          desc: 'Semantic label for the delete episode',
          locale: localeName,
        );
  }

  String get closeButtonLabel {
    return message('close_button_label') ??
        Intl.message(
          'Close',
          name: 'close_button_label',
          desc: 'Close button label',
          locale: localeName,
        );
  }

  String get searchButtonLabel {
    return message('search_button_label') ??
        Intl.message(
          'Search',
          name: 'search_button_label',
          desc: 'Search button label',
          locale: localeName,
        );
  }

  String get clearSearchButtonLabel {
    return message('clear_search_button_label') ??
        Intl.message(
          'Clear search text',
          name: 'clear_search_button_label',
          desc: 'Search button label',
          locale: localeName,
        );
  }

  String get searchBackButtonLabel {
    return message('search_back_button_label') ??
        Intl.message(
          'Back',
          name: 'search_back_button_label',
          desc: 'Search button label',
          locale: localeName,
        );
  }

  String get minimisePlayerWindowButtonLabel {
    return message('minimise_player_window_button_label') ??
        Intl.message(
          'Minimise player window',
          name: 'minimise_player_window_button_label',
          desc: 'Search button label',
          locale: localeName,
        );
  }

  String get rewindButtonLabel {
    return message('rewind_button_label') ??
        Intl.message(
          'Rewind episode 30 seconds',
          name: 'rewind_button_label',
          desc: 'Rewind button tooltip',
          locale: localeName,
        );
  }

  String get fastForwardButtonLabel {
    return message('fast_forward_button_label') ??
        Intl.message(
          'Fast-forward episode 30 seconds',
          name: 'fast_forward_button_label',
          desc: 'Fast forward tooltip',
          locale: localeName,
        );
  }

  String get aboutLabel {
    return message('about_label') ??
        Intl.message(
          'About',
          name: 'about_label',
          desc: 'About menu item',
          locale: localeName,
        );
  }

  String get markEpisodesPlayedLabel {
    return message('mark_episodes_played_label') ??
        Intl.message(
          'Mark all episodes as played',
          name: 'mark_episodes_played_label',
          desc: 'Mark all episodes played menu item',
          locale: localeName,
        );
  }

  String get markEpisodesNotPlayedLabel {
    return message('mark_episodes_not_played_label') ??
        Intl.message(
          'Mark all episodes as not-played',
          name: 'mark_episodes_not_played_label',
          desc: 'Mark all episodes not played menu item',
          locale: localeName,
        );
  }

  String get stopDownloadConfirmation {
    return message('stop_download_confirmation') ??
        Intl.message(
          'Are you sure you wish to stop this download and delete the episode?',
          name: 'stop_download_confirmation',
          desc:
              'User is asked to confirm when they wish to stop the active download.',
          locale: localeName,
        );
  }

  String get stopDownloadButtonLabel {
    return message('stop_download_button_label') ??
        Intl.message(
          'STOP',
          name: 'stop_download_button_label',
          desc: 'Stop label',
          locale: localeName,
        );
  }

  String get stopDownloadTitle {
    return message('stop_download_title') ??
        Intl.message(
          'Stop Download',
          name: 'stop_download_title',
          desc: 'Stop download label',
          locale: localeName,
        );
  }

  String get settingsMarkDeletedPlayedLabel {
    return message('settings_mark_deleted_played_label') ??
        Intl.message(
          'Mark deleted episodes as played',
          name: 'settings_mark_deleted_played_label',
          desc: 'Mark deleted episodes as played setting',
          locale: localeName,
        );
  }

  String get settingsDownloadSdCardLabel {
    return message('settings_download_sd_card_label') ??
        Intl.message(
          'Download episodes to SD card',
          name: 'settings_download_sd_card_label',
          desc: 'Download episodes to SD card setting',
          locale: localeName,
        );
  }

  String get settingsDownloadSwitchCard {
    return message('settings_download_switch_card') ??
        Intl.message(
          'New downloads will be saved to the SD card. Existing downloads will remain on internal storage.',
          name: 'settings_download_switch_card',
          desc: 'Displayed when user switches from internal storage to SD card',
          locale: localeName,
        );
  }

  String get settingsDownloadSwitchInternal {
    return message('settings_download_switch_internal') ??
        Intl.message(
          'New downloads will be saved to internal storage. Existing downloads will remain on the SD card.',
          name: 'settings_download_switch_internal',
          desc:
              'Displayed when user switches from internal SD card to internal storage',
          locale: localeName,
        );
  }

  String get settingsDownloadSwitchLabel {
    return message('settings_download_switch_label') ??
        Intl.message(
          'Change storage location',
          name: 'settings_download_switch_label',
          desc: 'Dialog label for storage switch',
          locale: localeName,
        );
  }

  String get cancelOptionLabel {
    return message('cancel_option_label') ??
        Intl.message(
          'Cancel',
          name: 'cancel_option_label',
          desc: 'Cancel option label',
          locale: localeName,
        );
  }

  String get settingsThemeSwitchLabel {
    return message('settings_theme_switch_label') ??
        Intl.message(
          'Dark theme',
          name: 'settings_theme_switch_label',
          desc: 'Dark theme',
          locale: localeName,
        );
  }

  String get playbackSpeedLabel {
    return message('playback_speed_label') ??
        Intl.message(
          'Playback speed',
          name: 'playback_speed_label',
          desc: 'Set playback speed icon label',
          locale: localeName,
        );
  }

  String get showNotesLabel {
    return message('show_notes_label') ??
        Intl.message(
          'Show notes',
          name: 'show_notes_label',
          desc: 'Set show notes icon label',
          locale: localeName,
        );
  }

  String get searchProviderLabel {
    return message('search_provider_label') ??
        Intl.message(
          'Search provider',
          name: 'search_provider_label',
          desc: 'Set search provider label',
          locale: localeName,
        );
  }

  String get settingsLabel {
    return message('settings_label') ??
        Intl.message(
          'Settings',
          name: 'settings_label',
          desc: 'Settings label',
          locale: localeName,
        );
  }

  String get goBackButtonLabel {
    return message('go_back_button_label') ??
        Intl.message(
          'GO BACK',
          name: 'go_back_button_label',
          desc: 'Go-back button label',
          locale: localeName,
        );
  }

  String get continueButtonLabel {
    return message('continue_button_label') ??
        Intl.message(
          'CONTINUE',
          name: 'continue_button_label',
          desc: 'Continue button label',
          locale: localeName,
        );
  }

  String get consentMessage {
    return message('consent_message') ??
        Intl.message(
          'The funding icon appears for Podcasts that support funding or donations. Clicking the icon will open a page to an external site that is provided by the Podcast owner and is not controlled by AnyTime',
          name: 'consent_message',
          desc: 'Display when first accessing external funding link',
          locale: localeName,
        );
  }

  String get episodeLabel {
    return message('episode_label') ??
        Intl.message(
          'Episode',
          name: 'episode_label',
          desc: 'Tab label on now playing screen.',
          locale: localeName,
        );
  }

  String get chaptersLabel {
    return message('chapters_label') ??
        Intl.message(
          'Chapters',
          name: 'chapters_label',
          desc: 'Tab label on now playing screen.',
          locale: localeName,
        );
  }

  String get notesLabel {
    return message('notes_label') ??
        Intl.message(
          'Notes',
          name: 'notes_label',
          desc: 'Tab label on now playing screen.',
          locale: localeName,
        );
  }

  String get podcastFundingDialogHeader {
    return message('podcast_funding_dialog_header') ??
        Intl.message(
          'Podcast Funding',
          name: 'podcast_funding_dialog_header',
          desc: 'Header on podcast funding consent dialog',
          locale: localeName,
        );
  }

  String get settingsAutoOpenNowPlaying {
    return message('settings_auto_open_now_playing') ??
        Intl.message(
          'Full screen player mode on episode start',
          name: 'settings_auto_open_now_playing',
          desc:
              'Displayed when user switches to use full screen player automatically',
          locale: localeName,
        );
  }

  String get errorNoConnection {
    return message('error_no_connection') ??
        Intl.message(
          'Unable to play episode. Please check your connection and try again',
          name: 'error_no_connection',
          desc:
              'Displayed when attempting to start streaming an episode with no data connection',
          locale: localeName,
        );
  }

  String get errorPlaybackFail {
    return message('error_playback_fail') ??
        Intl.message(
          'An unexpected error occurred during playback. Please check your connection and try again',
          name: 'error_playback_fail',
          desc:
              'Displayed when attempting to start streaming an episode with no data connection',
          locale: localeName,
        );
  }

  String get addRssFeedOption {
    return message('add_rss_feed_option') ??
        Intl.message(
          'Add RSS Feed',
          name: 'add_rss_feed_option',
          desc: 'Option label for adding manual RSS feed url',
          locale: localeName,
        );
  }
}

class LocalisationsDelegate extends LocalizationsDelegate<L> {
  const LocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<L> load(Locale locale) => L.load(locale, null);

  @override
  bool shouldReload(LocalisationsDelegate old) => false;
}

class EmbeddedLocalisationsDelegate extends LocalizationsDelegate<L> {
  Map<String, Map<String, String>> messages = {};

  EmbeddedLocalisationsDelegate({@required this.messages});

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<L> load(Locale locale) => L.load(locale, messages);

  @override
  bool shouldReload(EmbeddedLocalisationsDelegate old) => false;
}
