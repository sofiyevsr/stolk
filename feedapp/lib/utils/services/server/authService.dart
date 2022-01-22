import 'dart:io';

import 'package:stolk/utils/@types/request/index.dart';
import 'package:stolk/utils/@types/response/index.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/server/apiService.dart';

class AuthService extends ApiService {
  AuthService() : super();
  final _sessionType = Platform.isIOS ? AppPlatform.IOS : AppPlatform.ANDROID;

  Future<void> forgotPassword(String email) async {
    await this.request.post("/auth/forgot-password", {"email": email}, {});
  }

  Future<LoginResponse> login(LoginRequest data) async {
    final response = await this.request.post("/auth/login", data.toMap(), {});
    return LoginResponse.fromJSON(response.data['body']);
  }

  Future<LoginResponse> googleLogin(String idToken) async {
    final response = await this.request.post("/auth/login/google", {
      "token": idToken,
      "session_type": _sessionType,
    }, {});
    return LoginResponse.fromJSON(response.data['body']);
  }

  Future<LoginResponse> facebookLogin(String token) async {
    final response = await this.request.post("/auth/login/facebook", {
      "token": token,
      "session_type": _sessionType,
    }, {});
    return LoginResponse.fromJSON(response.data['body']);
  }

  Future<RegisterResponse> register(RegisterRequest data) async {
    final response =
        await this.request.post("/auth/register", data.toMap(), {});
    return RegisterResponse.fromJSON(response.data['body']);
  }

  Future<CheckTokenResponse> checkToken(CheckTokenRequest data) async {
    final response = await this.request.post(
          "/auth/check-token",
          {},
          {"authorization": 'Bearer ${data.token}'},
          handleError: false,
        );
    return CheckTokenResponse.fromJSON(response.data['body']);
  }

  Future<void> logout() async {
    await this.request.post("/auth/logout", {}, {});
  }

  Future<void> resendConfirmationEmail() async {
    await this.request.post("/auth/email-verification", {}, {});
  }

  Future<CompleteProfileResponse> completeProfile() async {
    final response = await this.request.post("/auth/complete-profile", {}, {});
    return CompleteProfileResponse.fromJSON(response.data['body']);
  }
}
