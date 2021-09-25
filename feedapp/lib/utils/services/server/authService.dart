import 'package:stolk/utils/@types/request/checkToken.dart';
import 'package:stolk/utils/@types/request/login.dart';
import 'package:stolk/utils/@types/request/register.dart';
import 'package:stolk/utils/@types/response/checkToken.dart';
import 'package:stolk/utils/@types/response/login.dart';
import 'package:stolk/utils/@types/response/register.dart';
import 'package:stolk/utils/services/server/apiService.dart';

class AuthService extends ApiService {
  AuthService() : super(enableErrorHandler: true);

  Future<void> forgotPassword(String email) async {
    await this.request.post("/auth/forgot-password", {"email": email}, {});
  }

  Future<LoginResponse> login(LoginRequest data) async {
    final response = await this.request.post("/auth/login", data.toMap(), {});
    return LoginResponse.fromJSON(response.data['body']);
  }

  Future<LoginResponse> googleLogin(String idToken) async {
    final response =
        await this.request.post("/auth/login/google", {"token": idToken}, {});
    return LoginResponse.fromJSON(response.data['body']);
  }

  Future<RegisterResponse> register(RegisterRequest data) async {
    final response =
        await this.request.post("/auth/register", data.toMap(), {});
    return RegisterResponse.fromJSON(response.data['body']);
  }

  Future<CheckTokenResponse> checkToken(CheckTokenRequest data) async {
    final response = await this.request.post(
        "/auth/check-token", {}, {"authorization": 'Bearer ${data.token}'});
    return CheckTokenResponse.fromJSON(response.data['body']);
  }

  Future<void> logout() async {
    await this.request.post("/auth/logout", {}, {});
  }
}
