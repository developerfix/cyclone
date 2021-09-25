import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:Siuu/models/StoryComment.dart';
import 'package:Siuu/models/categories_list.dart';
import 'package:Siuu/models/category.dart';
import 'package:Siuu/models/circle.dart';
import 'package:Siuu/models/UserStory.dart';
import 'package:Siuu/models/UploadStory.dart';
import 'package:Siuu/models/moment_comment.dart';
import 'package:Siuu/models/moment_comment_list.dart';
import 'package:Siuu/models/moment_comment_reaction.dart';
import 'package:Siuu/models/moment_reaction.dart';
import 'package:Siuu/models/moment_reaction_list.dart';
import 'package:Siuu/models/moment_viewers.dart';
import 'package:Siuu/services/toast.dart';
import 'dart:developer';

import 'package:Siuu/models/communities_list.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/device.dart';
import 'package:Siuu/models/devices_list.dart';
import 'package:Siuu/models/follow_request_list.dart';
import 'package:Siuu/models/follows_lists_list.dart';
import 'package:Siuu/models/circles_list.dart';
import 'package:Siuu/models/connection.dart';
import 'package:Siuu/models/emoji.dart';
import 'package:Siuu/models/emoji_group_list.dart';
import 'package:Siuu/models/follow.dart';
import 'package:Siuu/models/follows_list.dart';
import 'package:Siuu/models/hashtag.dart';
import 'package:Siuu/models/hashtags_list.dart';
import 'package:Siuu/models/language.dart';
import 'package:Siuu/models/language_list.dart';
import 'package:Siuu/models/link_preview/link_preview.dart';
import 'package:Siuu/models/moderation/moderated_object.dart';
import 'package:Siuu/models/moderation/moderated_object_list.dart';
import 'package:Siuu/models/moderation/moderated_object_log_list.dart';
import 'package:Siuu/models/moderation/moderation_category.dart';
import 'package:Siuu/models/moderation/moderation_category_list.dart';
import 'package:Siuu/models/moderation/moderation_penalty_list.dart';
import 'package:Siuu/models/moderation/moderation_report_list.dart';
import 'package:Siuu/models/notifications/notification.dart';
import 'package:Siuu/models/notifications/notifications_list.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/post_comment.dart';
import 'package:Siuu/models/post_comment_list.dart';
import 'package:Siuu/models/post_comment_reaction.dart';
import 'package:Siuu/models/post_comment_reaction_list.dart';
import 'package:Siuu/models/post_media_list.dart';
import 'package:Siuu/models/post_reaction.dart';
import 'package:Siuu/models/post_reaction_list.dart';
import 'package:Siuu/models/post_text.dart';
import 'package:Siuu/models/reactions_emoji_count_list.dart';
import 'package:Siuu/models/posts_list.dart';
import 'package:Siuu/models/top_post.dart';
import 'package:Siuu/models/top_posts_list.dart';
import 'package:Siuu/models/trending_posts_list.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/models/user_invite.dart';
import 'package:Siuu/models/user_invites_list.dart';
import 'package:Siuu/models/user_notifications_settings.dart';
import 'package:Siuu/models/users_list.dart';
import 'package:Siuu/pages/auth/create_account/blocs/create_account.dart';
import 'package:Siuu/services/auth_api.dart';
import 'package:Siuu/services/categories_api.dart';
import 'package:Siuu/services/communities_api.dart';
import 'package:Siuu/services/connections_circles_api.dart';
import 'package:Siuu/services/connections_api.dart';
import 'package:Siuu/services/devices_api.dart';
import 'package:Siuu/services/draft.dart';
import 'package:Siuu/services/emojis_api.dart';
import 'package:Siuu/services/follows_api.dart';
import 'package:Siuu/services/hashtags_api.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/follows_lists_api.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/moderation_api.dart';
import 'package:Siuu/services/notifications_api.dart';
import 'package:Siuu/services/posts_api.dart';
import 'package:Siuu/services/push_notifications/push_notifications.dart';
import 'package:Siuu/services/storage.dart';
import 'package:Siuu/services/user_invites_api.dart';
import 'package:Siuu/services/waitlist_service.dart';
import 'package:Siuu/utils/firestore_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
export 'package:Siuu/services/httpie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Siuu/siuuchat/SocketInit.dart';

import 'package:path/path.dart';

import 'intercom.dart';

part 'user_moment_extension.dart';

class UserService {
  OBStorage _userStorage;

  static const STORAGE_KEY_AUTH_TOKEN = 'authToken';
  static const STORAGE_KEY_USER_DATA = 'data';
  static const STORAGE_FIRST_POSTS_DATA = 'firstPostsData';
  static const STORAGE_TOP_POSTS_DATA = 'topPostsData';
  static const STORAGE_TOP_POSTS_LAST_VIEWED_ID = 'topPostsLastViewedId';

  AuthApiService _authApiService;
  HttpieService _httpieService;
  PostsApiService _postsApiService;
  ModerationApiService _moderationApiService;
  CommunitiesApiService _memoriesApiService;
  HashtagsApiService _hashtagsApiService;
  CategoriesApiService _categoriesApiService;
  EmojisApiService _emojisApiService;
  FollowsApiService _followsApiService;
  ConnectionsApiService _connectionsApiService;
  ConnectionsCirclesApiService _connectionsCirclesApiService;
  FollowsListsApiService _followsListsApiService;
  UserInvitesApiService _userInvitesApiService;
  NotificationsApiService _notificationsApiService;
  DevicesApiService _devicesApiService;
  CreateAccountBloc _createAccountBlocService;
  WaitlistApiService _waitlistApiService;
  LocalizationService _localizationService;
  DraftService _draftService;
  PushNotificationsService _pushNotificationService;
  IntercomService _intercomService;

  // If this is null, means user logged out.
  Stream<User> get loggedInUserChange => _loggedInUserChangeSubject.stream;

  User _loggedInUser;

  String _authToken;

  final _loggedInUserChangeSubject = ReplaySubject<User>(maxSize: 1);

  Future<Device> _getOrCreateCurrentDeviceCache;

  static const MAX_TEMP_DIRECTORY_CACHE_MB = 200; // 200mb

  void setAuthApiService(AuthApiService authApiService) {
    _authApiService = authApiService;
  }

  void setPushNotificationsService(
      PushNotificationsService pushNotificationsService) {
    _pushNotificationService = pushNotificationsService;
  }

  void setIntercomService(IntercomService intercomService) {
    _intercomService = intercomService;
  }

  void setModerationApiService(ModerationApiService moderationApiService) {
    _moderationApiService = moderationApiService;
  }

  void setPostsApiService(PostsApiService postsApiService) {
    _postsApiService = postsApiService;
  }

  void setFollowsApiService(FollowsApiService followsApiService) {
    _followsApiService = followsApiService;
  }

  void setUserInvitesApiService(UserInvitesApiService userInvitesApiService) {
    _userInvitesApiService = userInvitesApiService;
  }

  void setFollowsListsApiService(
      FollowsListsApiService followsListsApiService) {
    _followsListsApiService = followsListsApiService;
  }

  void setConnectionsApiService(ConnectionsApiService connectionsApiService) {
    _connectionsApiService = connectionsApiService;
  }

  void setConnectionsCirclesApiService(
      ConnectionsCirclesApiService circlesApiService) {
    _connectionsCirclesApiService = circlesApiService;
  }

  void setCommunitiesApiService(CommunitiesApiService memoriesApiService) {
    _memoriesApiService = memoriesApiService;
  }

  void setHashtagsApiService(HashtagsApiService hashtagsApiService) {
    _hashtagsApiService = hashtagsApiService;
  }

  void setCategoriesApiService(CategoriesApiService categoriesApiService) {
    _categoriesApiService = categoriesApiService;
  }

  void setNotificationsApiService(
      NotificationsApiService notificationsApiService) {
    _notificationsApiService = notificationsApiService;
  }

  void setDevicesApiService(DevicesApiService devicesApiService) {
    _devicesApiService = devicesApiService;
  }

  void setEmojisApiService(EmojisApiService emojisApiService) {
    _emojisApiService = emojisApiService;
  }

  void setHttpieService(HttpieService httpieService) {
    _httpieService = httpieService;
  }

  void setStorageService(StorageService storageService) {
    _userStorage = storageService.getSecureStorage(namespace: 'user');
  }

  void setCreateAccountBlocService(CreateAccountBloc createAccountBloc) {
    _createAccountBlocService = createAccountBloc;
  }

  void setWaitlistApiService(WaitlistApiService waitlistApiService) {
    _waitlistApiService = waitlistApiService;
  }

  void setLocalizationsService(LocalizationService localizationService) {
    _localizationService = localizationService;
  }

  void setDraftService(DraftService draftService) {
    _draftService = draftService;
  }

  Future<void> deleteAccountWithPassword(String password) async {
    HttpieResponse response =
        await _authApiService.deleteUser(password: password);
    _checkResponseIsOk(response);
  }

  Future<void> logout() async {

    try {
      await _pushNotificationService.clearPromptedUserForPermission();
      await _intercomService.disableIntercom();
    } catch (error) {
      throw error;
    } finally {
      clearCurrentUser();
      _deleteCurrentDevice();
      await _removeStoredUserData();
      await _removeStoredAuthToken();
      _httpieService.removeAuthorizationToken();
      _draftService.clear();
      _removeLoggedInUser();
      await clearCache();
      User.clearSessionCache();
      User.clearMaxSessionCache();
      _getOrCreateCurrentDeviceCache = null;
    }
  }

  Future<void> clearCache() async {
    await _removeStoredFirstPostsData();
    await _removeStoredTopPostsData();
    await DiskCache().clear();
    await clearTemporaryDirectories();
    Post.clearCache();
    User.clearNavigationCache();
    User.clearMaxSessionCache();
    PostComment.clearCache();
    Memory.clearCache();
  }

