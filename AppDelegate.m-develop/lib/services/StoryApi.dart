
class StoryApi{
  static const STORY_PATH = 'api/story/create_story/';
  String apiURL;


  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }
  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }

}
