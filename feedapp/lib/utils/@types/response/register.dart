import 'package:stolk/logic/blocs/authBloc/models/user.dart';

class RegisterResponse {
  final String token;
  final User user;

  RegisterResponse.fromJSON(Map<String, dynamic> res)
      : this.token = res['access_token'],
        this.user = User.fromJSON(res['user']);
}
