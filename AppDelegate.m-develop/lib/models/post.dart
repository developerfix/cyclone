import 'package:Siuu/models/circle.dart';
import 'package:Siuu/models/circles_list.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/emoji.dart';
import 'package:Siuu/models/hashtag.dart';
import 'package:Siuu/models/hashtags_list.dart';
import 'package:Siuu/models/Share_story_data.dart';
import 'package:Siuu/models/post_comment.dart';
import 'package:Siuu/models/post_comment_list.dart';
import 'package:Siuu/models/post_link.dart';
import 'package:Siuu/models/post_links_list.dart';
import 'package:Siuu/models/post_media.dart';
import 'package:Siuu/models/post_media_list.dart';
import 'package:Siuu/models/post_reaction.dart';
import 'package:Siuu/models/post_text.dart';
import 'package:Siuu/models/reactions_emoji_count.dart';
import 'package:Siuu/models/reactions_emoji_count_list.dart';
import 'package:Siuu/models/updatable_model.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:dcache/dcache.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:developer';

import 'language.dart';
import 'link_preview/link_preview.dart';

class Post extends UpdatableModel<Post> {
  final int id;
  final String uuid;
  final int creatorId;
  DateTime created;
  User creator;
  CirclesList circles;
  SharedPost sharepostData;

  ReactionsEmojiCountList reactionsEmojiCounts;
  PostReaction reaction;
  int reactionsCount;
  int commentsCount;
  double mediaHeight;
  double mediaWidth;
  String mediaThumbnail;
  bool areCommentsEnabled;
  bool publicReactions;
  String text;
  Language language;
  OBPostStatus status;

  PostMediaList media;
  PostCommentList commentsList;
  Memory crew;
  HashtagsList hashtagsList;
  PostLinksList postLinksList;
  Map<String, Hashtag> hashtagsMap;

  bool isMuted;
  bool isEncircled;
  bool isEdited;
  bool isClosed;
  bool isReported;
  PostText postText;
  // stored only in the app
  bool isExcludedFromTopPosts = false;
  bool isExcludedFromProfilePosts = false;
  bool isView = false;
  // Stored as cache
  LinkPreview linkPreview;

  static final factory = PostFactory();

