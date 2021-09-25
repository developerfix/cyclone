import 'dart:io';

import 'package:Siuu/custom/InstantShareDialog.dart';
import 'package:Siuu/models/circle.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/follows_list.dart';
import 'package:Siuu/models/moderation/moderated_object.dart';
import 'package:Siuu/models/moderation/moderation_category.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/post_comment.dart';
import 'package:Siuu/models/post_reaction.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/models/user_invite.dart';
import 'package:Siuu/pages/home/modals/accept_guidelines/accept_guidelines.dart';
import 'package:Siuu/pages/home/modals/invite_to_community.dart';
import 'package:Siuu/pages/home/modals/post_comment/post_comment_reply_expanded.dart';
import 'package:Siuu/pages/home/modals/post_comment/post_commenter_expanded.dart';
import 'package:Siuu/pages/home/modals/save_post/create_post.dart';
import 'package:Siuu/pages/home/pages/community/pages/manage_community/pages/community_administrators/modals/add_community_administrator/add_community_administrator.dart';
import 'package:Siuu/pages/home/modals/save_community.dart';
import 'package:Siuu/pages/home/modals/save_connections_circle.dart';
import 'package:Siuu/pages/home/modals/save_follows_list/save_follows_list.dart';
import 'package:Siuu/pages/home/modals/timeline_filters.dart';
import 'package:Siuu/pages/home/pages/community/pages/manage_community/pages/community_banned_users/modals/ban_community_user/ban_community_user.dart';
import 'package:Siuu/pages/home/pages/community/pages/manage_community/pages/community_moderators/modals/add_community_moderator/add_community_moderator.dart';
import 'package:Siuu/pages/home/modals/user_invites/create_user_invite.dart';
import 'package:Siuu/pages/home/modals/user_invites/send_invite_email.dart';
import 'package:Siuu/pages/home/pages/moderated_objects/modals/moderated_objects_filters/moderated_objects_filters.dart';
import 'package:Siuu/pages/home/pages/moderated_objects/moderated_objects.dart';
import 'package:Siuu/pages/home/pages/moderated_objects/pages/widgets/moderated_object_category/modals/moderated_object_update_category.dart';
import 'package:Siuu/pages/home/pages/moderated_objects/pages/widgets/moderated_object_description/modals/moderated_object_update_description.dart';
import 'package:Siuu/pages/home/pages/moderated_objects/pages/widgets/moderated_object_status/modals/moderated_object_update_status.dart';
import 'package:Siuu/pages/home/pages/profile/pages/edit_profile/modals/edit_profile.dart';
import 'package:Siuu/pages/home/pages/profile/pages/edit_profile/pages/profile_posts_excluded_communities/modals/exclude_community_from_profile_posts.dart';
import 'package:Siuu/pages/home/pages/search/search.dart';
import 'package:Siuu/pages/home/pages/timeline/timeline.dart';
import 'package:Siuu/widgets/new_post_data_uploader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'localization.dart';

class ModalService {
  LocalizationService localizationService;

  void setLocalizationService(localizationService) {
    this.localizationService = localizationService;
  }

  Future<OBNewPostData> openCreatePost(
      {@required BuildContext context,
      Memory crew,
      String text,
      File image,
      File video}) async {
    OBNewPostData createPostData =
        await Navigator.of(context, rootNavigator: true)
            .push(CupertinoPageRoute<OBNewPostData>(
                fullscreenDialog: true,
                builder: (BuildContext context) {
                  return Material(
                    child: OBSavePostModal(
                      memory: crew,
                      text: text,
                      image: image,
                      video: video,
                    ),
                  );
                }));

    return createPostData;
  }

