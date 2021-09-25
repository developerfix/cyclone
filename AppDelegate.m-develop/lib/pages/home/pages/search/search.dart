import 'dart:async';

import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

import 'package:Siuu/widgets/avatars/avatar.dart';

import 'package:Siuu/widgets/theming/text.dart';

import 'package:Siuu/models/communities_list.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/hashtag.dart';
import 'package:Siuu/models/hashtags_list.dart';
import 'package:Siuu/models/theme.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/models/users_list.dart';
import 'package:Siuu/pages/home/lib/poppable_page_controller.dart';
import 'package:Siuu/pages/home/pages/search/widgets/top_posts/top_posts.dart';
import 'package:Siuu/pages/home/pages/search/widgets/trending_posts.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/pages/home/pages/search/widgets/search_results.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/theme.dart';
import 'package:Siuu/services/theme_value_parser.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/widgets/search_bar.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:throttling/throttling.dart';

class OBMainSearchPage extends StatefulWidget {
  final OBMainSearchPageController controller;
  final OBSearchPageTab selectedTab;

  const OBMainSearchPage(
      {Key key, this.controller, this.selectedTab = OBSearchPageTab.trending})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBMainSearchPageState();
  }
}

class OBMainSearchPageState extends State<OBMainSearchPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  UserService _userService;
  ToastService _toastService;

  NavigationService _navigationService;
  LocalizationService _localizationService;
  ThemeService _themeService;
  ThemeValueParserService _themeValueParserService;

  List<String> searchlist = new List();
  int count = 0;

  bool _hasSearch;
  bool _userSearchRequestInProgress;
  bool _crewSearchRequestInProgress;
  bool _hashtagSearchRequestInProgress;
  String _searchQuery;
  List<User> _userSearchResults;
  List<Memory> _crewSearchResults;
  List<Hashtag> _hashtagSearchResults;
  OBTopPostsController _topPostsController;
  OBTrendingPostsController _trendingPostsController;
  TabController _tabController;
  AnimationController _animationController;
  Animation<Offset> _offset;
  double _heightTabs;
  double _lastScrollPosition;
  double _extraPaddingForSlidableSection;

  OBUserSearchResultsTab _selectedSearchResultsTab;

  StreamSubscription<UsersList> _getUsersWithQuerySubscription;
  StreamSubscription<CommunitiesList> _getCommunitiesWithQuerySubscription;
  StreamSubscription<HashtagsList> _getHashtagsWithQuerySubscription;

  Throttling _setScrollPositionThrottler;

  static const double OB_BOTTOM_TAB_BAR_HEIGHT = 50.0;
  static const double HEIGHT_SEARCH_BAR = 76.0;
  static const double HEIGHT_TABS_SECTION = 52.0;
  static const double MIN_SCROLL_OFFSET_TO_ANIMATE_TABS = 250.0;

  SharedPreferences _prefs;

  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<void> initState() {
    super.initState();
    _init();
    if (widget.controller != null)
      widget.controller.attach(context: context, state: this);
    _topPostsController = OBTopPostsController();
    _trendingPostsController = OBTrendingPostsController();
    _userSearchRequestInProgress = false;
    _crewSearchRequestInProgress = false;
    _hashtagSearchRequestInProgress = false;
    _hasSearch = false;
    _heightTabs = HEIGHT_TABS_SECTION;
    _userSearchResults = [];
    _crewSearchResults = [];
    _hashtagSearchResults = [];
    _selectedSearchResultsTab = OBUserSearchResultsTab.users;
    _tabController = new TabController(length: 2, vsync: this);
    _setScrollPositionThrottler =
        new Throttling(duration: Duration(milliseconds: 300));
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, -1.0))
        .animate(_animationController);

    switch (widget.selectedTab) {
      case OBSearchPageTab.explore:
        _tabController.index = 1;
        break;
      case OBSearchPageTab.trending:
        _tabController.index = 0;
        break;
      default:
        throw "Unhandled tab index: ${widget.selectedTab}";
    }
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _navigationService = openbookProvider.navigationService;
    _localizationService = openbookProvider.localizationService;
    _themeService = openbookProvider.themeService;
    _themeValueParserService = openbookProvider.themeValueParserService;

    if (_extraPaddingForSlidableSection == null)
      _extraPaddingForSlidableSection = _getExtraPaddingForSlidableSection();

    return OBCupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: OBPrimaryColorContainer(
        child: Stack(
          children: <Widget>[
            _getIndexedStackWidget(),
            _createSearchBarAndTabsOverlay()
          ],
        ),
      ),
    );
  }

  Widget _getIndexedStackWidget() {
    double slidableSectionHeight = HEIGHT_SEARCH_BAR + HEIGHT_TABS_SECTION;

    return IndexedStack(
      index: _hasSearch ? 1 : 0,
      children: <Widget>[
        SafeArea(
          bottom: false,
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: <Widget>[
              // fixme abubakar search buttom

              Container(
                child: Column(
                  children: <Widget>[_remove_All_recent(), _recentSeach()],
                ),
                margin: EdgeInsets.only(top: 60, right: 20, left: 10),
              ),
              /*       OBTrendingPosts(
                  controller: _trendingPostsController,
                  onScrollCallback: _onScrollPositionChange,
                  extraTopPadding: slidableSectionHeight),*/

              OBTopPosts(
                  controller: _topPostsController,
                  onScrollCallback: _onScrollPositionChange,
                  extraTopPadding: slidableSectionHeight),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: HEIGHT_SEARCH_BAR + _extraPaddingForSlidableSection),
          child: OBSearchResults(
            searchQuery: _searchQuery,
            userResults: _userSearchResults,
            userSearchInProgress: _userSearchRequestInProgress,
            crewResults: _crewSearchResults,
            crewSearchInProgress: _crewSearchRequestInProgress,
            hashtagResults: _hashtagSearchResults,
            hashtagSearchInProgress: _hashtagSearchRequestInProgress,
            onUserPressed: _onSearchUserPressed,
            onMemoryPressed: _onSearchMemoryPressed,
            onHashtagPressed: _onSearchHashtagPressed,
            selectedTab: _selectedSearchResultsTab,
            onScroll: _onScrollSearchResults,
            onTabSelectionChanged: _onSearchTabSelectionChanged,
          ),
        ),
      ],
    );
  }

  double _getExtraPaddingForSlidableSection() {
    MediaQueryData existingMediaQuery = MediaQuery.of(context);
    // flutter has diff heights for notched phones, see also issues with bottom tab bar
    // iphone with notches have a top/bottom padding
    // this adds 20.0 extra padding for notched phones
    if (existingMediaQuery.padding.top != 0 &&
        existingMediaQuery.padding.bottom != 0) return 20.0;
    return 0.0;
  }

  Widget _createSearchBarAndTabsOverlay() {
    MediaQueryData existingMediaQuery = MediaQuery.of(context);

    // fixme abubakar tab hight
    return Positioned(
        left: 0,
        top: 0,
        height: HEIGHT_SEARCH_BAR + _extraPaddingForSlidableSection + 10,
        width: existingMediaQuery.size.width,
        child: OBCupertinoPageScaffold(
          backgroundColor: Colors.transparent,
          child: _getSlideTransitionWidget(),
        ));
  }

  Future<bool> clear() {
    if (_prefs == null) return null;
    return _prefs.clear();
  }

  Widget _remove_All_recent() {
    List<Map> recentSerch = getObjectList("search");

    return Align(
      alignment: Alignment.topRight,
      child: recentSerch != null
          ? GestureDetector(
              onTap: () {
                clear();
                setState(() {});
              },
              child: Text("Clear Searches"),
            )
          : Text(""),
    );
  }

  Widget _recentSeach() {
    List<Map> recentSerch = getObjectList("search");
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: recentSerch != null ? recentSerch.length : 1,
      itemBuilder: (context, position) {
        return recentSerch != null
            ? ListTile(
                onTap: () {
                  _onSearch(recentSerch[position]["username"]);
                },
                leading: OBAvatar(
                  username: recentSerch[position]["username"],
                  size: OBAvatarSize.medium,
                  avatarUrl: recentSerch[position]["profile"]["avatar"],
                ),
                title: Row(children: <Widget>[
                  OBText(
                    recentSerch[position]["username"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ]),
              )
            : Text(
                'No recent search',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[800], fontSize: 16),
              );
      },
    );
  }

  Widget _getSlideTransitionWidget() {
    OBTheme theme = _themeService.getActiveTheme();
    Color tabIndicatorColor = _themeValueParserService
        .parseGradient(theme.primaryAccentColor)
        .colors[1];
    Color tabLabelColor =
        _themeValueParserService.parseColor(theme.primaryTextColor);

    return SlideTransition(
      position: _offset,
      child: OBPrimaryColorContainer(
        child: SafeArea(
          bottom: false,
          child: Wrap(
            alignment: WrapAlignment.start,
            children: <Widget>[
              OBSearchBar(
                onSearch: _onSearch,
                hintText: _localizationService.user_search__search_text,
              ),
              const SizedBox(height: 0)
/*
                  : TabBar(
                      controller: _tabController,
                      tabs: <Widget>[
                        Tab(
                          icon: OBIcon(OBIcons.trending),
                        ),
                        Tab(
                          icon: OBIcon(OBIcons.explore),
                        ),
                      ],
                      isScrollable: false,
                      indicatorColor: tabIndicatorColor,
                      labelColor: tabLabelColor,
                    ),
*/
            ],
          ),
        ),
      ),
    );
  }

  void _onScrollPositionChange(ScrollPosition position) {
    bool isScrollingUp =
        position.userScrollDirection == ScrollDirection.forward;
    _hideKeyboard();
    if (position.pixels < (HEIGHT_SEARCH_BAR + HEIGHT_TABS_SECTION)) {
      if (_offset.value.dy == -1.0) _showTabSection();
      return;
    }
    _setScrollPositionThrottler
        .throttle(() => _handleScrollThrottle(position.pixels, isScrollingUp));
  }

  void _handleScrollThrottle(double scrollPixels, bool isScrollingUp) {
    if (_lastScrollPosition != null) {
      double offset = (scrollPixels - _lastScrollPosition).abs();
      if (offset > MIN_SCROLL_OFFSET_TO_ANIMATE_TABS)
        _checkScrollDirectionAndAnimateTabs(isScrollingUp);
    }
    _setScrollPosition(scrollPixels);
  }

  void _checkScrollDirectionAndAnimateTabs(bool isScrollingUp) {
    if (isScrollingUp) {
      _showTabSection();
    } else {
      _hideTabSection();
    }
  }

  void _setScrollPosition(double scrollPixels) {
    setState(() {
      _lastScrollPosition = scrollPixels;
    });
  }

  void _onSearch(String query) {
    print("quesry::$query");
    _setSearchQuery(query);
    if (query.isEmpty) {
      _setHasSearch(false);
      return;
    }

    if (_hasSearch == false) {
      _setHasSearch(true);
    }

    _searchWithQuery(query);
  }

  void _onScrollSearchResults() {
    _hideKeyboard();
  }

  void _hideKeyboard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Future<void> _searchWithQuery(String query) {
    String cleanedUpQuery = _cleanUpQuery(query);
    if (cleanedUpQuery.isEmpty) return null;

    return Future.wait([
      _searchForUsersWithQuery(cleanedUpQuery),
      _searchForCommunitiesWithQuery(cleanedUpQuery),
      _searchForHashtagsWithQuery(cleanedUpQuery)
    ]);
  }

  final hashtagAndUsernamesRegexp = RegExp(r'^#|@');

  String _cleanUpQuery(String query) {
    String cleanQuery = query;
    if (cleanQuery.startsWith(hashtagAndUsernamesRegexp)) {
      print("ifffffffffff");

      cleanQuery = cleanQuery.substring(1, cleanQuery.length);
    } else if (cleanQuery.startsWith('c/')) {
      print("elseeeeeeeeeee");
      cleanQuery = cleanQuery.substring(2, cleanQuery.length);
    }
    return cleanQuery;
  }

  Future<void> _searchForUsersWithQuery(String query) async {
    // fixme working

    // searchlist.add(query);

    // putStringList("search",searchlist);

    if (_getUsersWithQuerySubscription != null)
      _getUsersWithQuerySubscription.cancel();

    _setUserSearchRequestInProgress(true);
    _getUsersWithQuerySubscription =
        _userService.getUsersWithQuery(query).asStream().listen(
            (UsersList usersList) {
              _getUsersWithQuerySubscription = null;
              _setUserSearchResults(usersList.users);
            },
            onError: _onError,
            onDone: () {
              _setUserSearchRequestInProgress(false);
            });
  }

  Future<void> _searchForCommunitiesWithQuery(String query) async {
    if (_getCommunitiesWithQuerySubscription != null)
      _getCommunitiesWithQuerySubscription.cancel();

    _setMemorySearchRequestInProgress(true);

    _getCommunitiesWithQuerySubscription =
        _userService.searchCommunitiesWithQuery(query).asStream().listen(
            (CommunitiesList memoriesList) {
              _setMemorySearchResults(memoriesList.memories);
            },
            onError: _onError,
            onDone: () {
              _setMemorySearchRequestInProgress(false);
            });
  }

  Future<void> _searchForHashtagsWithQuery(String query) async {
    if (_getHashtagsWithQuerySubscription != null)
      _getHashtagsWithQuerySubscription.cancel();

    _setHashtagSearchRequestInProgress(true);

    _getHashtagsWithQuerySubscription =
        _userService.getHashtagsWithQuery(query).asStream().listen(
            (HashtagsList hashtagsList) {
              _setHashtagSearchResults(hashtagsList.hashtags);
            },
            onError: _onError,
            onDone: () {
              _setHashtagSearchRequestInProgress(false);
            });
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  void _onSearchTabSelectionChanged(OBUserSearchResultsTab newSelection) {
    _selectedSearchResultsTab = newSelection;
  }

  void _setUserSearchRequestInProgress(bool requestInProgress) {
    setState(() {
      _userSearchRequestInProgress = requestInProgress;
    });
  }

  void _setMemorySearchRequestInProgress(bool requestInProgress) {
    setState(() {
      _crewSearchRequestInProgress = requestInProgress;
    });
  }

  void _setHashtagSearchRequestInProgress(bool requestInProgress) {
    setState(() {
      _hashtagSearchRequestInProgress = requestInProgress;
    });
  }

  void _hideTabSection() {
    _animationController.forward();
  }

  void _showTabSection() {
    _animationController.reverse();
  }

  void _setHasSearch(bool hasSearch) {
    setState(() {
      _hasSearch = hasSearch;
    });
    _setHeightTabsZero(_hasSearch);
  }

  void _setHeightTabsZero(bool hasSearch) {
    setState(() {
      _heightTabs = hasSearch == true ? 5.0 : HEIGHT_TABS_SECTION;
    });
  }

  void _setSearchQuery(String searchQuery) {
    setState(() {
      _searchQuery = searchQuery;
    });
  }

  void _setUserSearchResults(List<User> searchResults) {
    setState(() {
      _userSearchResults = searchResults;
    });
  }

  void _setMemorySearchResults(List<Memory> searchResults) {
    setState(() {
      _crewSearchResults = searchResults;
    });
  }

  void _setHashtagSearchResults(List<Hashtag> searchResults) {
    setState(() {
      _hashtagSearchResults = searchResults;
    });
  }

  void _onSearchUserPressed(User user) {
    _hideKeyboard();
    _navigationService.navigateToUserProfile(user: user, context: context);
  }

  void _onSearchMemoryPressed(Memory crew) {
    _hideKeyboard();
    _navigationService.navigateToMemory(crew: crew, context: context);
  }

  void _onSearchHashtagPressed(Hashtag hashtag) {
    _hideKeyboard();
    _navigationService.navigateToHashtag(hashtag: hashtag, context: context);
  }

  void scrollToTop() {
    if (_tabController.index == 0) {
      _trendingPostsController.scrollToTop();
    } else if (_tabController.index == 1) {
      _topPostsController.scrollToTop();
    }
  }

  List<Map> getObjectList(String key) {
    if (_prefs == null) return null;
    List<String> dataLis = _prefs.getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    })?.toList();
  }
}

class OBMainSearchPageController extends PoppablePageController {
  OBMainSearchPageState _state;

  void attach({@required BuildContext context, OBMainSearchPageState state}) {
    super.attach(context: context);
    _state = state;
  }

  void scrollToTop() {
    _state.scrollToTop();
  }
}

enum OBSearchPageTab { explore, trending }