  factory Post.fromJson(Map<String, dynamic> json) {
    log("get jsinnnn::$json");
    if (json == null) return null;
    return factory.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created': created?.toString(),
      'uuid': uuid,
      'creator_id': creatorId,
      'creator': creator?.toJson(),
      'circles':
          circles?.circles?.map((Circle circle) => circle.toJson())?.toList(),
      'reactions_emoji_counts': reactionsEmojiCounts?.counts
          ?.map((ReactionsEmojiCount reactionEmojiCount) =>
              reactionEmojiCount.toJson())
          ?.toList(),
      'reaction': reaction?.toJson(),
      'reactions_count': reactionsCount,
      'comments_count': commentsCount,
      'media_height': mediaHeight,
      'media_width': mediaWidth,
      'media_thumbnail': mediaThumbnail,
      'are_comments_enabled': areCommentsEnabled,
      'public_reactions': publicReactions,
      'text': text,
      'language': language?.toJson(),
      'status': status?.code,
      'media': media?.postMedia
          ?.map((PostMedia mediaObj) => mediaObj.toJson())
          ?.toList(),
      'comments': commentsList?.comments
          ?.map((PostComment comment) => comment.toJson())
          ?.toList(),
      'hashtags': hashtagsList?.hashtags
          ?.map((Hashtag hashtag) => hashtag.toJson())
          ?.toList(),
      'links': postLinksList?.postLinks
          ?.map((PostLink postLink) => postLink.toJson())
          ?.toList(),
      'crew': crew?.toJson(),
      'is_muted': isMuted,
      'is_encircled': isEncircled,
      'is_edited': isEdited,
      'is_closed': isClosed,
      'is_reported': isReported
    };
  }

  static void clearCache() {
    factory.clearCache();
  }

  Post(
      {this.id,
      this.uuid,
      this.created,
      this.text,
      this.creatorId,
      this.mediaThumbnail,
      this.media,
      this.creator,
      this.language,
      this.reactionsCount,
      this.commentsCount,
      this.mediaHeight,
      this.mediaWidth,
      this.commentsList,
      this.hashtagsList,
      this.postLinksList,
      this.reaction,
      this.reactionsEmojiCounts,
      this.areCommentsEnabled,
      this.circles,
      this.crew,
      this.status,
      this.publicReactions,
      this.isMuted,
      this.isEncircled,
      this.isClosed,
      this.isReported,
      this.postText,
      this.isEdited,
      this.sharepostData})
      : super() {
    this._updateHashtagsMap();
  }

  void updateFromJson(Map json) {
    if (json.containsKey('reactions_emoji_counts'))
      reactionsEmojiCounts =
          factory.parseReactionsEmojiCounts(json['reactions_emoji_counts']);
    if (json.containsKey('reaction'))
      reaction = factory.parseReaction(json['reaction']);

    if (json.containsKey('status')) status = OBPostStatus.parse(json['status']);

    if (json.containsKey('reactions_count'))
      reactionsCount = json['reactions_count'];

    if (json.containsKey('shared_post')) {
      print("checkkk val sharePost::${json['shared_post']}");
      sharepostData =
          factory.parseShareStoryData(json['shared_post'], "update");
    }
    if (json.containsKey('comments_enabled'))
      areCommentsEnabled = json['comments_enabled'];

    if (json.containsKey('public_reactions'))
      publicReactions = json['public_reactions'];

    if (json.containsKey('media_height'))
      mediaHeight = factory.parseMediaHeight(json['media_height']);

    if (json.containsKey('media_width'))
      mediaWidth = factory.parseMediaWidth(json['media_width']);

    if (json.containsKey('language')) {
      language = factory.parseLanguage(json['language']);
    }

    if (json.containsKey('text')) {
      text = json['text'];
    }

    if (json.containsKey('is_muted')) isMuted = json['is_muted'];

    if (json.containsKey('is_encircled')) isEncircled = json['is_encircled'];

    if (json.containsKey('is_edited')) isEdited = json['is_edited'];

    if (json.containsKey('is_closed')) isClosed = json['is_closed'];

    if (json.containsKey('is_reported')) isReported = json['is_reported'];

    if (json.containsKey('media_thumbnail'))
      mediaThumbnail = json['media_thumbnail'];

    if (json.containsKey('media')) media = factory.parseMedia(json['media']);

    if (json.containsKey('crew')) crew = factory.parseMemory(json['crew']);

    if (json.containsKey('creator'))
      creator = factory.parseUser(json['creator']);

    if (json.containsKey('created'))
      created = factory.parseCreated(json['created']);

    if (json.containsKey('comments'))
      commentsList = factory.parseCommentList(json['comments']);

    if (json.containsKey('hashtags')) {
      hashtagsList = factory.parseHashtagsList(json['hashtags']);
      _updateHashtagsMap();
    }

    if (json.containsKey('links')) {
      postLinksList = factory.parsePostLinksList(json['links']);
    }

    if (json.containsKey('circles'))
      circles = factory.parseCircles(json['circles']);
  }

  void updateIsExcludedFromTopPosts(bool isExcluded) {
    isExcludedFromTopPosts = isExcluded;
    notifyUpdate();
  }

  void updateIsExcludedFromProfilePosts(bool isExcluded) {
    isExcludedFromProfilePosts = isExcluded;
    notifyUpdate();
  }

  bool hasReaction() {
    return reaction != null;
  }

  bool hasMemory() {
    return crew != null;
  }

  bool isReactionEmoji(Emoji emoji) {
    return hasReaction() && reaction.getEmojiId() == emoji.id;
  }

  bool isReactionSVG(int id) {
    return hasReaction() && reaction.getEmojiId() == id;
  }

  bool hasPublicInteractions() {
    return publicReactions && areCommentsEnabled;
  }

  bool isMemoryPost() {
    return crew != null;
  }

  bool hasMediaThumbnail() {
    return mediaThumbnail != null;
  }

  bool hasMedia() {
    return media != null && media.postMedia.isNotEmpty;
  }

  PostLink getLinkToPreview() {
    if (postLinksList.postLinks.isNotEmpty) {
      var linkPreview = postLinksList.postLinks
          .firstWhere((link) => link.hasPreview, orElse: () => null);
      return linkPreview;
    }

    return null;
  }

  bool hasLinkToPreview() {
    return getLinkToPreview() != null;
  }

  bool hasText() {
    return text != null && text.length > 0;
  }

  bool hasLanguage() {
    return language != null;
  }

  bool hasComments() {
    return commentsList != null && commentsList.comments.length > 0;
  }

  bool hasCircles() {
    return circles != null && circles.circles.length > 0;
  }

  bool hasCommentsCount() {
    return commentsCount != null && commentsCount > 0;
  }

  bool isEncircledPost() {
    return isEncircled || false;
  }

  bool isOlderThan(Duration duration) {
    return created.isBefore(DateTime.now().subtract(duration));
  }

  List<PostComment> getPostComments() {
    return commentsList.comments;
  }

  List<Circle> getPostCircles() {
    return circles.circles;
  }

  List<ReactionsEmojiCount> getEmojiCounts() {
    return reactionsEmojiCounts.counts.toList();
  }

  String getCreatorUsername() {
    return creator.username;
  }

  int getCreatorId() {
    return creator.id;
  }

  String getCreatorAvatar() {
    return creator.profile.avatar;
  }

  List<PostMedia> getMedia() {
    return media.postMedia;
  }

  PostMedia getFirstMedia() {
    return media.postMedia.first;
  }

  PostText getPostText() {
    return postText;
  }

  Language getLanguage() {
    return language;
  }

  String getRelativeCreated() {
    return timeago.format(created);
  }

  void incrementCommentsCount() {
    this.commentsCount += 1;
    this.notifyUpdate();
  }

  void decreaseCommentsCount() {
    this.commentsCount -= 1;
    this.notifyUpdate();
  }

  void setMedia(PostMediaList media) {
    this.media = media;
    this.notifyUpdate();
  }

  void setPostText(PostText meta) {
    this.postText = meta;
    this.notifyUpdate();
  }

  void setLinkPreview(LinkPreview linkPreview) {
    this.linkPreview = linkPreview;
    this.notifyUpdate();
  }

  void clearReaction() {
    this.setReaction(null);
  }

  void setReaction(PostReaction newReaction) {
    bool hasReaction = this.hasReaction();

    if (!hasReaction && newReaction == null) {
      throw 'Trying to remove no reaction';
    }

    var newEmojiCounts = reactionsEmojiCounts.counts.toList();

    if (hasReaction) {
      var currentReactionEmojiCount = newEmojiCounts.firstWhere((emojiCount) {
        return emojiCount.getEmojiId() == reaction.getEmojiId();
      });

      if (currentReactionEmojiCount.count > 1) {
        // Decrement emoji reaction counts
        currentReactionEmojiCount.count -= 1;
      } else {
        // Remove emoji reaction count
        newEmojiCounts.remove(currentReactionEmojiCount);
      }
    }

    if (newReaction != null) {
      var reactionEmojiCount = newEmojiCounts.firstWhere((emojiCount) {
        return emojiCount.getEmojiId() == newReaction.getEmojiId();
      }, orElse: () {});

      if (reactionEmojiCount != null) {
        // Up existing count
        reactionEmojiCount.count += 1;
      } else {
        // Add new emoji count
        newEmojiCounts
            .add(ReactionsEmojiCount(emoji: newReaction.emoji, count: 1));
      }
    }

    this.reaction = newReaction;
    this._setReactionsEmojiCounts(
        ReactionsEmojiCountList(counts: newEmojiCounts));

    this.notifyUpdate();
  }

  void setIsReported(isReported) {
    this.isReported = isReported;
    notifyUpdate();
  }

  void setStatus(OBPostStatus status) {
    this.status = status;
    this.notifyUpdate();
  }

  void _setReactionsEmojiCounts(ReactionsEmojiCountList emojiCounts) {
    reactionsEmojiCounts = emojiCounts;
  }

  void _updateHashtagsMap() {
    if (hashtagsList == null) {
      this.hashtagsMap = null;
      return;
    }

    Map<String, Hashtag> updatedMap = Map();
    hashtagsList.hashtags
        .forEach((hashtag) => updatedMap[hashtag.name] = hashtag);
    hashtagsMap = updatedMap;
  }
}

