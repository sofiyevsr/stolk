part of "AuthBloc.dart";

abstract class AuthEvent extends Equatable {
  get props => [];
}

class CheckTokenEvent extends AuthEvent {
  final String token;
  CheckTokenEvent({required this.token});
  @override
  get props => [token];
}

class CompleteProfileEvent extends AuthEvent {
  final String completedAt;
  CompleteProfileEvent({required this.completedAt});
  @override
  get props => [completedAt];
}

class GoogleLogin extends AuthEvent {
  final String idToken;
  GoogleLogin({required this.idToken});
  @override
  get props => [idToken];
}

class FacebookLogin extends AuthEvent {
  final String token;
  FacebookLogin({required this.token});
  @override
  get props => [token];
}

class AppLogin extends AuthEvent {
  final String email, password;
  AppLogin({required this.email, required this.password});
  @override
  get props => [email, password];
}

class AppRegister extends AuthEvent {
  final String email, password, firstName, lastName;
  AppRegister(
      {required this.email,
      required this.password,
      required this.firstName,
      required this.lastName});
  @override
  get props => [email, password, firstName, lastName];
}

class StartupLogout extends AuthEvent {}

class ApiForceLogout extends AuthEvent {}

class AppLogout extends AuthEvent {}
