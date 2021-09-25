import 'package:Siuu/models/UserStory.dart';

class SharedVariables {
  static UserStory userStory;

  static bool controlIsAllStoriesViewedFromUserId(String userId) {
    return _controlIsAllStoriesViewed(_getsameuserstory(userId));
  }

  static bool _controlIsAllStoriesViewed(List<Story> stories) {
    if (stories == null || (stories.length ?? 0) == 0) return null;
    var viewed = true;
    for (Story story in stories) {
      if (story.is_viewed == false) {
        viewed = false;
        break;
      }
    }
    return viewed;
  }

  static List<Story> _getsameuserstory(String userId) {
    List<Story> userSameStory = [];
    for (int i = 0; i < userStory.stories.length; i++) {
      if (userId == userStory.stories[i].userId) {
        userSameStory.add(userStory.stories[i]);
      }
    }
    for (int i = 0; i < userStory.myStories.length; i++) {
      if (userId == userStory.myStories[i].userId) {
        userSameStory.add(userStory.myStories[i]);
      }
    }
    for (int i = 0; i < userStory.onMapStories.length; i++) {
      if (userId == userStory.onMapStories[i].userId) {
        userSameStory.add(userStory.onMapStories[i]);
      }
    }

    return userSameStory;
  }
}
