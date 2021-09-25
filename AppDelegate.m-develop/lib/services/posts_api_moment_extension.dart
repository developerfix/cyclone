part of 'posts_api.dart';

extension PostsApiMomentExtension on PostsApiService {
  Future<HttpieResponse> deleteMoment({
    @required int storyId,
  }) {
    Map<String, dynamic> body = {
      'story_id': storyId.toString(),
    };
    return _httpService.delete(_makeApiUrl(PostsApiService.STORY_PATH),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getMomentcomments({
    @required int storyId,
  }) async {
    Map<String, dynamic> body = {
      'story_id': storyId.toString(),
    };

    return _httpService.get(_makeApiUrl(PostsApiService.STORY_COMMENT_PATH),
        queryParameters: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> commentMoment({
    @required String text,
    @required int storyId,
    @required String name,
    @required int userId,
    @required String avtar,
  }) {
    Map<String, dynamic> body = {
      'text': text,
      'story': storyId,
      'user_id': userId,
      'avatar': avtar,
      'name': name,
    };
    return _httpService.putJSON(_makeApiUrl(PostsApiService.STORY_COMMENT_PATH),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deleteMomentComment(
      {@required String commentId, @required String storyId}) {
    Map<String, dynamic> body = {
      'story': storyId,
      'comment_id': commentId,
    };

    return _httpService.delete(_makeApiUrl(PostsApiService.STORY_COMMENT_PATH),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getReactionsForMomentWithId(int storyId) {
    Map<String, dynamic> body = {
      'story': storyId.toString(),
    };

    return _httpService.get(_makeApiUrl(PostsApiService.STORY_REACTION_PATH),
        queryParameters: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> reactToMoment({
    @required int momentId,
    @required String reaction,
    @required String avatar,
  }) {
    Map<String, dynamic> body = {
      'story_id': momentId,
      'text': reaction,
      'avatar': avatar
    };

    return _httpService.putJSON(
        _makeApiUrl(PostsApiService.STORY_REACTION_PATH),
        body: body,
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deleteMomentReaction({@required String storyId}) {
    Map<String, dynamic> body = {
      'story': storyId,
    };

    return _httpService.delete(_makeApiUrl(PostsApiService.STORY_REACTION_PATH),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getMomentViewers({
    @required int momentId,
  }) {
    Map<String, dynamic> body = {'story_id': momentId};

    return _httpService.get(_makeApiUrl(PostsApiService.STORY_STATUS_PATH),
        queryParameters: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> putMomentView({@required int momentId}) {
    Map<String, dynamic> body = {'story_id': momentId};

    return _httpService.putJSON(_makeApiUrl(PostsApiService.STORY_STATUS_PATH),
        body: body, appendAuthorizationToken: true);
  }
}
