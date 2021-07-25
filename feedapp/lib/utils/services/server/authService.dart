import 'package:feedapp/utils/@types/request/checkToken.dart';
import 'package:feedapp/utils/@types/request/login.dart';
import 'package:feedapp/utils/@types/request/register.dart';
import 'package:feedapp/utils/@types/response/checkToken.dart';
import 'package:feedapp/utils/@types/response/login.dart';
import 'package:feedapp/utils/@types/response/register.dart';
import 'package:feedapp/utils/services/server/apiService.dart';

class AuthService extends ApiService {
  AuthService() : super(enableErrorHandler: true);

  Future<LoginResponse> login(LoginRequest data) async {
    final response = await this.request.post("/auth/login", data.toMap(), {});
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

  Future<void> saveToken(String token, String? authToken) async {
    await this.request.post(
      "/notification/save-token",
      {"token": token},
      {"authorization": 'Bearer $authToken'},
    );
  }

  Future<void> logout() async {
    await this.request.post("/auth/logout", {}, {});
  }
}
