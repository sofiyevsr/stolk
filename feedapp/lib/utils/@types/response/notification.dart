import 'package:equatable/equatable.dart';

class SingleLocalNotification extends Equatable {
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
  @override
  List get props => [id, name, createdAt];
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
  List<dynamic> get props => [
        preferences,
      ];
}

class SingleFCMNotification extends Equatable {
  final String name;
  SingleFCMNotification._({required this.name});
  SingleFCMNotification.fromJSON(Map<String, dynamic> json)
      : this._(
          name: json["name"],
        );
  @override
  List get props => [
        name,
      ];
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
  List<dynamic> get props => [
        topics,
      ];
}
