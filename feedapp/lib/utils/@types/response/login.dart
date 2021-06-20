import 'package:feedapp/logic/blocs/authBloc/models/user.dart';

class LoginResponse {
  final String token;
  final User user;

  LoginResponse.fromJSON(Map<String, dynamic> res)
      : this.token = res['access_token'],
        this.user = User.fromJSON(res['user']);
}