class PostFactory extends UpdatableModelFactory<Post> {
  @override
  SimpleCache<int, Post> cache =
      SimpleCache(storage: UpdatableModelSimpleStorage(size: 100));

  @override
  Post makeFromJson(Map json) {
    // print("get share data11::$json");
    // log("get share data:11:${json}");

    return Post(
        id: json['id'],
        uuid: json['uuid'],
        creatorId: json['creator_id'],
        created: parseCreated(json['created']),
        status: OBPostStatus.parse(json['status']),
        text: json['text'],
        language: parseLanguage(json['language']),
        circles: parseCircles(json['circles']),
        reactionsCount: json['reactions_count'],
        commentsCount: json['comments_count'],
        mediaHeight: parseMediaHeight(json['media_height']),
        mediaWidth: parseMediaWidth(json['media_width']),
        isMuted: json['is_muted'],
        isReported: json['is_reported'],
        areCommentsEnabled: json['comments_enabled'],
        publicReactions: json['public_reactions'],
        creator: parseCreator(json['creator']),
        mediaThumbnail: json['media_thumbnail'],
        media: parseMedia(json['media']),
        reaction: parseReaction(json['reaction']),
        crew: parseMemory(json['crew']),
        commentsList: parseCommentList(json['comments']),
        hashtagsList: parseHashtagsList(json['hashtags']),
        postLinksList: parsePostLinksList(json['links']),
        isEncircled: json['is_encircled'],
        isEdited: json['is_edited'],
        isClosed: json['is_closed'],
        sharepostData: parseShareStoryData(json['shared_post'], "main"),
        postText: parsePostText(json['meta']),
        reactionsEmojiCounts:
            parseReactionsEmojiCounts(json['reactions_emoji_counts']));
  }

