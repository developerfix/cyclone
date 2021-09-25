import 'package:Siuu/models/user.dart';

class MomentViewers {
  final List<MomentViewer> viewers;

  MomentViewers({
    this.viewers,
  });

  factory MomentViewers.fromJson(List<dynamic> parsedJson) {
    List<MomentViewer> momentViewers = parsedJson
        .map((momentJson) => MomentViewer.fromJson(momentJson))
        .toList();

    return MomentViewers(
      viewers: momentViewers,
    );
  }
}

class MomentViewer {
  User user;
  DateTime viewTime;

  MomentViewer({
    this.user,
    this.viewTime,
  });

  factory MomentViewer.fromJson(Map<String, dynamic> parsedJson) {
    User user = User.fromJson(parsedJson);

    return MomentViewer(
      user: user,
      viewTime: DateTime.parse(parsedJson["view_time"]),
    );
  }
}
