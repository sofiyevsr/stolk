import 'package:stolk/logic/blocs/authBloc/models/user.dart';

class CheckTokenResponse {
  final User user;
  CheckTokenResponse._({required this.user});
  CheckTokenResponse.fromJSON(Map<String, dynamic> json)
      : this._(user: User.fromJSON(json['user']));
}
