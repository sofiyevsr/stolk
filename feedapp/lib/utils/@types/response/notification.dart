import 'package:equatable/equatable.dart';

class SingleLocalNotification {
  final int id;
  final String name;
  final String? createdAt;
  SingleLocalNotification._(
      {required this.id, required this.name, required this.createdAt});
  SingleLocalNotification.fromJSON(Map<String, dynamic> json)
      : this._(
          id: json["id"],
          name: json["name"],
          createdAt: json['created_at'],
        );
}

class AllLocalNotificationResponse {
  final List<SingleLocalNotification> preferences = [];
  AllLocalNotificationResponse.fromJSON(Map<String, dynamic> json) {
    if (json['preferences'] == null) {
      return;
    }
    for (int i = 0; i < json['preferences'].length; i++) {
      preferences.add(SingleLocalNotification.fromJSON(json['preferences'][i]));
    }
  }
}

class SingleFCMNotification {
  final String name;
  SingleFCMNotification._({required this.name});
  SingleFCMNotification.fromJSON(Map<String, dynamic> json)
      : this._(
          name: json["name"],
        );
}

class AllFCMNotificationResponse {
  final List<SingleFCMNotification> topics = [];
  AllFCMNotificationResponse.fromJSON(Map<String, dynamic> json) {
    if (json['topics'] == null) {
      return;
    }
    for (int i = 0; i < json['topics'].length; i++) {
      topics.add(SingleFCMNotification.fromJSON(json['topics'][i]));
    }
  }
}