  User parseUser(Map userData) {
    if (userData == null) return null;
    return User.fromJson(userData);
  }

  PostText parsePostText(Map meta) {
    if (meta == null) return null;
    return PostText.fromJSON(meta);
  }

  DateTime parseCreated(String created) {
    if (created == null) return null;
    return DateTime.parse(created).toLocal();
  }

  PostMediaList parseMedia(List mediaRawData) {
    if (mediaRawData == null) return null;
    return PostMediaList.fromJson(mediaRawData);
  }

  User parseCreator(Map creator) {
    if (creator == null) return null;
    return User.fromJson(creator);
  }

  SharedPost parseShareStoryData(sharePostData, String from1) {
    print("share post data2:: ${sharePostData}" + "::from::$from1");
    if (sharePostData == null) return null;
    return SharedPost(
      postDetails: PostDetails.fromMap(sharePostData[0]),
      sharedUserDetails: SharedUserDetails.fromMap(sharePostData[1]),
    );
    //return SharedPost.fromMap(sharePostData);
    // return new List<ShareStoryData> = {share_story_data = json['shared_post']}
  }

  PostReaction parseReaction(Map postReaction) {
    if (postReaction == null) return null;
    return PostReaction.fromJson(postReaction);
  }

  Memory parseMemory(Map crewData) {
    if (crewData == null) return null;
    return Memory.fromJSON(crewData);
  }

  ReactionsEmojiCountList parseReactionsEmojiCounts(List reactionsEmojiCounts) {
    if (reactionsEmojiCounts == null) return null;
    return ReactionsEmojiCountList.fromJson(reactionsEmojiCounts);
  }

  PostCommentList parseCommentList(List commentList) {
    if (commentList == null) return null;
    return PostCommentList.fromJson(commentList);
  }

  HashtagsList parseHashtagsList(List hashtagsList) {
    if (hashtagsList == null) return null;
    return HashtagsList.fromJson(hashtagsList);
  }

  PostLinksList parsePostLinksList(List postLinksList) {
    if (postLinksList == null) return null;
    return PostLinksList.fromJson(postLinksList);
  }

  CirclesList parseCircles(List circlesData) {
    if (circlesData == null) return null;
    return CirclesList.fromJson(circlesData);
  }

  Language parseLanguage(Map languageData) {
    if (languageData == null) return null;
    return Language.fromJson(languageData);
  }

  double parseMediaWidth(dynamic mediaWidth) {
    if (mediaWidth == null) return null;
    if (mediaWidth is int) return mediaWidth.toDouble();
    if (mediaWidth is double) return mediaWidth;
  }

  double parseMediaHeight(dynamic mediaHeight) {
    if (mediaHeight == null) return null;
    if (mediaHeight is int) return mediaHeight.toDouble();
    if (mediaHeight is double) return mediaHeight;
  }
}

class OBPostStatus {
  final String code;

  const OBPostStatus._internal(this.code);

  toString() => code;

  static const draft = const OBPostStatus._internal('D');
  static const processing = const OBPostStatus._internal('PG');
  static const published = const OBPostStatus._internal('P');

  static const _values = const <OBPostStatus>[draft, processing, published];

  static values() => _values;

  static OBPostStatus parse(String string) {
    if (string == null) return null;

    OBPostStatus postStatus;
    for (var type in _values) {
      if (string == type.code) {
        postStatus = type;
        break;
      }
    }

    if (postStatus == null) {
      // Don't throw as we might introduce new notifications on the API which might not be yet in code
      print('Unsupported post status type: ' + string);
    }

    return postStatus;
  }
}
