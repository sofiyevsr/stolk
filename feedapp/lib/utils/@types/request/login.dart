import 'package:feedapp/utils/constants.dart';
import "dart:io" show Platform;

class LoginRequest {
  final String _email;
  final String _password;
  final int _accountType = AccountType.USER;
  final int _sessionType =
      Platform.isIOS ? AppPlatform.IOS : AppPlatform.ANDROID;
  final int _serviceType = ServiceType.APP;

  LoginRequest({email, password, accountType})
      : this._email = email,
        this._password = password;

  Map<String, Object> toMap() {
    return {
      "email": _email,
      "account_type": _accountType,
      "session_type": _sessionType,
      "password": _password,
      "service_type": _serviceType
    };
  }
}