  Future<Post> openEditPost(
      {@required BuildContext context, @required Post post}) async {
    Post editedPost = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute<Post>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Material(
                child: OBSavePostModal(
                  post: post,
                ),
              );
            }));

    return editedPost;
  }

  Future<Post> openSharePost(
      {@required BuildContext context, @required Post post}) async {
    Post editedPost = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute<Post>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Material(
                child: SharePostModal(
                  post: post,
                ),
              );
            }));
    return editedPost;
  }

  Future<PostComment> openExpandedCommenter(
      {@required BuildContext context,
      @required PostComment postComment,
      @required Post post}) async {
    PostComment editedComment = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute<PostComment>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Material(
                child: OBPostCommenterExpandedModal(
                  post: post,
                  postComment: postComment,
                ),
              );
            }));
    return editedComment;
  }

  Future<PostComment> openExpandedReplyCommenter(
      {@required BuildContext context,
      @required PostComment postComment,
      @required Post post,
      @required Function(PostComment) onReplyAdded,
      @required Function(PostComment) onReplyDeleted}) async {
    PostComment replyComment = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute<PostComment>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Material(
                child: OBPostCommentReplyExpandedModal(
                    post: post,
                    postComment: postComment,
                    onReplyAdded: onReplyAdded,
                    onReplyDeleted: onReplyDeleted),
              );
            }));
    return replyComment;
  }

  Future<void> openEditProfile(
      {@required User user,
      @required BuildContext context,
      VoidCallback onUserProfileUpdated}) async {
    Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute<PostReaction>(
            fullscreenDialog: true,
            builder: (BuildContext context) => Material(
                  child: OBEditProfileModal(user,
                      onUserProfileUpdated: onUserProfileUpdated),
                )));
  }

  Future<FollowsList> openCreateFollowsList(
      {@required BuildContext context}) async {
    FollowsList createdFollowsList =
        await Navigator.of(context, rootNavigator: true)
            .push(CupertinoPageRoute<FollowsList>(
                fullscreenDialog: true,
                builder: (BuildContext context) {
                  return OBSaveFollowsListModal(
                    autofocusNameTextField: true,
                  );
                }));

    return createdFollowsList;
  }

  Future<FollowsList> openEditFollowsList(
      {@required FollowsList followsList,
      @required BuildContext context}) async {
    FollowsList editedFollowsList =
        await Navigator.of(context).push(CupertinoPageRoute<FollowsList>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return OBSaveFollowsListModal(
                followsList: followsList,
              );
            }));

    return editedFollowsList;
  }

  Future<Circle> openCreateConnectionsCircle(
      {@required BuildContext context}) async {
    Circle createdConnectionsCircle =
        await Navigator.of(context).push(CupertinoPageRoute<Circle>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return OBSaveConnectionsCircleModal(
                autofocusNameTextField: true,
              );
            }));

    return createdConnectionsCircle;
  }

  Future<Circle> openEditConnectionsCircle(
      {@required Circle connectionsCircle,
      @required BuildContext context}) async {
    Circle editedConnectionsCircle =
        await Navigator.of(context, rootNavigator: true)
            .push(CupertinoPageRoute<Circle>(
                fullscreenDialog: true,
                builder: (BuildContext context) {
                  return Material(
                    child: OBSaveConnectionsCircleModal(
                      connectionsCircle: connectionsCircle,
                    ),
                  );
                }));

    return editedConnectionsCircle;
  }

  Future<Memory> openEditMemory(
      {@required BuildContext context, @required Memory crew}) async {
    Memory editedMemory = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute<Memory>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Material(
                child: OBSaveMemoryModal(
                  crew: crew,
                ),
              );
            }));

    return editedMemory;
  }

  Future<void> openInviteToMemory(
      {@required BuildContext context, @required Memory crew}) async {
    return Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute<Memory>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Material(
                child: OBInviteToMemoryModal(
                  crew: crew,
                ),
              );
            }));
  }

  Future<Memory> openCreateMemory({@required BuildContext context}) async {
    Memory createdMemory = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute<Memory>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Material(
                child: OBSaveMemoryModal(),
              );
            }));

    return createdMemory;
  }

  Future<User> openAddMemoryAdministrator(
      {@required BuildContext context, @required Memory crew}) async {
    User addedMemoryAdministrator =
        await Navigator.of(context, rootNavigator: true)
            .push(CupertinoPageRoute<User>(
                fullscreenDialog: true,
                builder: (BuildContext context) {
                  return Material(
                    child: OBAddMemoryAdministratorModal(
                      crew: crew,
                    ),
                  );
                }));

    return addedMemoryAdministrator;
  }

  Future<User> openAddMemoryModerator(
      {@required BuildContext context, @required Memory crew}) async {
    User addedMemoryModerator = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute<User>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Material(
                child: OBAddMemoryModeratorModal(
                  crew: crew,
                ),
              );
            }));

    return addedMemoryModerator;
  }

  Future<User> openBanMemoryUser(
      {@required BuildContext context, @required Memory crew}) async {
    User addedMemoryBannedUser =
        await Navigator.of(context, rootNavigator: true)
            .push(CupertinoPageRoute<User>(
                fullscreenDialog: true,
                builder: (BuildContext context) {
                  return Material(
                    child: OBBanMemoryUserModal(
                      crew: crew,
                    ),
                  );
                }));

    return addedMemoryBannedUser;
  }

  Future<void> openTimelineFilters(
      {@required OBTimelinePageController timelineController,
      @required BuildContext context}) {
    return Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute<Circle>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Material(
                child: OBTimelineFiltersModal(
                  timelinePageController: timelineController,
                ),
              );
            }));
  }

  Future<void> openTimelineSearch(
      {@required OBMainSearchPageController searchPageController,
      @required BuildContext context}) {
    return Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute<Circle>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Material(
                child: OBMainSearchPage(
                  controller: searchPageController,
                ),
              );
            }));
  }

  Future<UserInvite> openCreateUserInvite(
      {@required BuildContext context}) async {
    UserInvite createdUserInvite =
        await Navigator.of(context).push(CupertinoPageRoute<UserInvite>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return OBCreateUserInviteModal(
                autofocusNameTextField: true,
              );
            }));

    return createdUserInvite;
  }

  Future<UserInvite> openEditUserInvite(
      {@required BuildContext context, @required UserInvite userInvite}) async {
    UserInvite editedUserInvite =
        await Navigator.of(context).push(CupertinoPageRoute<UserInvite>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return OBCreateUserInviteModal(
                autofocusNameTextField: true,
                userInvite: userInvite,
              );
            }));

    return editedUserInvite;
  }

  Future<void> openSendUserInviteEmail(
      {@required BuildContext context, @required UserInvite userInvite}) async {
    await Navigator.of(context).push(CupertinoPageRoute<UserInvite>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return OBSendUserInviteEmailModal(
            autofocusEmailTextField: true,
            userInvite: userInvite,
          );
        }));
  }

  Future<void> openModeratedObjectsFilters(
      {@required
          BuildContext context,
      @required
          OBModeratedObjectsPageController
              moderatedObjectsPageController}) async {
    await Navigator.of(context).push(CupertinoPageRoute<UserInvite>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return OBModeratedObjectsFiltersModal(
            moderatedObjectsPageController: moderatedObjectsPageController,
          );
        }));
  }

  Future<void> openAcceptGuidelines({@required BuildContext context}) async {
    await Navigator.of(context).push(CupertinoPageRoute<UserInvite>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return Material(
            child: OBAcceptGuidelinesModal(),
          );
        }));
  }

  Future<String> openModeratedObjectUpdateDescription(
      {@required BuildContext context,
      @required ModeratedObject moderatedObject}) async {
    return Navigator.of(context).push(CupertinoPageRoute<String>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return OBModeratedObjectUpdateDescriptionModal(
            moderatedObject: moderatedObject,
          );
        }));
  }

  Future<ModerationCategory> openModeratedObjectUpdateCategory(
      {@required BuildContext context,
      @required ModeratedObject moderatedObject}) async {
    return Navigator.of(context).push(CupertinoPageRoute<ModerationCategory>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return OBModeratedObjectUpdateCategoryModal(
            moderatedObject: moderatedObject,
          );
        }));
  }

  Future<ModeratedObjectStatus> openModeratedObjectUpdateStatus(
      {@required BuildContext context,
      @required ModeratedObject moderatedObject}) async {
    return Navigator.of(context).push(CupertinoPageRoute<ModeratedObjectStatus>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return OBModeratedObjectUpdateStatusModal(
            moderatedObject: moderatedObject,
          );
        }));
  }

  Future<List<Memory>> openExcludeCommunitiesFromProfilePosts(
      {@required BuildContext context}) async {
    return Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute<List<Memory>>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Material(
                child: OBExcludeCommunitiesFromProfilePostsModal(),
              );
            }));
  }
}
