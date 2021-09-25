import 'dart:io';

import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/string_template.dart';
import 'package:meta/meta.dart';

class CommunitiesApiService {
  HttpieService _httpService;
  StringTemplateService _stringTemplateService;

  String apiURL;

  static const SEARCH_COMMUNITIES_PATH = 'api/communities/search/';
  static const GET_TRENDING_COMMUNITIES_PATH = 'api/communities/trending/';
  static const GET_SUGGESTED_COMMUNITIES_PATH = 'api/communities/suggested/';
  static const GET_JOINED_COMMUNITIES_PATH = 'api/communities/joined/';
  static const SEARCH_JOINED_COMMUNITIES_PATH =
      'api/communities/joined/search/';
  static const CHECK_COMMUNITY_NAME_PATH = 'api/communities/name-check/';
  static const CREATE_COMMUNITY_PATH = 'api/communities/';
  static const DELETE_COMMUNITY_PATH = 'api/communities/{communityName}/';
  static const UPDATE_COMMUNITY_PATH = 'api/communities/{communityName}/';
  static const GET_COMMUNITY_PATH = 'api/communities/{communityName}/';
  static const REPORT_COMMUNITY_PATH =
      'api/communities/{communityName}/report/';
  static const JOIN_COMMUNITY_PATH =
      'api/communities/{communityName}/members/join/';
  static const LEAVE_COMMUNITY_PATH =
      'api/communities/{communityName}/members/leave/';
  static const INVITE_USER_TO_COMMUNITY_PATH =
      'api/communities/{communityName}/members/invite/';
  static const UNINVITE_USER_TO_COMMUNITY_PATH =
      'api/communities/{communityName}/members/uninvite/';
  static const BAN_COMMUNITY_USER_PATH =
      'api/communities/{communityName}/banned-users/ban/';
  static const UNBAN_COMMUNITY_USER_PATH =
      'api/communities/{communityName}/banned-users/unban/';
  static const SEARCH_COMMUNITY_BANNED_USERS_PATH =
      'api/communities/{communityName}/banned-users/search/';
  static const COMMUNITY_AVATAR_PATH =
      'api/communities/{communityName}/avatar/';
  static const COMMUNITY_COVER_PATH = 'api/communities/{communityName}/cover/';
  static const SEARCH_COMMUNITY_PATH =
      'api/communities/{communityName}/search/';
  static const FAVORITE_COMMUNITY_PATH =
      'api/communities/{communityName}/favorite/';
  static const ENABLE_NEW_POST_NOTIFICATIONS_FOR_COMMUNITY_PATH =
      'api/communities/{communityName}/notifications/subscribe/new-post/';
  static const GET_FAVORITE_COMMUNITIES_PATH = 'api/communities/favorites/';
  static const SEARCH_FAVORITE_COMMUNITIES_PATH =
      'api/communities/favorites/search/';
  static const GET_ADMINISTRATED_COMMUNITIES_PATH =
      'api/communities/administrated/';
  static const SEARCH_ADMINISTRATED_COMMUNITIES_PATH =
      'api/communities/administrated/search/';
  static const GET_MODERATED_COMMUNITIES_PATH = 'api/communities/moderated/';
  static const SEARCH_MODERATED_COMMUNITIES_PATH =
      'api/communities/moderated/search/';
  static const GET_COMMUNITY_POSTS_PATH =
      'api/communities/{communityName}/posts/';
  static const COUNT_COMMUNITY_POSTS_PATH =
      'api/communities/{communityName}/posts/count/';
  static const CREATE_COMMUNITY_POST_PATH =
      'api/communities/{communityName}/posts/';
  static const CLOSED_COMMUNITY_POSTS_PATH =
      'api/communities/{communityName}/posts/closed/';
  static const GET_COMMUNITY_MEMBERS_PATH =
      'api/communities/{communityName}/members/';
  static const SEARCH_COMMUNITY_MEMBERS_PATH =
      'api/communities/{communityName}/members/search/';
  static const GET_COMMUNITY_BANNED_USERS_PATH =
      'api/communities/{communityName}/banned-users/';
  static const GET_COMMUNITY_ADMINISTRATORS_PATH =
      'api/communities/{communityName}/administrators/';
  static const SEARCH_COMMUNITY_ADMINISTRATORS_PATH =
      'api/communities/{communityName}/administrators/search/';
  static const ADD_COMMUNITY_ADMINISTRATOR_PATH =
      'api/communities/{communityName}/administrators/';
  static const REMOVE_COMMUNITY_ADMINISTRATORS_PATH =
      'api/communities/{communityName}/administrators/{username}/';
  static const GET_COMMUNITY_MODERATORS_PATH =
      'api/communities/{communityName}/moderators/';
  static const SEARCH_COMMUNITY_MODERATORS_PATH =
      'api/communities/{communityName}/moderators/search/';
  static const ADD_COMMUNITY_MODERATOR_PATH =
      'api/communities/{communityName}/moderators/';
  static const REMOVE_COMMUNITY_MODERATORS_PATH =
      'api/communities/{communityName}/moderators/{username}/';
  static const CREATE_COMMUNITY_POSTS_PATH =
      'api/communities/{communityName}/posts/';
  static const GET_COMMUNITY_MODERATED_OBJECTS_PATH =
      'api/communities/{communityName}/moderated-objects/';

