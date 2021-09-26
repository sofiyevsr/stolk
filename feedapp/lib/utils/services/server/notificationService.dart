import 'package:stolk/utils/@types/response/notification.dart';
import 'package:stolk/utils/services/server/apiService.dart';

class NotificationService extends ApiService {
  NotificationService() : super(enableErrorHandler: false);

// FCM notification topics
  Future<AllLocalNotificationResponse> getMyNotificationPreferences() async {
    final response =
        await this.request.get("/notification/my-preferences", {}, {});
    return AllLocalNotificationResponse.fromJSON(response.data["body"]);
  }

  // Notification Preferences that are store on backend
  Future<AllFCMNotificationResponse> getFCMPreferences(String token) async {
    final response = await this
        .request
        .get("/notification/fcm-topics", {"token": token}, {});
    return AllFCMNotificationResponse.fromJSON(response.data["body"]);
  }

  Future<void> optin(int notificationOptoutType) async {
    await this.request.post("/notification/optin",
        {"notification_type_id": notificationOptoutType}, {});
  }

  Future<void> optout(int notificationOptoutType) async {
    await this.request.post("/notification/optout",
        {"notification_type_id": notificationOptoutType}, {});
  }

  Future<void> saveToken(String token, String authToken) async {
    await this.request.post(
      "/notification/save-token",
      {"token": token},
      {"authorization": 'Bearer $authToken'},
    );
  }
}
