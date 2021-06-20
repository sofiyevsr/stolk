import 'package:feedapp/utils/constants.dart';
import "dart:io" show Platform;

class RegisterRequest {
  final String _firstName;
  final String _lastName;
  final String _email;
  final String _password;
  final int _accountType = AccountType.USER;
  final int _sessionType =
      Platform.isIOS ? AppPlatform.IOS : AppPlatform.ANDROID;
  final int _serviceType = ServiceType.APP;

  RegisterRequest({firstName, lastName, email, password, accountType})
      : this._email = email,
        this._lastName = lastName,
        this._firstName = firstName,
        this._password = password;

  Map<String, Object> toMap() {
    return {
      "email": _email,
      "account_type": _accountType,
      "first_name": _firstName,
      "last_name": _lastName,
      "session_type": _sessionType,
      "password": _password,
      "service_type": _serviceType
    };
  }
}
