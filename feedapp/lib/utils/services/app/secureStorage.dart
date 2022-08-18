import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _iOptions = const IOSOptions();
  static const _storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    String? token = await _storage.read(key: "token");
    return token;
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: "token", value: token, iOptions: _iOptions);
  }

  Future<void> removeToken() async {
    await _storage.delete(key: "token");
  }
}