  void setHttpieService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setStringTemplateService(StringTemplateService stringTemplateService) {
    _stringTemplateService = stringTemplateService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> checkNameIsAvailable({@required String name}) {
    return _httpService.postJSON('$apiURL$CHECK_COMMUNITY_NAME_PATH',
        body: {'name': name}, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getTrendingCommunities(
      {bool authenticatedRequest = true, String category}) {
    Map<String, dynamic> queryParams = {};

    if (category != null) queryParams['category'] = category;

    return _httpService.get('$apiURL$GET_TRENDING_COMMUNITIES_PATH',
        queryParameters: queryParams,
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieResponse> getSuggestedCommunities(
      {bool authenticatedRequest = true}) {
    return _httpService.get('$apiURL$GET_SUGGESTED_COMMUNITIES_PATH',
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieStreamedResponse> createPostForMemoryWithId(String communityName,
      {String text, File image, File video, bool isDraft = false}) {
    Map<String, dynamic> body = {};

    if (image != null) {
      body['image'] = image;
    }

    if (video != null) {
      body['video'] = video;
    }

    if (isDraft != null) {
      body['is_draft'] = isDraft;
    }

    if (text != null && text.length > 0) {
      body['text'] = text;
    }

    String url = _makeCreateMemoryPost(communityName);

    return _httpService.putMultiform(_makeApiUrl(url),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getPostsForMemoryWithName(String communityName,
      {int maxId, int count, bool authenticatedRequest = true}) {
    Map<String, dynamic> queryParams = {};

    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String url = _makeGetMemoryPostsPath(communityName);

    return _httpService.get(_makeApiUrl(url),
        queryParameters: queryParams,
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieResponse> getPostsCountForMemoryWithName(String communityName,
      {bool authenticatedRequest = true}) {
    String url = _makeGetPostsCountForMemoryWithNamePath(communityName);

    return _httpService.get(_makeApiUrl(url),
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieResponse> getClosedPostsForMemoryWithName(String communityName,
      {int maxId, int count, bool authenticatedRequest = true}) {
    Map<String, dynamic> queryParams = {};

    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String url = _makeClosedMemoryPostsPath(communityName);

    return _httpService.get(_makeApiUrl(url),
        queryParameters: queryParams,
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieResponse> searchCommunitiesWithQuery(
      {bool authenticatedRequest = true,
      @required String query,
      bool excludedFromProfilePosts}) {
    Map<String, dynamic> queryParams = {'query': query};

    if (excludedFromProfilePosts != null)
      queryParams['excluded_from_profile_posts'] = excludedFromProfilePosts;

    return _httpService.get('$apiURL$SEARCH_COMMUNITIES_PATH',
        queryParameters: queryParams,
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieResponse> getMemoryWithName(String name,
      {bool authenticatedRequest = true}) {
    String url = _makeGetMemoryPath(name);
    return _httpService.get(_makeApiUrl(url),
        appendAuthorizationToken: authenticatedRequest,
        headers: {'Accept': 'application/json; version=1.0'});
  }

  Future<HttpieStreamedResponse> createMemory(
      {@required String name,
      @required String title,
      @required List<String> categories,
      @required String type,
      bool invitesEnabled,
      String color,
      String userAdjective,
      String usersAdjective,
      String description,
      String rules,
      File cover,
      File avatar}) {
    Map<String, dynamic> body = {
      'name': name,
      'title': title,
      'categories': categories,
      'type': type
    };

    if (avatar != null) {
      body['avatar'] = avatar;
    }

    if (cover != null) {
      body['cover'] = cover;
    }

    if (color != null) {
      body['color'] = color;
    }

    if (rules != null) {
      body['rules'] = rules;
    }

    if (description != null) {
      body['description'] = description;
    }

    if (userAdjective != null && userAdjective.isNotEmpty) {
      body['user_adjective'] = userAdjective;
    }

    if (usersAdjective != null && usersAdjective.isNotEmpty) {
      body['users_adjective'] = usersAdjective;
    }

    if (invitesEnabled != null) {
      body['invites_enabled'] = invitesEnabled;
    }

    return _httpService.putMultiform(_makeApiUrl(CREATE_COMMUNITY_PATH),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieStreamedResponse> updateMemoryWithName(String communityName,
      {String name,
      String title,
      List<String> categories,
      bool invitesEnabled,
      String type,
      String color,
      String userAdjective,
      String usersAdjective,
      String description,
      String rules}) {
    Map<String, dynamic> body = {};

    if (name != null) {
      body['name'] = name;
    }

    if (title != null) {
      body['title'] = title;
    }

    if (categories != null) {
      body['categories'] = categories;
    }

    if (type != null) {
      body['type'] = type;
    }

    if (invitesEnabled != null) {
      body['invites_enabled'] = invitesEnabled;
    }

    if (color != null) {
      body['color'] = color;
    }

    if (rules != null) {
      body['rules'] = rules;
    }

    if (description != null) {
      body['description'] = description;
    }

    if (userAdjective != null && userAdjective.isNotEmpty) {
      body['user_adjective'] = userAdjective;
    }

    if (usersAdjective != null && usersAdjective.isNotEmpty) {
      body['users_adjective'] = usersAdjective;
    }

    return _httpService.patchMultiform(
        _makeApiUrl(_makeUpdateMemoryPath(communityName)),
        body: body,
        appendAuthorizationToken: true);
  }

  Future<HttpieStreamedResponse> updateAvatarForMemoryWithName(
      String communityName,
      {File avatar}) {
    Map<String, dynamic> body = {'avatar': avatar};

    return _httpService.putMultiform(
        _makeApiUrl(_makeMemoryAvatarPath(communityName)),
        body: body,
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deleteAvatarForMemoryWithName(String communityName) {
    return _httpService.delete(
        _makeApiUrl(_makeMemoryAvatarPath(communityName)),
        appendAuthorizationToken: true);
  }

  Future<HttpieStreamedResponse> updateCoverForMemoryWithName(
      String communityName,
      {File cover}) {
    Map<String, dynamic> body = {'cover': cover};

    return _httpService.putMultiform(
        _makeApiUrl(_makeMemoryCoverPath(communityName)),
        body: body,
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deleteCoverForMemoryWithName(String communityName) {
    return _httpService.delete(_makeApiUrl(_makeMemoryCoverPath(communityName)),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deleteMemoryWithName(String communityName) {
    String path = _makeDeleteMemoryPath(communityName);

    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getMembersForMemoryWithId(String communityName,
      {int count, int maxId, List<String> exclude}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    if (exclude != null && exclude.isNotEmpty) queryParams['exclude'] = exclude;

    String path = _makeGetMemoryMembersPath(communityName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> searchMembers(
      {@required String communityName,
      @required String query,
      List<String> exclude}) {
    Map<String, dynamic> queryParams = {'query': query};

    if (exclude != null && exclude.isNotEmpty) queryParams['exclude'] = exclude;

    String path = _makeSearchMemoryMembersPath(communityName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> inviteUserToMemory(
      {@required String communityName, @required String username}) {
    Map<String, dynamic> body = {'username': username};
    String path = _makeInviteUserToMemoryPath(communityName);
    return _httpService.post(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> uninviteUserFromMemory(
      {@required String communityName, @required String username}) {
    Map<String, dynamic> body = {'username': username};
    String path = _makeUninviteUserToMemoryPath(communityName);
    return _httpService.post(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getJoinedCommunities(
      {bool authenticatedRequest = true,
      int offset,
      bool excludedFromProfilePosts}) {
    Map<String, dynamic> queryParams = {'offset': offset};

    if (excludedFromProfilePosts != null)
      queryParams['excluded_from_profile_posts'] = excludedFromProfilePosts;

    return _httpService.get('$apiURL$GET_JOINED_COMMUNITIES_PATH',
        appendAuthorizationToken: authenticatedRequest,
        queryParameters: queryParams);
  }

  Future<HttpieResponse> searchJoinedCommunities({
    @required String query,
    int count,
  }) {
    Map<String, dynamic> queryParams = {'query': query};

    if (count != null) queryParams['count'] = count;

    return _httpService.get(_makeApiUrl('$SEARCH_JOINED_COMMUNITIES_PATH'),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> joinMemoryWithId(String communityName) {
    String path = _makeJoinMemoryPath(communityName);
    return _httpService.post(_makeApiUrl(path), appendAuthorizationToken: true);
  }

  Future<HttpieResponse> leaveMemoryWithId(String communityName) {
    String path = _makeLeaveMemoryPath(communityName);
    return _httpService.post(_makeApiUrl(path), appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getModeratorsForMemoryWithId(String communityName,
      {int count, int maxId}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String path = _makeGetMemoryModeratorsPath(communityName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> searchModerators({
    @required String communityName,
    @required String query,
  }) {
    Map<String, dynamic> queryParams = {'query': query};

    String path = _makeSearchMemoryModeratorsPath(communityName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> addMemoryModerator(
      {@required String communityName, @required String username}) {
    Map<String, dynamic> body = {'username': username};

    String path = _makeAddMemoryModeratorPath(communityName);
    return _httpService.putJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> removeMemoryModerator(
      {@required String communityName, @required String username}) {
    String path = _makeRemoveMemoryModeratorPath(communityName, username);
    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getAdministratorsForMemoryWithName(
      String communityName,
      {int count,
      int maxId}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String path = _makeGetMemoryAdministratorsPath(communityName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> searchAdministrators({
    @required String communityName,
    @required String query,
  }) {
    Map<String, dynamic> queryParams = {'query': query};

    String path = _makeSearchMemoryAdministratorsPath(communityName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> addMemoryAdministrator(
      {@required String communityName, @required String username}) {
    Map<String, dynamic> body = {'username': username};

    String path = _makeAddMemoryAdministratorPath(communityName);
    return _httpService.putJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> removeMemoryAdministrator(
      {@required String communityName, @required String username}) {
    String path = _makeRemoveMemoryAdministratorPath(communityName, username);
    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getBannedUsersForMemoryWithId(String communityName,
      {int count, int maxId}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String path = _makeGetMemoryBannedUsersPath(communityName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> searchBannedUsers({
    @required String communityName,
    @required String query,
  }) {
    Map<String, dynamic> queryParams = {'query': query};

    String path = _makeSearchMemoryBannedUsersPath(communityName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> banMemoryUser(
      {@required String communityName, @required String username}) {
    Map<String, dynamic> body = {'username': username};
    String path = _makeBanMemoryUserPath(communityName);
    return _httpService.postJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> unbanMemoryUser(
      {@required String communityName, @required String username}) {
    Map<String, dynamic> body = {'username': username};
    String path = _makeUnbanMemoryUserPath(communityName);
    return _httpService.post(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getFavoriteCommunities(
      {bool authenticatedRequest = true, int offset}) {
    return _httpService.get('$apiURL$GET_FAVORITE_COMMUNITIES_PATH',
        appendAuthorizationToken: authenticatedRequest,
        queryParameters: {'offset': offset});
  }

  Future<HttpieResponse> searchFavoriteCommunities(
      {@required String query, int count}) {
    Map<String, dynamic> queryParams = {'query': query};

    if (count != null) queryParams['count'] = count;

    return _httpService.get('$apiURL$SEARCH_FAVORITE_COMMUNITIES_PATH',
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> favoriteMemory({@required String communityName}) {
    String path = _makeFavoriteMemoryPath(communityName);
    return _httpService.putJSON(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> unfavoriteMemory({@required String communityName}) {
    String path = _makeFavoriteMemoryPath(communityName);
    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> enableNewPostNotificationsForMemory(
      {@required String communityName}) {
    String path = _makeEnableNewPostNotificationsForMemoryPath(communityName);
    return _httpService.putJSON(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> disableNewPostNotificationsForMemory(
      {@required String communityName}) {
    String path = _makeEnableNewPostNotificationsForMemoryPath(communityName);
    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getAdministratedCommunities(
      {bool authenticatedRequest = true, int offset}) {
    return _httpService.get('$apiURL$GET_ADMINISTRATED_COMMUNITIES_PATH',
        appendAuthorizationToken: authenticatedRequest,
        queryParameters: {'offset': offset});
  }

  Future<HttpieResponse> searchAdministratedCommunities(
      {@required String query, int count}) {
    Map<String, dynamic> queryParams = {'query': query};

    if (count != null) queryParams['count'] = count;

    return _httpService.get('$apiURL$SEARCH_ADMINISTRATED_COMMUNITIES_PATH',
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> searchModeratedCommunities(
      {@required String query, int count}) {
    Map<String, dynamic> queryParams = {'query': query};

    if (count != null) queryParams['count'] = count;

    return _httpService.get('$apiURL$SEARCH_MODERATED_COMMUNITIES_PATH',
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getModeratedCommunities(
      {bool authenticatedRequest = true, int offset}) {
    return _httpService.get('$apiURL$GET_MODERATED_COMMUNITIES_PATH',
        appendAuthorizationToken: authenticatedRequest,
        queryParameters: {'offset': offset});
  }

  Future<HttpieResponse> reportMemoryWithName(
      {@required String communityName,
      @required int moderationCategoryId,
      String description}) {
    String path = _makeReportMemoryPath(communityName);

    Map<String, dynamic> body = {
      'category_id': moderationCategoryId.toString()
    };

    if (description != null && description.isNotEmpty) {
      body['description'] = description;
    }

    return _httpService.post(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getModeratedObjects({
    @required String communityName,
    int count,
    int maxId,
    String type,
    bool verified,
    List<String> statuses,
    List<String> types,
  }) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    if (statuses != null) queryParams['statuses'] = statuses;
    if (types != null) queryParams['types'] = types;

    if (verified != null) queryParams['verified'] = verified;

    String path = _makeGetMemoryModeratedObjectsPath(communityName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  String _makeGetMemoryModeratedObjectsPath(String communityName) {
    return _stringTemplateService.parse(
        GET_COMMUNITY_MODERATED_OBJECTS_PATH, {'communityName': communityName});
  }

  String _makeCreateMemoryPost(String communityName) {
    return _stringTemplateService
        .parse(CREATE_COMMUNITY_POST_PATH, {'communityName': communityName});
  }

  String _makeReportMemoryPath(String communityName) {
    return _stringTemplateService
        .parse(REPORT_COMMUNITY_PATH, {'communityName': communityName});
  }

  String _makeClosedMemoryPostsPath(String communityName) {
    return _stringTemplateService
        .parse(CLOSED_COMMUNITY_POSTS_PATH, {'communityName': communityName});
  }

  String _makeInviteUserToMemoryPath(String communityName) {
    return _stringTemplateService
        .parse(INVITE_USER_TO_COMMUNITY_PATH, {'communityName': communityName});
  }

  String _makeUninviteUserToMemoryPath(String communityName) {
    return _stringTemplateService.parse(
        UNINVITE_USER_TO_COMMUNITY_PATH, {'communityName': communityName});
  }

  String _makeUnbanMemoryUserPath(String communityName) {
    return _stringTemplateService
        .parse(UNBAN_COMMUNITY_USER_PATH, {'communityName': communityName});
  }

  String _makeBanMemoryUserPath(String communityName) {
    return _stringTemplateService
        .parse(BAN_COMMUNITY_USER_PATH, {'communityName': communityName});
  }

  String _makeSearchMemoryBannedUsersPath(String communityName) {
    return _stringTemplateService.parse(
        SEARCH_COMMUNITY_BANNED_USERS_PATH, {'communityName': communityName});
  }

  String _makeDeleteMemoryPath(String communityName) {
    return _stringTemplateService
        .parse(DELETE_COMMUNITY_PATH, {'communityName': communityName});
  }

  String _makeGetMemoryPath(String communityName) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_PATH, {'communityName': communityName});
  }

  String _makeAddMemoryAdministratorPath(String communityName) {
    return _stringTemplateService.parse(
        ADD_COMMUNITY_ADMINISTRATOR_PATH, {'communityName': communityName});
  }

  String _makeRemoveMemoryAdministratorPath(
      String communityName, String username) {
    return _stringTemplateService.parse(REMOVE_COMMUNITY_ADMINISTRATORS_PATH,
        {'communityName': communityName, 'username': username});
  }

  String _makeAddMemoryModeratorPath(String communityName) {
    return _stringTemplateService
        .parse(ADD_COMMUNITY_MODERATOR_PATH, {'communityName': communityName});
  }

  String _makeRemoveMemoryModeratorPath(String communityName, String username) {
    return _stringTemplateService.parse(REMOVE_COMMUNITY_MODERATORS_PATH,
        {'communityName': communityName, 'username': username});
  }

  String _makeGetMemoryPostsPath(String communityName) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_POSTS_PATH, {'communityName': communityName});
  }

  String _makeGetPostsCountForMemoryWithNamePath(String communityName) {
    return _stringTemplateService
        .parse(COUNT_COMMUNITY_POSTS_PATH, {'communityName': communityName});
  }

  String _makeFavoriteMemoryPath(String communityName) {
    return _stringTemplateService
        .parse(FAVORITE_COMMUNITY_PATH, {'communityName': communityName});
  }

  String _makeEnableNewPostNotificationsForMemoryPath(String communityName) {
    return _stringTemplateService.parse(
        ENABLE_NEW_POST_NOTIFICATIONS_FOR_COMMUNITY_PATH,
        {'communityName': communityName});
  }

  String _makeJoinMemoryPath(String communityName) {
    return _stringTemplateService
        .parse(JOIN_COMMUNITY_PATH, {'communityName': communityName});
  }

  String _makeLeaveMemoryPath(String communityName) {
    return _stringTemplateService
        .parse(LEAVE_COMMUNITY_PATH, {'communityName': communityName});
  }

  String _makeUpdateMemoryPath(String communityName) {
    return _stringTemplateService
        .parse(UPDATE_COMMUNITY_PATH, {'communityName': communityName});
  }

  String _makeMemoryAvatarPath(String communityName) {
    return _stringTemplateService
        .parse(COMMUNITY_AVATAR_PATH, {'communityName': communityName});
  }

  String _makeMemoryCoverPath(String communityName) {
    return _stringTemplateService
        .parse(COMMUNITY_COVER_PATH, {'communityName': communityName});
  }

  String _makeGetMemoryMembersPath(String communityName) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_MEMBERS_PATH, {'communityName': communityName});
  }

  String _makeSearchMemoryMembersPath(String communityName) {
    return _stringTemplateService
        .parse(SEARCH_COMMUNITY_MEMBERS_PATH, {'communityName': communityName});
  }

  String _makeGetMemoryBannedUsersPath(String communityName) {
    return _stringTemplateService.parse(
        GET_COMMUNITY_BANNED_USERS_PATH, {'communityName': communityName});
  }

  String _makeGetMemoryAdministratorsPath(String communityName) {
    return _stringTemplateService.parse(
        GET_COMMUNITY_ADMINISTRATORS_PATH, {'communityName': communityName});
  }

  String _makeSearchMemoryAdministratorsPath(String communityName) {
    return _stringTemplateService.parse(
        SEARCH_COMMUNITY_ADMINISTRATORS_PATH, {'communityName': communityName});
  }

  String _makeGetMemoryModeratorsPath(String communityName) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_MODERATORS_PATH, {'communityName': communityName});
  }

  String _makeSearchMemoryModeratorsPath(String communityName) {
    return _stringTemplateService.parse(
        SEARCH_COMMUNITY_MODERATORS_PATH, {'communityName': communityName});
  }

  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }
}
