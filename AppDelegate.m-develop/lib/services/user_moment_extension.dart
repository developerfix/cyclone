part of 'user.dart';

extension UserMomentExtension on UserService {
  Future<void> deleteStory({
    @required int storyId,
  }) async {
    HttpieResponse response =
        await _postsApiService.deleteMoment(storyId: storyId);

    print(response.body);
  }

  Future<MomentComment> uploadStoryComments({
    @required String text,
    @required int storyId,
  }) async {
    User user = await refreshUser();
    HttpieResponse response = await _postsApiService.commentMoment(
      userId: user.id,
      avtar: user.profile.avatar,
      text: text,
      storyId: storyId,
      name: user.profile.name,
    );

    print(response.body);

    //_checkResponseIsCreated(response);
    return MomentComment.fromJson(json.decode(response.body)['data']);
  }

  Future<MomentCommentList> getCommentsForMoment(int storyId) async {
    HttpieResponse response =
        await _postsApiService.getMomentcomments(storyId: storyId);

    _checkResponseIsOk(response);
    /*var testComment = MomentComment(
        id: 61,
        userId: "1",
        name: "armello",
        avatar: "https://www.gstatic.com/webp/gallery/1.jpg",
        text: "deneme yaz with",
        emoji: null,
        time: DateTime.parse("2021-08-02T09:38:06.951081+02:00"),
        story: 149,
        commenter: null);
    var testCommentNoAvatar = MomentComment(
        id: 62,
        userId: "1",
        name: "armello",
        avatar: null,
        text: "deneme yaz with",
        emoji: null,
        time: DateTime.parse("2021-08-02T09:38:06.951081+02:00"),
        story: 149,
        commenter: null);
    List<MomentComment> comments = [];
    comments.add(testCommentNoAvatar);
    comments.add(testComment);
    comments.add(testComment);
    comments.add(testComment);
    comments.add(testComment);
    return MomentCommentList(
      commentCount: 1,
      comments: comments,
    );*/
    return MomentCommentList.fromJson(json.decode(response.body));
  }

  /*Future<StoryComment> getStoryComments({
    @required int storyId,
  }) async {
    HttpieResponse response =
        await _postsApiService.getMomentcomments(storyId: storyId);

    print(response.body);
    // _checkResponseIsCreated(response);
    StoryComment storyComment = storyCommentFromMap(response.body);

    return storyComment;
  }*/

  Future<void> deleteStoryComment({
    @required int storyId,
    @required int commentId,
  }) async {
    HttpieResponse response = await _postsApiService.deleteMomentComment(
        commentId: commentId.toString(), storyId: storyId.toString());

    print(response.body);
  }

  Future<MomentReactionList> getReactionsForMoment(int storyId) async {
    HttpieResponse response =
        await _postsApiService.getReactionsForMomentWithId(storyId);

    _checkResponseIsOk(response);

    return MomentReactionList.fromJson(json.decode(response.body));
  }

  Future<MomentReaction> reactToMoment(
      {@required int storyid,
      @required String reaction,
      @required String avatar}) async {
    HttpieResponse response = await _postsApiService.reactToMoment(
        momentId: storyid, reaction: reaction, avatar: avatar);
    //_checkResponseIsCreated(response);
    return MomentReaction.fromJson(json.decode(response.body)[0]);
  }

  Future<void> deleteMomentReaction({
    @required Story story,
  }) async {
    HttpieResponse response = await _postsApiService.deleteMomentReaction(
      storyId: story.id.toString(),
    );
    _checkResponseIsOk(response);
  }

  Future<MomentViewers> getMomentViewers({@required int storyId}) async {
    HttpieResponse response =
        await _postsApiService.getMomentViewers(momentId: storyId);
    //_checkResponseIsCreated(response);
    return MomentViewers.fromJson(json.decode(response.body));
  }

  Future<void> putMomentView({@required int storyId}) async {
    HttpieResponse response =
        await _postsApiService.putMomentView(momentId: storyId);
    //_checkResponseIsCreated(response);
  }

  /*Future<ReactionsEmojiCountList> getReactionsEmojiCountForPost(
      Post post) async {
    HttpieResponse response =
        await _postsApiService.getReactionsEmojiCountForPostWithUuid(post.uuid);

    _checkResponseIsOk(response);

    return ReactionsEmojiCountList.fromJson(json.decode(response.body));
  }*/

  /*Future<MomentCommentReaction> reactToPostComment(
      {@required Post post,
      @required PostComment postComment,
      @required Emoji emoji}) async {
    HttpieResponse response = await _postsApiService.reactToPostComment(
      postCommentId: postComment.id,
      postUuid: post.uuid,
      emojiId: emoji.id,
    );
    _checkResponseIsCreated(response);
    return MomentCommentReaction.fromJson(json.decode(response.body));
  }

  Future<void> deletePostCommentReaction(
      {@required MomentCommentReaction postCommentReaction,
      @required MomentComment postComment,
      @required Story story}) async {
    HttpieResponse response = await _postsApiService.deletePostCommentReaction(
        postCommentReactionId: postCommentReaction.id,
        postUuid: post.uuid,
        postCommentId: postComment.id);
    _checkResponseIsOk(response);
  }

  Future<MomentCommentReactionList> getReactionsForPostComment(
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
  }*/
}