  Future<bool> clearTemporaryDirectories() async {
    // TODO Handle every service clearing its own things responsible for, not have it
    // spread over the place...
    debugPrint('Clearing /tmp files and vimedia');
    try {
      Directory tempDir = Directory((await getApplicationDocumentsDirectory())
          .path
          .replaceFirst('Documents', 'tmp'));
      Directory vimediaDir = Directory(join(
          (await getApplicationDocumentsDirectory())
              .path
              .replaceFirst('Documents', 'tmp'),
          'vimedia'));
      Directory mediaCacheDir = Directory(
          join((await getApplicationDocumentsDirectory()).path, 'mediaCache'));
      Directory videoDirAndroid = Directory(
          join((await getApplicationDocumentsDirectory()).path, 'video'));

      if (tempDir.existsSync())
        tempDir.listSync().forEach((var entity) {
          if (entity is File) {
            entity.delete();
          }
        });
      if (vimediaDir.existsSync()) await vimediaDir.delete(recursive: true);
      if (mediaCacheDir.existsSync())
        await mediaCacheDir.delete(recursive: true);
      if (videoDirAndroid.existsSync())
        await videoDirAndroid.delete(recursive: true);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void checkAndClearTempDirectories() async {
    int size = 0;
    try {
      Directory tempDir = Directory((await getTemporaryDirectory())
          .path
          .replaceFirst('Documents', 'tmp'));
      Directory vimediaDir = Directory(join(
          (await getApplicationDocumentsDirectory())
              .path
              .replaceFirst('Documents', 'tmp'),
          'vimedia'));
      Directory videoDirAndroid =
          Directory(join((await getTemporaryDirectory()).path, 'video'));
      Directory mediaCacheDir =
          Directory(join((await getTemporaryDirectory()).path, 'mediaCache'));

      if (tempDir.existsSync())
        tempDir
            .listSync()
            .forEach((var entity) => size += entity.statSync().size);
      if (vimediaDir.existsSync())
        vimediaDir
            .listSync()
            .forEach((var entity) => size += entity.statSync().size);
      if (mediaCacheDir.existsSync())
        mediaCacheDir
            .listSync()
            .forEach((var entity) => size += entity.statSync().size);
      if (videoDirAndroid.existsSync())
        videoDirAndroid
            .listSync()
            .forEach((var entity) => size += entity.statSync().size);

      if (size > MAX_TEMP_DIRECTORY_CACHE_MB * 1000000) {
        clearTemporaryDirectories();
      }
    } catch (e) {
      debugPrint(e);
    }
  }

  Future<void> loginWithCredentials(
      {@required String username, @required String password}) async {
    HttpieResponse response = await _authApiService.loginWithCredentials(
        username: username, password: password);
    if (response.isOk()) {
      var parsedResponse = response.parseJsonBody();
      var authToken = parsedResponse['token'];
      await loginWithAuthToken(authToken);
    } else if (response.isUnauthorized()) {
      throw CredentialsMismatchError('The provided credentials do not match.');
    } else {
      throw HttpieRequestError(response);
    }
  }

  Future<void> requestPasswordReset({@required String email}) async {
    HttpieResponse response =
        await _authApiService.requestPasswordReset(email: email);
    _checkResponseIsOk(response);
  }

  Future<void> verifyPasswordReset(
      {@required String newPassword,
      @required String passwordResetToken}) async {
    HttpieResponse response = await _authApiService.verifyPasswordReset(
        newPassword: newPassword, passwordResetToken: passwordResetToken);
    _checkResponseIsOk(response);
  }

  Future<void> acceptGuidelines() async {
    HttpieResponse response = await _authApiService.acceptGuidelines();
    _checkResponseIsOk(response);
  }

  Future<int> subscribeToBetaWaitlist({String email}) async {
    HttpieResponse response =
        await _waitlistApiService.subscribeToBetaWaitlist(email: email);
    _checkResponseIsOk(response);
    Map<String, dynamic> parsedJson = json.decode(response.body);
    return parsedJson['count'];
  }

  Future<void> loginWithAuthToken(String authToken) async {
    await _setAuthToken(authToken);
    await refreshUser();
  }

  User getLoggedInUser() {
    return _loggedInUser;
  }

  Language getUserLanguage() {
    return _loggedInUser.language;
  }

  bool isLoggedInUser(User user) {
    return user.id == _loggedInUser.id;
  }

  Future<User> refreshUser() async {
    if (_authToken == null) throw AuthTokenMissingError();

    HttpieResponse response =
        await _authApiService.getUserWithAuthToken(_authToken);
    _checkResponseIsOk(response);
    var userData = response.body;
    return _setUserWithData(userData);
  }

  Future<User> updateUserEmail(String email) async {
    HttpieStreamedResponse response =
        await _authApiService.updateUserEmail(email: email);
    _checkResponseIsOk(response);
    String userData = await response.readAsString();
    return _makeLoggedInUser(userData);
  }

  Future<void> updateUserPassword(
      String currentPassword, String newPassword) async {
    HttpieStreamedResponse response = await _authApiService.updateUserPassword(
        currentPassword: currentPassword, newPassword: newPassword);
    _checkResponseIsOk(response);
  }

  Future<User> updateUser({
    dynamic avatar,
    dynamic cover,
    String name,
    String username,
    String url,
    String password,
    bool followersCountVisible,
    bool crewPostsVisible,
    String bio,
    String location,
    UserVisibility visibility,
  }) async {
    HttpieStreamedResponse response = await _authApiService.updateUser(
        avatar: avatar,
        cover: cover,
        name: name,
        username: username,
        url: url,
        followersCountVisible: followersCountVisible,
        crewPostsVisible: crewPostsVisible,
        bio: bio,
        visibility: visibility?.code,
        location: location);

    _checkResponseIsOk(response);

    String userData = await response.readAsString();
    return _makeLoggedInUser(userData);
  }

  Future<void> loginWithStoredUserData() async {
    var token = await _getStoredAuthToken();
    print('MyToken is: $token');
    if (token == null &&
        !_createAccountBlocService.hasToken() &&
        !_createAccountBlocService.hasPasswordResetToken())
      throw AuthTokenMissingError();
    if (token == null && _createAccountBlocService.hasToken()) {
      print(
          'User is in register via link flow, dont throw error as it will break the flow');
      return;
    }
    if (token == null && _createAccountBlocService.hasPasswordResetToken()) {
      print(
          'User is in reset password via link flow, dont throw error as it will break the flow');
      return;
    }

    String userData = await this._getStoredUserData();
    if (userData != null) {
      var user = _makeLoggedInUser(userData);
      _setLoggedInUser(user);
    }

    await loginWithAuthToken(token);
  }

  Future<bool> hasAuthToken() async {
    String authToken = await _getStoredAuthToken();
    return authToken != null;
  }

  bool isLoggedIn() {
    return _loggedInUser != null;
  }

  Future<TopPostsList> getTopPosts(
      {int maxId, int minId, int count, bool excludeJoinedCommunities}) async {
    HttpieResponse response = await _postsApiService.getTopPosts(
        maxId: maxId,
        minId: minId,
        count: count,
        excludeJoinedCommunities: excludeJoinedCommunities,
        authenticatedRequest: true);

    _checkResponseIsOk(response);

    return TopPostsList.fromJson(json.decode(response.body));
  }

  Future<TrendingPostsList> getTrendingPosts(
      {int maxId, int minId, int count}) async {
    HttpieResponse response = await _postsApiService.getTrendingPosts(
        maxId: maxId, minId: minId, count: count, authenticatedRequest: true);

    _checkResponseIsOk(response);

    return TrendingPostsList.fromJson(json.decode(response.body));
  }

  Future<PostsList> getTimelinePosts(
      {List<Circle> circles = const [],
      List<FollowsList> followsLists = const [],
      int maxId,
      int count,
      String username,
      bool cachePosts = false}) async {
    print("yes get post callll::");

    HttpieResponse response = await _postsApiService.getTimelinePosts(
        circleIds: circles.map((circle) => circle.id).toList(),
        listIds: followsLists.map((followsList) => followsList.id).toList(),
        maxId: maxId,
        count: count,
        username: username,
        authenticatedRequest: true);
    _checkResponseIsOk(response);
    String postsData = response.body;

    log("post data hare::$postsData");

    //var data = json.decode(postsData);
    //data['meta'] = getPostTextMeta(data['uuid']);
    //postsData = json.encode(data);
    //print('post : $postsData');
    //print('post : $data');
    if (cachePosts) {
      this._storeFirstPostsData(postsData);
    }
    return _makePostsList(postsData);
  }

  Future<Map<String, dynamic>> getPostTextMeta(String uuid) async {
    DocumentSnapshot postMetas = await FirebaseFirestore.instance
        .collection('postMetas')
        .doc(uuid)
        .get();
    return postMetas.data();
  }

  Future<PostsList> getStoredFirstPosts() async {
    String firstPostsData = await this._getStoredFirstPostsData();
    if (firstPostsData != null) {
      var postsList = _makePostsList(firstPostsData);
      return postsList;
    }
    return PostsList();
  }

  Future<void> setStoredTopPosts(List<TopPost> topPosts) async {
    String topPostsData = json
        .encode(topPosts.map((TopPost topPost) => topPost.toJson())?.toList());
    await this._removeStoredTopPostsData();
    await this._storeTopPostsData(topPostsData);
  }

  Future<void> setTopPostsLastViewedId(int lastViewedId) async {
    String topPostId = lastViewedId.toString();
    await this._removeStoredTopPostsLastViewedId();
    debugPrint('Setting id $lastViewedId as last viewed post for top posts');
    await this._storeTopPostsLastViewedId(topPostId);
  }

  Future<TopPostsList> getStoredTopPosts() async {
    String topPostsData = await this._getStoredTopPostsData();
    if (topPostsData != null) {
      var postsList = _makeTopPostsList(topPostsData);
      return postsList;
    }
    return TopPostsList();
  }

  Future<int> getStoredTopPostsLastViewedId() async {
    String topPostId = await this._getStoredTopPostsLastViewedId();
    if (topPostId != null) {
      return int.parse(topPostId);
    }
    return null;
  }

  Future<Post> createPost(
      {String text,
      List<Circle> circles = const [],
      bool isDraft,
      PostText metaText}) async {
    HttpieStreamedResponse response = await _postsApiService.createPost(
        text: text,
        circleIds: circles.map((circle) => circle.id).toList(),
        isDraft: isDraft);

    _checkResponseIsCreated(response);

    // Post counts may have changed
    refreshUser();

    String responseBody = await response.readAsString();

    // Create a CollectionReference called users that references the firestore collection
    CollectionReference postMetas =
        FirebaseFirestore.instance.collection('postMetas');
    // Call the user's CollectionReference to add a new user

    postMetas
        .doc(json.decode(responseBody)['uuid'])
        .set(metaText.toJson())
        .then((value) => print("Post meta Added"))
        .catchError((error) => print("Failed to add post meta: $error"));

    return Post.fromJson(json.decode(responseBody));
  }

  Future<void> addMediaToPost(
      {@required File file, @required Post post}) async {
    HttpieStreamedResponse response =
        await _postsApiService.addMediaToPost(file: file, postUuid: post.uuid);

    _checkResponseIsOk(response);
  }

  Future<PostMediaList> getMediaForPost({@required Post post}) async {
    HttpieResponse response =
        await _postsApiService.getPostMedia(postUuid: post.uuid);

    _checkResponseIsOk(response);

    return PostMediaList.fromJson(json.decode(response.body));
  }

  Future<void> publishPost({@required Post post}) async {
    HttpieResponse response =
        await _postsApiService.publishPost(postUuid: post.uuid);

    _checkResponseIsOk(response);
  }

  Future<OBPostStatus> getPostStatus({@required Post post}) async {
    HttpieResponse response =
        await _postsApiService.getPostWithUuidStatus(post.uuid);

    _checkResponseIsOk(response);

    Map<String, dynamic> responseJson = response.parseJsonBody();

    OBPostStatus status = OBPostStatus.parse(responseJson['status']);

    post.setStatus(status);

    return status;
  }

  Future<Post> editPost({String postUuid, String text}) async {
    HttpieStreamedResponse response =
        await _postsApiService.editPost(postUuid: postUuid, text: text);

    _checkResponseIsOk(response);

    String responseBody = await response.readAsString();
    return Post.fromJson(json.decode(responseBody));
  }

  Future<void> deletePost(Post post) async {
    HttpieResponse response =
        await _postsApiService.deletePostWithUuid(post.uuid);
    _checkResponseIsOk(response);
  }

  Future<Post> disableCommentsForPost(Post post) async {
    HttpieResponse response =
        await _postsApiService.disableCommentsForPostWithUuidPost(post.uuid);
    _checkResponseIsOk(response);
    return Post.fromJson(json.decode(response.body));
  }

  Future<Post> enableCommentsForPost(Post post) async {
    HttpieResponse response =
        await _postsApiService.enableCommentsForPostWithUuidPost(post.uuid);
    _checkResponseIsOk(response);
    return Post.fromJson(json.decode(response.body));
  }

  Future<Post> closePost(Post post) async {
    HttpieResponse response =
        await _postsApiService.closePostWithUuid(post.uuid);
    _checkResponseIsOk(response);
    return Post.fromJson(json.decode(response.body));
  }

  Future<Post> openPost(Post post) async {
    HttpieResponse response =
        await _postsApiService.openPostWithUuid(post.uuid);
    _checkResponseIsOk(response);
    return Post.fromJson(json.decode(response.body));
  }

  Future<Post> getPostWithUuid(String uuid) async {
    HttpieResponse response = await _postsApiService.getPostWithUuid(uuid);
    _checkResponseIsOk(response);
    return Post.fromJson(json.decode(response.body));
  }

  Future<PostReaction> reactToPost(
      {@required Post post, @required int emoji}) async {
    HttpieResponse response =
        await _postsApiService.reactToPost(postUuid: post.uuid, emojiId: emoji);
    _checkResponseIsCreated(response);
    return PostReaction.fromJson(json.decode(response.body));
  }

  Future<void> deletePostReaction(
      {@required PostReaction postReaction, @required Post post}) async {
    HttpieResponse response = await _postsApiService.deletePostReaction(
        postReactionId: postReaction.id, postUuid: post.uuid);
    _checkResponseIsOk(response);
  }

  Future<PostReactionList> getReactionsForPost(Post post,
      {int count, int maxId, Emoji emoji}) async {
    HttpieResponse response =
        await _postsApiService.getReactionsForPostWithUuid(post.uuid,
            count: count, maxId: maxId, emojiId: emoji.id);

    _checkResponseIsOk(response);

    return PostReactionList.fromJson(json.decode(response.body));
  }

  Future<ReactionsEmojiCountList> getReactionsEmojiCountForPost(
      Post post) async {
    HttpieResponse response =
        await _postsApiService.getReactionsEmojiCountForPostWithUuid(post.uuid);

    _checkResponseIsOk(response);

    return ReactionsEmojiCountList.fromJson(json.decode(response.body));
  }

  Future<PostCommentReaction> reactToPostComment(
      {@required Post post,
      @required PostComment postComment,
      @required Emoji emoji}) async {
    HttpieResponse response = await _postsApiService.reactToPostComment(
      postCommentId: postComment.id,
      postUuid: post.uuid,
      emojiId: emoji.id,
    );
    _checkResponseIsCreated(response);
    return PostCommentReaction.fromJson(json.decode(response.body));
  }

  Future<void> deletePostCommentReaction(
      {@required PostCommentReaction postCommentReaction,
      @required PostComment postComment,
      @required Post post}) async {
    HttpieResponse response = await _postsApiService.deletePostCommentReaction(
        postCommentReactionId: postCommentReaction.id,
        postUuid: post.uuid,
        postCommentId: postComment.id);
    _checkResponseIsOk(response);
  }

  Future<PostCommentReactionList> getReactionsForPostComment(
      {PostComment postComment,
      Post post,
      int count,
      int maxId,
      Emoji emoji}) async {
    HttpieResponse response = await _postsApiService.getReactionsForPostComment(
        postUuid: post.uuid,
        postCommentId: postComment.id,
        count: count,
        maxId: maxId,
        emojiId: emoji.id);

    _checkResponseIsOk(response);

    return PostCommentReactionList.fromJson(json.decode(response.body));
  }

  Future<ReactionsEmojiCountList> getReactionsEmojiCountForPostComment(
      {@required PostComment postComment, @required Post post}) async {
    HttpieResponse response =
        await _postsApiService.getReactionsEmojiCountForPostComment(
            postCommentId: postComment.id, postUuid: post.uuid);

    _checkResponseIsOk(response);

    return ReactionsEmojiCountList.fromJson(json.decode(response.body));
  }

  Future<PostComment> commentPost(
      {@required Post post,
      @required String text,
      @required String type,
      @required File file,
      String animation}) async {
    if (file == null) {
      HttpieResponse response = await _postsApiService.commentPost(
          postUuid: post.uuid,
          text: text,
          type: type,
          file: file,
          animation: animation);
      _checkResponseIsCreated(response);
      return PostComment.fromJSON(json.decode(response.body));
    } else {
      HttpieStreamedResponse response =
          await _postsApiService.commentPostforFile(
              postUuid: post.uuid,
              text: text,
              type: type,
              file: file,
              animation: animation);
      _checkResponseIsCreated(response);
      String responseBody = await response.readAsString();
      return PostComment.fromJSON(json.decode(responseBody));
    }
  }

  Future<UserStory> uploadStory(
    ToastService _toastService, {
    @required String text,
    @required BuildContext context,
    @required String background,
    @required String type,
    @required File vedio,
    @required File image,
    @required String font,
  }) async {
    User user = await refreshUser();

    UploadStory uploadStory = new UploadStory();
    _toastService.info(message: "Please wait", context: context);
    if (type == "text") {
      print('Background is: $background');
      HttpieResponse response = await _postsApiService.uploadStoryOnlyText(
          name: user.profile.name,
          text: text,
          type: type,
          avatar: user.profile.avatar,
          font: font,
          background: background);

      //_checkResponseIsCreated(response);
      uploadStory = uploadStoryFromJson(response.body);
      _reponceToast(uploadStory, context, _toastService);
      return UserStory(
        myStories: [Story.fromJson(json.decode(response.body)['data'])],
      );
    } else {
      HttpieStreamedResponse response = await _postsApiService.uploadStory(
          name: user.profile.name,
          text: text,
          type: type,
          background: background,
          video: vedio,
          image: image,
          avatar: user.profile.avatar);
      String body = await response.readAsString();
      print('THIS IS THE RESULT: $body');
      uploadStory = new UploadStory();
      _reponceToast(uploadStory, context, _toastService);
      return UserStory(
        myStories: [
          Story.fromJson(
            json.decode(body)['data'],
          ),
        ],
      );
    }
  }

  void _reponceToast(UploadStory uploadStory, BuildContext context,
      ToastService _toastService) {
    if (uploadStory.message == "successfully saved") {
      _toastService.success(message: uploadStory.message, context: context);
      Navigator.pop(context);
    } else {
      _toastService.error(message: uploadStory.message, context: context);
      Navigator.pop(context);
    }
  }

  Future<StoryComment> share_post({
    @required String post_id,
    @required String post_type,
    @required String created_by_user_id,
    @required String share_type,
    @required String share_with,
    @required String text_attached,
  }) async {
    HttpieResponse response = await _postsApiService.sharePost(
        post_id: post_id,
        post_type: post_type,
        created_by_user_id: created_by_user_id,
        share_type: share_type,
        share_with: share_with,
        text_attached: text_attached);

    //_checkResponseIsCreated(response);
    return StoryComment.fromMap(json.decode(response.body));
  }

  Future<UserStory> uploadStoryWithMap(
    ToastService _toastService, {
    @required String text,
    @required BuildContext context,
    @required String type,
    @required String avatar,
    @required String background,
    @required File vedio,
    @required File image,
    @required double lat,
    @required double long,
    @required String font,
  }) async {
    User user = await refreshUser();
    UploadStory uploadStory = new UploadStory();
    _toastService.info(message: "Please wait", context: context);

    if (type == "text") {
      HttpieResponse response = await _postsApiService.uploadStoryOnlyTextOnMap(
        background: background,
        name: user.profile.name,
        text: text,
        type: type,
        lat: lat,
        long: long,
        avtar: user.profile.avatar,
        font: font,
      );

      uploadStory = uploadStoryFromJson(response.body);

      _reponceToast(uploadStory, context, _toastService);

      // _checkResponseIsCreated(response);

      return UserStory(
        myStories: [Story.fromJson(json.decode(response.body)['data'])],
        onMapStories: [Story.fromJson(json.decode(response.body)['data'])],
      );
    } else {
      HttpieStreamedResponse response =
          await _postsApiService.uploadStoryWithMap(
              name: user.profile.name,
              background: background,
              text: text,
              type: type,
              video: vedio,
              image: image,
              avatar: user.profile.avatar,
              lat: lat,
              long: long);
      String body = await response.readAsString();

      print("final responce ::${body}");

      uploadStory = uploadStoryFromJson(body);
      _reponceToast(uploadStory, context, _toastService);
      return UserStory(
        myStories: [Story.fromJson(json.decode(body)['data'])],
        onMapStories: [Story.fromJson(json.decode(body)['data'])],
      );
    }
  }

  Future<User> getUserFromUserId(int userId) async {
    HttpieResponse response = await _postsApiService.getUserFromId(userId);

    return User.fromJson(json.decode(response.body));
  }

  Future<PostComment> editPostComment(
      {@required Post post,
      @required PostComment postComment,
      @required String text}) async {
    HttpieResponse response = await _postsApiService.editPostComment(
        postUuid: post.uuid, postCommentId: postComment.id, text: text);
    _checkResponseIsOk(response);
    return PostComment.fromJSON(json.decode(response.body));
  }

  Future<PostComment> getPostComment(
      {@required Post post, @required PostComment postComment}) async {
    HttpieResponse response = await _postsApiService.getPostComment(
        postUuid: post.uuid, postCommentId: postComment.id);
    _checkResponseIsOk(response);
    return PostComment.fromJSON(json.decode(response.body));
  }

  Future<UserStory> getStory() async {
    print('Getting stories');
    HttpieResponse response = await _postsApiService.getStory();

    print("this is stories data ::${response.body}");
    //_checkResponseIsOk(response);
    var result = UserStory(
      myStories: [],
      onMapStories: [],
      stories: [],
    );
    if (response.body == null || response.body == "") return result;
    try {
      Map<String, dynamic> map = json.decode(response.body);
      result = UserStory.fromJson(map);
    } catch (_) {}
    return result;
  }

  Future<PostComment> replyPostComment(
      {@required Post post,
      @required PostComment postComment,
      @required String type,
      @required File audio,
      @required String text}) async {
    HttpieResponse response = await _postsApiService.replyPostComment(
        postUuid: post.uuid, postCommentId: postComment.id, text: text);
    _checkResponseIsCreated(response);
    return PostComment.fromJSON(json.decode(response.body));
  }

  Future<void> deletePostComment(
      {@required PostComment postComment, @required Post post}) async {
    HttpieResponse response = await _postsApiService.deletePostComment(
        postCommentId: postComment.id, postUuid: post.uuid);
    _checkResponseIsOk(response);
  }

  Future<Post> mutePost(Post post) async {
    HttpieResponse response =
        await _postsApiService.mutePostWithUuid(post.uuid);
    _checkResponseIsOk(response);
    return Post.fromJson(json.decode(response.body));
  }

  Future<Post> unmutePost(Post post) async {
    HttpieResponse response =
        await _postsApiService.unmutePostWithUuid(post.uuid);
    _checkResponseIsOk(response);
    return Post.fromJson(json.decode(response.body));
  }

  Future<String> excludeMemoryFromTopPosts(Memory crew) async {
    HttpieResponse response =
        await _postsApiService.excludeMemoryFromTopPosts(crewName: crew.name);
    _checkResponseIsAccepted(response);

    return (json.decode(response.body))['message'];
  }

  Future<String> undoExcludeMemoryFromTopPosts(Memory crew) async {
    HttpieResponse response = await _postsApiService
        .undoExcludeMemoryFromTopPosts(crewName: crew.name);
    _checkResponseIsAccepted(response);

    return (json.decode(response.body))['message'];
  }

  Future<String> excludeMemoryFromProfilePosts(Memory crew) async {
    HttpieResponse response = await _postsApiService
        .excludeMemoryFromProfilePosts(crewName: crew.name);
    _checkResponseIsAccepted(response);

    return (json.decode(response.body))['message'];
  }

  Future<String> undoExcludeMemoryFromProfilePosts(Memory crew) async {
    HttpieResponse response = await _postsApiService
        .undoExcludeMemoryFromProfilePosts(crewName: crew.name);
    _checkResponseIsAccepted(response);

    return (json.decode(response.body))['message'];
  }

  Future<PostComment> mutePostComment(
      {@required PostComment postComment, @required Post post}) async {
    HttpieResponse response = await _postsApiService.mutePostComment(
        postUuid: post.uuid, postCommentId: postComment.id);
    _checkResponseIsOk(response);
    return PostComment.fromJSON(json.decode(response.body));
  }

  Future<PostComment> unmutePostComment(
      {@required PostComment postComment, @required Post post}) async {
    HttpieResponse response = await _postsApiService.unmutePostComment(
        postCommentId: postComment.id, postUuid: post.uuid);
    _checkResponseIsOk(response);
    return PostComment.fromJSON(json.decode(response.body));
  }

  Future<PostCommentList> getCommentsForPost(Post post,
      {int maxId,
      int countMax,
      int minId,
      int countMin,
      PostCommentsSortType sort}) async {
    HttpieResponse response = await _postsApiService.getCommentsForPostWithUuid(
        post.uuid,
        countMax: countMax,
        maxId: maxId,
        countMin: countMin,
        minId: minId,
        sort: sort != null
            ? PostComment.convertPostCommentSortTypeToString(sort)
            : null);

    _checkResponseIsOk(response);
    return PostCommentList.fromJson(json.decode(response.body));
  }

  Future<PostCommentList> getCommentRepliesForPostComment(
      Post post, PostComment postComment,
      {int maxId,
      int countMax,
      int minId,
      int countMin,
      PostCommentsSortType sort}) async {
    HttpieResponse response = await _postsApiService
        .getRepliesForCommentWithIdForPostWithUuid(post.uuid, postComment.id,
            countMax: countMax,
            maxId: maxId,
            countMin: countMin,
            minId: minId,
            sort: sort != null
                ? PostComment.convertPostCommentSortTypeToString(sort)
                : null);

    _checkResponseIsOk(response);
    return PostCommentList.fromJson(json.decode(response.body));
  }

  Future<EmojiGroupList> getEmojiGroups() async {
    HttpieResponse response = await this._emojisApiService.getEmojiGroups();

    _checkResponseIsOk(response);

    return EmojiGroupList.fromJson(json.decode(response.body));
  }

  Future<EmojiGroupList> getReactionEmojiGroups() async {
    HttpieResponse response =
        await this._postsApiService.getReactionEmojiGroups();

    _checkResponseIsOk(response);

    return EmojiGroupList.fromJson(json.decode(response.body));
  }

  Future<LanguagesList> getAllLanguages() async {
    HttpieResponse response = await this._authApiService.getAllLanguages();

    _checkResponseIsOk(response);

    return LanguagesList.fromJson(json.decode(response.body));
  }

  Future<void> setNewLanguage(Language newLanguage) async {
    HttpieResponse response =
        await this._authApiService.setNewLanguage(newLanguage);
    _checkResponseIsOk(response);
    await refreshUser();
  }

  Future<User> getUserWithUsername(String username) async {
    HttpieResponse response = await _authApiService
        .getUserWithUsername(username, authenticatedRequest: true);
    _checkResponseIsOk(response);
    return User.fromJson(json.decode(response.body));
  }

  Future<int> countPostsForUser(User user, {int maxId, int count}) async {
    HttpieResponse response =
        await _authApiService.getPostsCountForUserWithName(user.username);
    _checkResponseIsOk(response);
    User responseUser = User.fromJson(json.decode(response.body));
    return responseUser.postsCount;
  }

  Future<UsersList> getUsersWithQuery(String query) async {
    HttpieResponse response = await _authApiService.getUsersWithQuery(query,
        authenticatedRequest: true);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> searchLinkedUsers(
      {@required String query, int count, Memory withMemory}) async {
    HttpieResponse response = await _authApiService.searchLinkedUsers(
        query: query, count: count, withMemory: withMemory.name);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body),
        storeInMaxSessionCache: true);
  }

  Future<UsersList> getLinkedUsers(
      {bool authenticatedRequest = true,
      int maxId,
      int count,
      Memory withMemory}) async {
    HttpieResponse response = await _authApiService.getLinkedUsers(
        count: count, withMemory: withMemory?.name, maxId: maxId);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body),
        storeInMaxSessionCache: true);
  }

  Future<User> blockUser(User user) async {
    HttpieResponse response =
        await _authApiService.blockUserWithUsername(user.username);
    _checkResponseIsOk(response);
    return User.fromJson(json.decode(response.body));
  }

  Future<User> unblockUser(User user) async {
    HttpieResponse response =
        await _authApiService.unblockUserWithUsername(user.username);
    _checkResponseIsOk(response);
    return User.fromJson(json.decode(response.body));
  }

  Future<User> enableNewPostNotificationsForUser(User user) async {
    HttpieResponse response = await _authApiService
        .enableNewPostNotificationsForUserWithUsername(user.username);
    _checkResponseIsCreated(response);
    return User.fromJson(json.decode(response.body));
  }

  Future<User> disableNewPostNotificationsForUser(User user) async {
    HttpieResponse response = await _authApiService
        .disableNewPostNotificationsForUserWithUsername(user.username);
    _checkResponseIsOk(response);
    return User.fromJson(json.decode(response.body));
  }

  Future<UsersList> searchBlockedUsers(
      {@required String query, int count}) async {
    HttpieResponse response =
        await _authApiService.searchBlockedUsers(query: query, count: count);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> getBlockedUsers({int maxId, int count}) async {
    HttpieResponse response =
        await _authApiService.getBlockedUsers(count: count, maxId: maxId);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<CommunitiesList> searchTopPostsExcludedCommunities(
      {@required String query, int count}) async {
    HttpieResponse response = await _postsApiService
        .searchTopPostsExcludedCommunities(query: query, count: count);
    _checkResponseIsOk(response);
    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<CommunitiesList> getTopPostsExcludedCommunities(
      {int offset, int count}) async {
    HttpieResponse response = await _postsApiService
        .getTopPostsExcludedCommunities(count: count, offset: offset);
    _checkResponseIsOk(response);
    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<CommunitiesList> searchProfilePostsExcludedCommunities(
      {@required String query, int count}) async {
    HttpieResponse response = await _postsApiService
        .searchProfilePostsExcludedCommunities(query: query, count: count);
    _checkResponseIsOk(response);
    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<CommunitiesList> getProfilePostsExcludedCommunities(
      {int offset, int count}) async {
    HttpieResponse response = await _postsApiService
        .getProfilePostsExcludedCommunities(count: count, offset: offset);
    _checkResponseIsOk(response);
    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<UsersList> searchFollowers({@required String query, int count}) async {
    HttpieResponse response =
        await _authApiService.searchFollowers(query: query, count: count);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> getFollowers(
      {bool authenticatedRequest = true,
      int maxId,
      int count,
      Memory withMemory}) async {
    HttpieResponse response =
        await _authApiService.getFollowers(count: count, maxId: maxId);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> searchFollowings(
      {@required String query, int count, Memory withMemory}) async {
    HttpieResponse response =
        await _authApiService.searchFollowings(query: query, count: count);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> getFollowings(
      {bool authenticatedRequest = true,
      int maxId,
      int count,
      Memory withMemory}) async {
    HttpieResponse response =
        await _authApiService.getFollowings(count: count, maxId: maxId);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<void> requestToFollowUser(User user) async {
    HttpieResponse response =
        await _followsApiService.requestToFollowUserWithUsername(user.username);
    _checkResponseIsCreated(response);
    user.setIsFollowRequested(true);
  }

  Future<void> cancelRequestToFollowUser(User user) async {
    HttpieResponse response = await _followsApiService
        .cancelRequestToFollowUserWithUsername(user.username);
    _checkResponseIsOk(response);
    user.setIsFollowRequested(false);
  }

  Future<void> approveFollowRequestFromUser(User user) async {
    HttpieResponse response = await _followsApiService
        .approveFollowRequestFromUserWithUsername(user.username);
    _checkResponseIsOk(response);
    user.setIsPendingFollowRequestApproval(false);
    user.setIsFollowed(true);
  }

  Future<void> rejectFollowRequestFromUser(User user) async {
    HttpieResponse response = await _followsApiService
        .rejectFollowRequestFromUserWithUsername(user.username);
    _checkResponseIsOk(response);
    user.setIsPendingFollowRequestApproval(false);
  }

  Future<FollowRequestList> getReceivedFollowRequests(
      {bool authenticatedRequest = true,
      int maxId,
      int count,
      Memory withMemory}) async {
    HttpieResponse response = await _followsApiService
        .getReceivedFollowRequests(count: count, maxId: maxId);
    _checkResponseIsOk(response);
    return FollowRequestList.fromJson(json.decode(response.body));
  }

  Future<Follow> followUserWithUsername(String username,
      {List<FollowsList> followsLists = const []}) async {
    HttpieResponse response = await _followsApiService.followUserWithUsername(
        username,
        listsIds: followsLists.map((followsList) => followsList.id).toList());
    _checkResponseIsCreated(response);
    return Follow.fromJson(json.decode(response.body));
  }

  Future<User> unFollowUserWithUsername(String username) async {
    HttpieResponse response =
        await _followsApiService.unFollowUserWithUsername(username);
    _checkResponseIsOk(response);
    return User.fromJson(json.decode(response.body));
  }

  Future<Follow> updateFollowWithUsername(String username,
      {List<FollowsList> followsLists = const []}) async {
    HttpieResponse response = await _followsApiService.updateFollowWithUsername(
        username,
        listsIds: followsLists.map((followsList) => followsList.id).toList());
    _checkResponseIsOk(response);
    return Follow.fromJson(json.decode(response.body));
  }

  Future<Connection> connectWithUserWithUsername(String username,
      {List<Circle> circles = const []}) async {
    HttpieResponse response =
        await _connectionsApiService.connectWithUserWithUsername(username,
            circlesIds: circles.map((circle) => circle.id).toList());
    _checkResponseIsCreated(response);
    return Connection.fromJson(json.decode(response.body));
  }

  Future<Connection> confirmConnectionWithUserWithUsername(String username,
      {List<Circle> circles = const []}) async {
    HttpieResponse response = await _connectionsApiService
        .confirmConnectionWithUserWithUsername(username,
            circlesIds: circles.map((circle) => circle.id).toList());
    _checkResponseIsOk(response);
    return Connection.fromJson(json.decode(response.body));
  }

  Future<User> disconnectFromUserWithUsername(String username) async {
    HttpieResponse response =
        await _connectionsApiService.disconnectFromUserWithUsername(username);
    _checkResponseIsOk(response);
    return User.fromJson(json.decode(response.body));
  }

  Future<Connection> updateConnectionWithUsername(String username,
      {List<Circle> circles = const []}) async {
    HttpieResponse response =
        await _connectionsApiService.updateConnectionWithUsername(username,
            circlesIds: circles.map((circle) => circle.id).toList());
    _checkResponseIsOk(response);
    return Connection.fromJson(json.decode(response.body));
  }

  Future<Circle> getConnectionsCircleWithId(int circleId) async {
    HttpieResponse response =
        await _connectionsCirclesApiService.getCircleWithId(circleId);
    _checkResponseIsOk(response);
    return Circle.fromJSON(json.decode(response.body));
  }

  Future<CirclesList> getConnectionsCircles() async {
    HttpieResponse response = await _connectionsCirclesApiService.getCircles();
    _checkResponseIsOk(response);
    return CirclesList.fromJson(json.decode(response.body));
  }

  Future<Circle> createConnectionsCircle(
      {@required String name, String color}) async {
    HttpieResponse response = await _connectionsCirclesApiService.createCircle(
        name: name, color: color);
    _checkResponseIsCreated(response);
    return Circle.fromJSON(json.decode(response.body));
  }

  Future<Circle> updateConnectionsCircle(Circle circle,
      {String name, String color, List<User> users = const []}) async {
    HttpieResponse response =
        await _connectionsCirclesApiService.updateCircleWithId(circle.id,
            name: name,
            color: color,
            usernames: users.map((user) => user.username).toList());
    _checkResponseIsOk(response);
    return Circle.fromJSON(json.decode(response.body));
  }

  Future<void> deleteConnectionsCircle(Circle circle) async {
    HttpieResponse response =
        await _connectionsCirclesApiService.deleteCircleWithId(circle.id);
    _checkResponseIsOk(response);
  }

  Future<FollowsListsList> getFollowsLists() async {
    HttpieResponse response = await _followsListsApiService.getLists();
    _checkResponseIsOk(response);
    return FollowsListsList.fromJson(json.decode(response.body));
  }

  Future<FollowsList> createFollowsList(
      {@required String name, Emoji emoji}) async {
    HttpieResponse response =
        await _followsListsApiService.createList(name: name, emojiId: emoji.id);
    _checkResponseIsCreated(response);
    return FollowsList.fromJSON(json.decode(response.body));
  }

  Future<FollowsList> updateFollowsList(FollowsList list,
      {String name, Emoji emoji, List<User> users}) async {
    HttpieResponse response = await _followsListsApiService.updateListWithId(
        list.id,
        name: name,
        emojiId: emoji.id,
        usernames: users.map((user) => user.username).toList());
    _checkResponseIsOk(response);
    return FollowsList.fromJSON(json.decode(response.body));
  }

  Future<void> deleteFollowsList(FollowsList list) async {
    HttpieResponse response =
        await _followsListsApiService.deleteListWithId(list.id);
    _checkResponseIsOk(response);
  }

  Future<FollowsList> getFollowsListWithId(int listId) async {
    HttpieResponse response =
        await _followsListsApiService.getListWithId(listId);
    _checkResponseIsOk(response);
    return FollowsList.fromJSON(json.decode(response.body));
  }

  Future<UserInvite> createUserInvite({String nickname}) async {
    HttpieStreamedResponse response =
        await _userInvitesApiService.createUserInvite(nickname: nickname);
    _checkResponseIsCreated(response);

    String responseBody = await response.readAsString();
    //print(json.decode(responseBody));
    return UserInvite.fromJSON(json.decode(responseBody));
  }

  Future<UserInvite> updateUserInvite(
      {String nickname, UserInvite userInvite}) async {
    HttpieStreamedResponse response = await _userInvitesApiService
        .updateUserInvite(nickname: nickname, userInviteId: userInvite.id);
    _checkResponseIsOk(response);

    String responseBody = await response.readAsString();
    return UserInvite.fromJSON(json.decode(responseBody));
  }

  Future<UserInvitesList> getUserInvites(
      {int offset, int count, UserInviteFilterByStatus status}) async {
    bool isPending = status != null
        ? UserInvite.convertUserInviteStatusToBool(status)
        : UserInvite.convertUserInviteStatusToBool(
            UserInviteFilterByStatus.all);

    HttpieResponse response = await _userInvitesApiService.getUserInvites(
        isStatusPending: isPending, count: count, offset: offset);
    _checkResponseIsOk(response);
    return UserInvitesList.fromJson(json.decode(response.body));
  }

  Future<UserInvitesList> searchUserInvites(
      {int count, UserInviteFilterByStatus status, String query}) async {
    bool isPending = status != null
        ? UserInvite.convertUserInviteStatusToBool(status)
        : UserInvite.convertUserInviteStatusToBool(
            UserInviteFilterByStatus.all);

    HttpieResponse response = await _userInvitesApiService.searchUserInvites(
        isStatusPending: isPending, count: count, query: query);
    _checkResponseIsOk(response);
    return UserInvitesList.fromJson(json.decode(response.body));
  }

  Future<void> deleteUserInvite(UserInvite userInvite) async {
    HttpieResponse response =
        await _userInvitesApiService.deleteUserInvite(userInvite.id);
    _checkResponseIsOk(response);
  }

  Future<void> sendUserInviteEmail(UserInvite userInvite, String email) async {
    HttpieResponse response = await _userInvitesApiService.emailUserInvite(
        userInviteId: userInvite.id, email: email);

    _checkResponseIsOk(response);
  }

  Future<CommunitiesList> getTrendingCommunities({Category category}) async {
    HttpieResponse response = await _memoriesApiService.getTrendingCommunities(
        category: category?.name);
    _checkResponseIsOk(response);
    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<CommunitiesList> getSuggestedCommunities() async {
    HttpieResponse response =
        await _memoriesApiService.getSuggestedCommunities();
    _checkResponseIsOk(response);
    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<Post> createPostForMemory(Memory crew,
      {String text, File image, File video, bool isDraft}) async {
    HttpieStreamedResponse response =
        await _memoriesApiService.createPostForMemoryWithId(crew.name,
            text: text, image: image, video: video, isDraft: isDraft);
    _checkResponseIsCreated(response);

    String responseBody = await response.readAsString();

    return Post.fromJson(json.decode(responseBody));
  }

  Future<PostsList> getPostsForMemory(Memory crew,
      {int maxId, int count}) async {
    HttpieResponse response = await _memoriesApiService
        .getPostsForMemoryWithName(crew.name, count: count, maxId: maxId);
    _checkResponseIsOk(response);
    return PostsList.fromJson(json.decode(response.body));
  }

  Future<int> countPostsForMemory(Memory crew, {int maxId, int count}) async {
    HttpieResponse response =
        await _memoriesApiService.getPostsCountForMemoryWithName(crew.name);
    _checkResponseIsOk(response);
    Memory responseMemory = Memory.fromJSON(json.decode(response.body));
    return responseMemory.postsCount;
  }

  Future<PostsList> getClosedPostsForMemory(Memory crew,
      {int maxId, int count}) async {
    HttpieResponse response = await _memoriesApiService
        .getClosedPostsForMemoryWithName(crew.name, count: count, maxId: maxId);
    _checkResponseIsOk(response);
    return PostsList.fromJson(json.decode(response.body));
  }

  Future<CommunitiesList> searchCommunitiesWithQuery(String query,
      {bool excludedFromProfilePosts}) async {
    HttpieResponse response =
        await _memoriesApiService.searchCommunitiesWithQuery(
            query: query, excludedFromProfilePosts: excludedFromProfilePosts);
    _checkResponseIsOk(response);
    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<Memory> createMemory(
      {@required String name,
      @required String title,
      @required List<Category> categories,
      @required MemoryType type,
      String color,
      String userAdjective,
      String usersAdjective,
      bool invitesEnabled,
      String description,
      String rules,
      File cover,
      File avatar}) async {
    HttpieStreamedResponse response = await _memoriesApiService.createMemory(
        name: name,
        title: title,
        categories: categories.map((category) => category.name).toList(),
        type: Memory.convertTypeToString(type),
        color: color,
        userAdjective: userAdjective,
        usersAdjective: usersAdjective,
        invitesEnabled: invitesEnabled,
        description: description,
        rules: rules,
        cover: cover,
        avatar: avatar);
    print(response.statusCode);
    _checkResponseIsCreated(response);

    String responseBody = await response.readAsString();

    return Memory.fromJSON(json.decode(responseBody));
  }

  Future<Memory> updateMemory(Memory crew,
      {String name,
      String title,
      List<Category> categories,
      MemoryType type,
      String color,
      String userAdjective,
      String usersAdjective,
      String description,
      bool invitesEnabled,
      String rules,
      File cover,
      File avatar}) async {
    HttpieStreamedResponse response =
        await _memoriesApiService.updateMemoryWithName(
      crew.name,
      name: name,
      title: title,
      categories: categories.map((category) => category.name).toList(),
      type: Memory.convertTypeToString(type),
      color: color,
      invitesEnabled: invitesEnabled,
      userAdjective: userAdjective,
      usersAdjective: usersAdjective,
      description: description,
      rules: rules,
    );

    _checkResponseIsOk(response);

    String responseBody = await response.readAsString();

    return Memory.fromJSON(json.decode(responseBody));
  }

  Future<Memory> updateAvatarForMemory(Memory crew,
      {@required File avatar}) async {
    HttpieStreamedResponse response = await _memoriesApiService
        .updateAvatarForMemoryWithName(crew.name, avatar: avatar);

    _checkResponseIsOk(response);

    String responseBody = await response.readAsString();

    return Memory.fromJSON(json.decode(responseBody));
  }

  Future<Memory> deleteAvatarForMemory(Memory crew) async {
    HttpieResponse response =
        await _memoriesApiService.deleteAvatarForMemoryWithName(crew.name);

    _checkResponseIsOk(response);

    String responseBody = response.body;

    return Memory.fromJSON(json.decode(responseBody));
  }

  Future<Memory> updateCoverForMemory(Memory crew,
      {@required File cover}) async {
    HttpieStreamedResponse response = await _memoriesApiService
        .updateCoverForMemoryWithName(crew.name, cover: cover);

    _checkResponseIsOk(response);

    String responseBody = await response.readAsString();

    return Memory.fromJSON(json.decode(responseBody));
  }

  Future<Memory> deleteCoverForMemory(Memory crew) async {
    HttpieResponse response =
        await _memoriesApiService.deleteCoverForMemoryWithName(crew.name);

    _checkResponseIsOk(response);

    String responseBody = response.body;

    return Memory.fromJSON(json.decode(responseBody));
  }

  Future<Memory> getMemoryWithName(String name) async {
    HttpieResponse response = await _memoriesApiService.getMemoryWithName(name);
    _checkResponseIsOk(response);
    return Memory.fromJSON(json.decode(response.body));
  }

  Future<void> deleteMemory(Memory crew) async {
    HttpieResponse response =
        await _memoriesApiService.deleteMemoryWithName(crew.name);
    _checkResponseIsOk(response);
  }

  Future<UsersList> getMembersForMemory(Memory crew,
      {int count, int maxId, List<MemoryMembersExclusion> exclude}) async {
    HttpieResponse response =
        await _memoriesApiService.getMembersForMemoryWithId(crew.name,
            count: count,
            maxId: maxId,
            exclude: exclude != null
                ? exclude
                    .map((exclude) => Memory.convertExclusionToString(exclude))
                    .toList()
                : null);

    _checkResponseIsOk(response);

    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> searchMemoryMembers(
      {@required Memory crew,
      @required String query,
      List<MemoryMembersExclusion> exclude}) async {
    HttpieResponse response = await _memoriesApiService.searchMembers(
      communityName: crew.name,
      query: query,
      exclude: exclude != null
          ? exclude
              .map((exclude) => Memory.convertExclusionToString(exclude))
              .toList()
          : null,
    );

    _checkResponseIsOk(response);

    return UsersList.fromJson(json.decode(response.body));
  }

  Future<void> inviteUserToMemory(
      {@required Memory crew, @required User user}) async {
    HttpieResponse response = await _memoriesApiService.inviteUserToMemory(
        communityName: crew.name, username: user.username);
    _checkResponseIsCreated(response);
    return User.fromJson(json.decode(response.body),
        storeInMaxSessionCache: true);
  }

  Future<void> uninviteUserFromMemory(
      {@required Memory crew, @required User user}) async {
    HttpieResponse response = await _memoriesApiService.uninviteUserFromMemory(
        communityName: crew.name, username: user.username);
    _checkResponseIsOk(response);
    return User.fromJson(json.decode(response.body),
        storeInMaxSessionCache: true);
  }

  Future<CommunitiesList> getJoinedCommunities(
      {int offset, bool excludedFromProfilePosts}) async {
    HttpieResponse response = await _memoriesApiService.getJoinedCommunities(
        offset: offset, excludedFromProfilePosts: excludedFromProfilePosts);

    _checkResponseIsOk(response);

    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<CommunitiesList> searchJoinedCommunities(
      {@required String query, int count, Memory withMemory}) async {
    HttpieResponse response = await _memoriesApiService.searchJoinedCommunities(
        query: query, count: count);
    _checkResponseIsOk(response);
    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<Memory> joinMemory(Memory crew) async {
    HttpieResponse response =
        await _memoriesApiService.joinMemoryWithId(crew.name);
    _checkResponseIsCreated(response);
    return Memory.fromJSON(json.decode(response.body));
  }

  Future<Memory> leaveMemory(Memory crew) async {
    HttpieResponse response =
        await _memoriesApiService.leaveMemoryWithId(crew.name);
    _checkResponseIsOk(response);
    return Memory.fromJSON(json.decode(response.body));
  }

  Future<UsersList> getModeratorsForMemory(Memory crew,
      {int count, int maxId}) async {
    HttpieResponse response = await _memoriesApiService
        .getModeratorsForMemoryWithId(crew.name, count: count, maxId: maxId);

    _checkResponseIsOk(response);

    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> searchMemoryModerators({
    @required Memory crew,
    @required String query,
  }) async {
    HttpieResponse response = await _memoriesApiService.searchModerators(
      communityName: crew.name,
      query: query,
    );

    _checkResponseIsOk(response);

    return UsersList.fromJson(json.decode(response.body));
  }

  Future<void> addMemoryModerator(
      {@required Memory crew, @required User user}) async {
    HttpieResponse response = await _memoriesApiService.addMemoryModerator(
        communityName: crew.name, username: user.username);
    _checkResponseIsCreated(response);
  }

  Future<void> removeMemoryModerator(
      {@required Memory crew, @required User user}) async {
    HttpieResponse response = await _memoriesApiService.removeMemoryModerator(
        communityName: crew.name, username: user.username);
    _checkResponseIsOk(response);
  }

  Future<UsersList> getAdministratorsForMemory(Memory crew,
      {int count, int maxId}) async {
    HttpieResponse response =
        await _memoriesApiService.getAdministratorsForMemoryWithName(crew.name,
            count: count, maxId: maxId);

    _checkResponseIsOk(response);

    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> searchMemoryAdministrators({
    @required Memory crew,
    @required String query,
  }) async {
    HttpieResponse response = await _memoriesApiService.searchAdministrators(
      communityName: crew.name,
      query: query,
    );

    _checkResponseIsOk(response);

    return UsersList.fromJson(json.decode(response.body));
  }

  Future<Memory> addMemoryAdministrator(
      {@required Memory crew, @required User user}) async {
    HttpieResponse response = await _memoriesApiService.addMemoryAdministrator(
        communityName: crew.name, username: user.username);
    _checkResponseIsCreated(response);
    return Memory.fromJSON(json.decode(response.body));
  }

  Future<void> removeMemoryAdministrator(
      {@required Memory crew, @required User user}) async {
    HttpieResponse response =
        await _memoriesApiService.removeMemoryAdministrator(
            communityName: crew.name, username: user.username);
    _checkResponseIsOk(response);
  }

  Future<UsersList> getBannedUsersForMemory(Memory crew,
      {int count, int maxId}) async {
    HttpieResponse response = await _memoriesApiService
        .getBannedUsersForMemoryWithId(crew.name, count: count, maxId: maxId);

    _checkResponseIsOk(response);

    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> searchMemoryBannedUsers({
    @required Memory crew,
    @required String query,
  }) async {
    HttpieResponse response = await _memoriesApiService.searchBannedUsers(
      communityName: crew.name,
      query: query,
    );

    _checkResponseIsOk(response);

    return UsersList.fromJson(json.decode(response.body));
  }

  Future<void> banMemoryUser(
      {@required Memory crew, @required User user}) async {
    HttpieResponse response = await _memoriesApiService.banMemoryUser(
        communityName: crew.name, username: user.username);
    _checkResponseIsOk(response);
  }

  Future<void> unbanMemoryUser(
      {@required Memory crew, @required User user}) async {
    HttpieResponse response = await _memoriesApiService.unbanMemoryUser(
        communityName: crew.name, username: user.username);
    _checkResponseIsOk(response);
  }

  Future<CommunitiesList> getFavoriteCommunities({int offset}) async {
    HttpieResponse response =
        await _memoriesApiService.getFavoriteCommunities(offset: offset);

    _checkResponseIsOk(response);

    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<CommunitiesList> searchFavoriteCommunities(
      {String query, int count}) async {
    HttpieResponse response = await _memoriesApiService
        .searchFavoriteCommunities(query: query, count: count);

    _checkResponseIsOk(response);

    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<void> favoriteMemory(Memory crew) async {
    HttpieResponse response =
        await _memoriesApiService.favoriteMemory(communityName: crew.name);
    _checkResponseIsCreated(response);
    return Memory.fromJSON(json.decode(response.body));
  }

  Future<void> unfavoriteMemory(Memory crew) async {
    HttpieResponse response =
        await _memoriesApiService.unfavoriteMemory(communityName: crew.name);
    _checkResponseIsOk(response);
    return Memory.fromJSON(json.decode(response.body));
  }

  Future<void> enableNewPostNotificationsForMemory(Memory crew) async {
    HttpieResponse response = await _memoriesApiService
        .enableNewPostNotificationsForMemory(communityName: crew.name);
    _checkResponseIsCreated(response);

    return Memory.fromJSON(json.decode(response.body));
  }

  Future<void> disableNewPostNotificationsForMemory(Memory crew) async {
    HttpieResponse response = await _memoriesApiService
        .disableNewPostNotificationsForMemory(communityName: crew.name);
    _checkResponseIsOk(response);

    return Memory.fromJSON(json.decode(response.body));
  }

  Future<CommunitiesList> getAdministratedCommunities({int offset}) async {
    HttpieResponse response =
        await _memoriesApiService.getAdministratedCommunities(offset: offset);

    _checkResponseIsOk(response);

    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<CommunitiesList> searchAdministratedCommunities(
      {String query, int count}) async {
    HttpieResponse response = await _memoriesApiService
        .searchAdministratedCommunities(query: query, count: count);

    _checkResponseIsOk(response);

    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<CommunitiesList> getModeratedCommunities({int offset}) async {
    HttpieResponse response =
        await _memoriesApiService.getModeratedCommunities(offset: offset);

    _checkResponseIsOk(response);

    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<CommunitiesList> searchModeratedCommunities(
      {String query, int count}) async {
    HttpieResponse response = await _memoriesApiService
        .searchModeratedCommunities(query: query, count: count);

    _checkResponseIsOk(response);

    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<CategoriesList> getCategories() async {
    HttpieResponse response = await _categoriesApiService.getCategories();
    _checkResponseIsOk(response);
    return CategoriesList.fromJson(json.decode(response.body));
  }

  Future<HashtagsList> getHashtagsWithQuery(String query) async {
    HttpieResponse response =
        await _hashtagsApiService.getHashtagsWithQuery(query: query);
    _checkResponseIsOk(response);
    return HashtagsList.fromJson(json.decode(response.body));
  }

  Future<PostsList> getPostsForHashtag(Hashtag hashtag,
      {int maxId, int count}) async {
    HttpieResponse response = await _hashtagsApiService
        .getPostsForHashtagWithName(hashtag.name, count: count, maxId: maxId);
    _checkResponseIsOk(response);
    return PostsList.fromJson(json.decode(response.body));
  }

  Future<Hashtag> getHashtagWithName(String name) async {
    HttpieResponse response =
        await _hashtagsApiService.getHashtagWithName(name);
    _checkResponseIsOk(response);
    return Hashtag.fromJSON(json.decode(response.body));
  }

  Future<NotificationsList> getNotifications(
      {int maxId, int count, List<NotificationType> types}) async {
    HttpieResponse response = await _notificationsApiService.getNotifications(
        maxId: maxId, count: count, types: types);
    _checkResponseIsOk(response);
    return NotificationsList.fromJson(json.decode(response.body));
  }

  Future<int> getUnreadNotificationsCount(
      {int maxId, List<NotificationType> types}) async {
    HttpieResponse response = await _notificationsApiService
        .getUnreadNotificationsCount(maxId: maxId, types: types);
    _checkResponseIsOk(response);
    return (json.decode(response.body))['count'];
  }

  Future<OBNotification> getNotificationWithId(int notificationId) async {
    HttpieResponse response =
        await _notificationsApiService.getNotificationWithId(notificationId);
    _checkResponseIsOk(response);
    return OBNotification.fromJSON(json.decode(response.body));
  }

  Future<void> readNotifications(
      {int maxId, List<NotificationType> types}) async {
    HttpieResponse response = await _notificationsApiService.readNotifications(
        maxId: maxId, types: types);
    _checkResponseIsOk(response);
  }

  Future<void> deleteNotifications() async {
    HttpieResponse response =
        await _notificationsApiService.deleteNotifications();
    _checkResponseIsOk(response);
  }

  Future<void> deleteNotification(OBNotification notification) async {
    HttpieResponse response = await _notificationsApiService
        .deleteNotificationWithId(notification.id);
    _checkResponseIsOk(response);
  }

  Future<void> readNotification(OBNotification notification) async {
    HttpieResponse response =
        await _notificationsApiService.readNotificationWithId(notification.id);
    _checkResponseIsOk(response);
  }

  Future<DevicesList> getDevices() async {
    HttpieResponse response = await _devicesApiService.getDevices();
    _checkResponseIsOk(response);
    return DevicesList.fromJson(json.decode(response.body));
  }

  Future<void> deleteDevices() async {
    HttpieResponse response = await _devicesApiService.deleteDevices();
    _checkResponseIsOk(response);
  }

  Future<Device> createDevice({@required String uuid, String name}) async {
    HttpieResponse response =
        await _devicesApiService.createDevice(uuid: uuid, name: name);
    _checkResponseIsCreated(response);
    return Device.fromJSON(json.decode(response.body));
  }

  Future<Device> updateDevice(Device device, {String name}) async {
    HttpieResponse response = await _devicesApiService.updateDeviceWithUuid(
      device.uuid,
      name: name,
    );
    _checkResponseIsCreated(response);
    return Device.fromJSON(json.decode(response.body));
  }

  Future<void> deleteDevice(Device device) async {
    HttpieResponse response =
        await _devicesApiService.deleteDeviceWithUuid(device.uuid);
    _checkResponseIsOk(response);
  }

  Future<Device> getDeviceWithUuid(String deviceUuid) async {
    HttpieResponse response =
        await _devicesApiService.getDeviceWithUuid(deviceUuid);
    _checkResponseIsOk(response);
    return Device.fromJSON(json.decode(response.body));
  }

  Future<Device> getOrCreateCurrentDevice() async {
    if (_getOrCreateCurrentDeviceCache != null)
      return _getOrCreateCurrentDeviceCache;

    _getOrCreateCurrentDeviceCache = _getOrCreateCurrentDevice();
    _getOrCreateCurrentDeviceCache.catchError((error) {
      _getOrCreateCurrentDeviceCache = null;
      throw error;
    });

    return _getOrCreateCurrentDeviceCache;
  }

  Future<Device> _getOrCreateCurrentDevice() async {
    if (_getOrCreateCurrentDeviceCache != null)
      return _getOrCreateCurrentDeviceCache;

    String deviceUuid = await _getDeviceUuid();
    HttpieResponse response =
        await _devicesApiService.getDeviceWithUuid(deviceUuid);

    if (response.isNotFound()) {
      // Device does not exists, create one.
      String deviceName = await _getDeviceName();
      return createDevice(uuid: deviceUuid, name: deviceName);
    } else if (response.isOk()) {
      // Device exists
      return Device.fromJSON(json.decode(response.body));
    } else {
      throw HttpieRequestError(response);
    }
  }

  Future<void> _deleteCurrentDevice() async {
    if (_getOrCreateCurrentDeviceCache == null) return;

    Device currentDevice = await _getOrCreateCurrentDeviceCache;

    HttpieResponse response =
        await _devicesApiService.deleteDeviceWithUuid(currentDevice.uuid);

    if (!response.isOk() && !response.isNotFound()) {
      print('Could not delete current device');
    } else {
      print('Deleted current device successfully');
    }
  }

  Future<UserNotificationsSettings>
      getAuthenticatedUserNotificationsSettings() async {
    HttpieResponse response =
        await _authApiService.getAuthenticatedUserNotificationsSettings();
    _checkResponseIsOk(response);
    return UserNotificationsSettings.fromJSON(json.decode(response.body));
  }

  Future<UserNotificationsSettings>
      updateAuthenticatedUserNotificationsSettings({
    bool postCommentNotifications,
    bool postCommentReplyNotifications,
    bool postCommentReactionNotifications,
    bool postCommentUserMentionNotifications,
    bool postUserMentionNotifications,
    bool postReactionNotifications,
    bool followNotifications,
    bool followRequestNotifications,
    bool followRequestApprovedNotifications,
    bool connectionRequestNotifications,
    bool connectionConfirmedNotifications,
    bool crewInviteNotifications,
    bool crewNewPostNotifications,
    bool userNewPostNotifications,
  }) async {
    HttpieResponse response =
        await _authApiService.updateAuthenticatedUserNotificationsSettings(
            postCommentNotifications: postCommentNotifications,
            postCommentReplyNotifications: postCommentReplyNotifications,
            postCommentUserMentionNotifications:
                postCommentUserMentionNotifications,
            postUserMentionNotifications: postUserMentionNotifications,
            postCommentReactionNotifications: postCommentReactionNotifications,
            postReactionNotifications: postReactionNotifications,
            followNotifications: followNotifications,
            followRequestNotifications: followRequestNotifications,
            followRequestApprovedNotifications:
                followRequestApprovedNotifications,
            connectionConfirmedNotifications: connectionConfirmedNotifications,
            crewInviteNotifications: crewInviteNotifications,
            connectionRequestNotifications: connectionRequestNotifications,
            crewNewPostNotifications: crewNewPostNotifications,
            userNewPostNotifications: userNewPostNotifications);
    _checkResponseIsOk(response);
    return UserNotificationsSettings.fromJSON(json.decode(response.body));
  }

  Future<void> reportUser(
      {@required User user,
      String description,
      @required ModerationCategory moderationCategory}) async {
    HttpieResponse response = await _authApiService.reportUserWithUsername(
        description: description,
        userUsername: user.username,
        moderationCategoryId: moderationCategory.id);
    _checkResponseIsCreated(response);
  }

  Future<void> reportHashtag(
      {@required Hashtag hashtag,
      String description,
      @required ModerationCategory moderationCategory}) async {
    HttpieResponse response = await _hashtagsApiService.reportHashtagWithName(
        description: description,
        hashtagName: hashtag.name,
        moderationCategoryId: moderationCategory.id);
    _checkResponseIsCreated(response);
  }

  Future<void> reportMemory(
      {@required Memory crew,
      String description,
      @required ModerationCategory moderationCategory}) async {
    HttpieResponse response = await _memoriesApiService.reportMemoryWithName(
        communityName: crew.name,
        description: description,
        moderationCategoryId: moderationCategory.id);
    _checkResponseIsCreated(response);
  }

  Future<void> reportPost(
      {@required Post post,
      String description,
      @required ModerationCategory moderationCategory}) async {
    HttpieResponse response = await _postsApiService.reportPost(
        description: description,
        postUuid: post.uuid,
        moderationCategoryId: moderationCategory.id);
    _checkResponseIsCreated(response);
  }

  Future<void> reportPostComment(
      {@required PostComment postComment,
      @required Post post,
      String description,
      @required ModerationCategory moderationCategory}) async {
    HttpieResponse response = await _postsApiService.reportPostComment(
        postCommentId: postComment.id,
        postUuid: post.uuid,
        description: description,
        moderationCategoryId: moderationCategory.id);
    _checkResponseIsCreated(response);
  }

  Future<ModeratedObjectsList> getGlobalModeratedObjects(
      {List<ModeratedObjectStatus> statuses,
      List<ModeratedObjectType> types,
      int count,
      int maxId,
      bool verified}) async {
    HttpieResponse response =
        await _moderationApiService
            .getGlobalModeratedObjects(
                maxId: maxId,
                verified: verified,
                types: types != null
                    ? types
                        .map((ModeratedObjectType type) =>
                            ModeratedObject.factory.convertTypeToString(type))
                        .toList()
                    : null,
                statuses:
                    statuses != null
                        ? statuses
                            .map(
                                (ModeratedObjectStatus status) =>
                                    ModeratedObject.factory
                                        .convertStatusToString(status))
                            .toList()
                        : null,
                count: count);

    _checkResponseIsOk(response);

    return ModeratedObjectsList.fromJson(json.decode(response.body));
  }

  Future<ModeratedObjectsList> getMemoryModeratedObjects(
      {@required Memory crew,
      List<ModeratedObjectStatus> statuses,
      List<ModeratedObjectType> types,
      int count,
      int maxId,
      bool verified}) async {
    HttpieResponse response = await _memoriesApiService.getModeratedObjects(
        communityName: crew.name,
        maxId: maxId,
        verified: verified,
        types: types != null
            ? types
                .map((status) =>
                    ModeratedObject.factory.convertTypeToString(status))
                .toList()
            : null,
        statuses: statuses != null
            ? statuses
                .map((status) =>
                    ModeratedObject.factory.convertStatusToString(status))
                .toList()
            : null,
        count: count);

    _checkResponseIsOk(response);

    return ModeratedObjectsList.fromJson(json.decode(response.body));
  }

  Future<void> updateModeratedObject(ModeratedObject moderatedObject,
      {String description, ModerationCategory category}) async {
    HttpieResponse response = await _moderationApiService
        .updateModeratedObjectWithId(moderatedObject.id,
            description: description, categoryId: category?.id);
    _checkResponseIsOk(response);
    return ModeratedObject.fromJSON(json.decode(response.body));
  }

  Future<void> verifyModeratedObject(ModeratedObject moderatedObject) async {
    HttpieResponse response = await _moderationApiService
        .verifyModeratedObjectWithId(moderatedObject.id);
    _checkResponseIsOk(response);
  }

  Future<ModeratedObjectLogsList> getModeratedObjectLogs(
      ModeratedObject moderatedObject,
      {int maxId,
      int count}) async {
    HttpieResponse response = await _moderationApiService
        .getModeratedObjectLogs(moderatedObject.id, maxId: maxId, count: count);
    _checkResponseIsOk(response);

    return ModeratedObjectLogsList.fromJson(json.decode(response.body));
  }

  Future<ModerationReportsList> getModeratedObjectReports(
      ModeratedObject moderatedObject,
      {int maxId,
      int count}) async {
    HttpieResponse response = await _moderationApiService
        .getModeratedObjectReports(moderatedObject.id,
            maxId: maxId, count: count);
    _checkResponseIsOk(response);

    return ModerationReportsList.fromJson(json.decode(response.body));
  }

  Future<ModerationPenaltiesList> getModerationPenalties(
      {int maxId, int count}) async {
    HttpieResponse response = await _moderationApiService
        .getUserModerationPenalties(maxId: maxId, count: count);
    _checkResponseIsOk(response);

    return ModerationPenaltiesList.fromJson(json.decode(response.body));
  }

  Future<CommunitiesList> getPendingModeratedObjectsCommunities(
      {int maxId, int count}) async {
    HttpieResponse response = await _moderationApiService
        .getUserPendingModeratedObjectsCommunities(maxId: maxId, count: count);
    _checkResponseIsOk(response);

    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<void> unverifyModeratedObject(ModeratedObject moderatedObject) async {
    HttpieResponse response = await _moderationApiService
        .unverifyModeratedObjectWithId(moderatedObject.id);
    _checkResponseIsOk(response);
  }

  Future<void> approveModeratedObject(ModeratedObject moderatedObject) async {
    HttpieResponse response = await _moderationApiService
        .approveModeratedObjectWithId(moderatedObject.id);
    _checkResponseIsOk(response);
  }

  Future<void> rejectModeratedObject(ModeratedObject moderatedObject) async {
    HttpieResponse response = await _moderationApiService
        .rejectModeratedObjectWithId(moderatedObject.id);
    _checkResponseIsOk(response);
  }

  Future<ModerationCategoriesList> getModerationCategories() async {
    HttpieResponse response =
        await _moderationApiService.getModerationCategories();

    _checkResponseIsOk(response);
    print(response.body);
    return ModerationCategoriesList.fromJson(json.decode(response.body));
  }

  Future<String> translatePost({@required Post post}) async {
    HttpieResponse response =
        await _postsApiService.translatePost(postUuid: post.uuid);

    _checkResponseIsOk(response);

    return json.decode(response.body)['translated_text'];
  }

  Future<String> translatePostComment(
      {@required Post post, @required PostComment postComment}) async {
    HttpieResponse response = await _postsApiService.translatePostComment(
        postUuid: post.uuid, postCommentId: postComment.id);

    _checkResponseIsOk(response);

    return json.decode(response.body)['translated_text'];
  }

  Future<UsersList> getPostParticipants(
      {@required Post post, int count}) async {
    HttpieResponse response = await _postsApiService.getPostParticipants(
        count: count, postUuid: post.uuid);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> searchPostParticipants(
      {@required String query, @required Post post, int count}) async {
    HttpieResponse response = await _postsApiService.searchPostParticipants(
        query: query, count: count, postUuid: post.uuid);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<LinkPreview> previewLink({@required String link}) async {
    HttpieResponse response = await _postsApiService.previewLink(link: link);
    _checkResponseIsOk(response);
    return LinkPreview.fromJSON(json.decode(response.body));
  }

  Future<bool> linkIsPreviewable({@required String link}) async {
    HttpieResponse response =
        await _postsApiService.linkIsPreviewable(link: link);
    _checkResponseIsOk(response);
    bool isPreviewable = json.decode(response.body)['is_previewable'];
    return isPreviewable;
  }

  Map<UserVisibility, Map<String, String>> getUserVisibilityLocalizationMap() {
    var publicMap = {
      'title': _localizationService.user__visibility_public,
      'description': _localizationService.user__visibility_public_desc
    };

    var SiuuMap = {
      'title': _localizationService.user__visibility_Siuu,
      'description': _localizationService.user__visibility_Siuu_desc
    };

    var privateMap = {
      'title': _localizationService.user__visibility_private,
      'description': _localizationService.user__visibility_private_desc
    };

    return {
      UserVisibility.public: publicMap,
      UserVisibility.Siuu: SiuuMap,
      UserVisibility.private: privateMap,
    };
  }

  Future<String> _getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    String deviceName;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      deviceName = iosDeviceInfo.utsname.machine;
    } else {
      deviceName = 'Unknown';
    }

    return deviceName;
  }

  Future<String> _getDeviceUuid() async {
    String identifier;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      var build = await deviceInfo.androidInfo;
      identifier = build.androidId;
    } else if (Platform.isIOS) {
      var data = await deviceInfo.iosInfo;
      identifier = data.identifierForVendor;
    } else {
      throw 'Unsupported platform';
    }

    var bytes = utf8.encode(identifier);
    var digest = sha256.convert(bytes);

    return digest.toString();
  }

  Future<User> _setUserWithData(String userData) async {
    print("this is userData::${userData}");

    var user = _makeLoggedInUser(userData);
    _setLoggedInUser(user);
    await _storeUserData(userData);

    return user;
  }

  Future<void> setLanguageFromDefaults() async {
    Locale currentLocale = _localizationService.getLocale();
    LanguagesList languageList = await getAllLanguages();
    Language deviceLanguage =
        languageList.languages.firstWhere((Language language) {
      return language.code.toLowerCase() ==
          currentLocale.languageCode.toLowerCase();
    });

    if (deviceLanguage != null) {
      print('Setting language from defaults ${currentLocale.languageCode}');
      return await setNewLanguage(deviceLanguage);
    } else {
      Language english = languageList.languages.firstWhere(
          (Language language) => language.code.toLowerCase() == 'en');
      return await setNewLanguage(english);
    }
  }

  void _checkResponseIsCreated(HttpieBaseResponse response) {
    if (response.isCreated()) return;
    throw HttpieRequestError(response);
  }

  void _checkResponseIsOk(HttpieBaseResponse response) {
    print("response::$response");

    if (response.isOk()) return;
    throw HttpieRequestError(response);
  }

  void _checkResponseIsAccepted(HttpieBaseResponse response) {
    if (response.isAccepted()) return;
    throw HttpieRequestError(response);
  }

  void _setLoggedInUser(User user) {
    if (_loggedInUser == null || _loggedInUser.id != user.id)
      _loggedInUserChangeSubject.add(user);
    _loggedInUser = user;
  }

  void _removeLoggedInUser() {
    _loggedInUser = null;
    _loggedInUserChangeSubject.add(null);
  }

  Future<void> _setAuthToken(String authToken) async {
    _authToken = authToken;
    _httpieService.setAuthorizationToken(authToken);
    await _storeAuthToken(authToken);
  }

  Future<void> _storeAuthToken(String authToken) {
    return _userStorage.set(STORAGE_KEY_AUTH_TOKEN, authToken);
  }

  Future<String> _getStoredAuthToken() async {
    String authToken = await _userStorage.get(STORAGE_KEY_AUTH_TOKEN);
    if (authToken != null) _authToken = authToken;
    // print("authTokn$_authToken");
    return authToken;
  }

  Future<void> _removeStoredAuthToken() async {
    _userStorage.remove(STORAGE_KEY_AUTH_TOKEN);
  }

  Future<void> _storeUserData(String userData) {
    return _userStorage.set(STORAGE_KEY_USER_DATA, userData);
  }

  Future<void> _removeStoredUserData() async {
    _userStorage.remove(STORAGE_KEY_USER_DATA);
  }

  Future<String> _getStoredUserData() async {
    return _userStorage.get(STORAGE_KEY_USER_DATA);
  }

  Future<void> _storeFirstPostsData(String firstPostsData) {
    return _userStorage.set(STORAGE_FIRST_POSTS_DATA, firstPostsData);
  }

  Future<void> _removeStoredFirstPostsData() async {
    _userStorage.remove(STORAGE_FIRST_POSTS_DATA);
  }

  Future<String> _getStoredFirstPostsData() async {
    return _userStorage.get(STORAGE_FIRST_POSTS_DATA);
  }

  Future<void> _storeTopPostsData(String topPostsData) {
    return _userStorage.set(STORAGE_TOP_POSTS_DATA, topPostsData);
  }

  Future<void> _removeStoredTopPostsData() async {
    _userStorage.remove(STORAGE_TOP_POSTS_DATA);
  }

  Future<String> _getStoredTopPostsData() async {
    return _userStorage.get(STORAGE_TOP_POSTS_DATA);
  }

  Future<void> _storeTopPostsLastViewedId(String scrollPosition) {
    return _userStorage.set(STORAGE_TOP_POSTS_LAST_VIEWED_ID, scrollPosition);
  }

  Future<void> _removeStoredTopPostsLastViewedId() async {
    _userStorage.remove(STORAGE_TOP_POSTS_LAST_VIEWED_ID);
  }

  Future<String> _getStoredTopPostsLastViewedId() async {
    return _userStorage.get(STORAGE_TOP_POSTS_LAST_VIEWED_ID);
  }

  User _makeLoggedInUser(String userData) {
    return User.fromJson(json.decode(userData), storeInSessionCache: true);
  }

  PostsList _makePostsList(String postsData) {
    return PostsList.fromJson(json.decode(postsData));
  }

  TopPostsList _makeTopPostsList(String postsData) {
    return TopPostsList.fromJson((json.decode(postsData)));
  }
}

class CredentialsMismatchError implements Exception {
  final String msg;

  const CredentialsMismatchError(this.msg);

  String toString() => 'CredentialsMismatchError: $msg';
}

class AuthTokenMissingError implements Exception {
  const AuthTokenMissingError();

  String toString() => 'AuthTokenMissingError: No auth token was found.';
}

class NotLoggedInUserError implements Exception {
  const NotLoggedInUserError();

  String toString() => 'NotLoggedInUserError: No user is logged in.';
}
