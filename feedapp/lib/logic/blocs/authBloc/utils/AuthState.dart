part of "AuthBloc.dart";

abstract class AuthState extends Equatable {
  @override
  get props => [];
}

class AuthorizedState extends AuthState {
  final String token;
  final User user;
  AuthorizedState({
    required this.user,
    required this.token,
  });

  @override
  get props => [user, token];
}

class UnathorizedState extends AuthState {}

class UnknownAuthState extends AuthState {}

class CheckTokenFailed extends AuthState {}

class AuthLoadingState extends AuthState {}

class FailedAuthState extends AuthState {
  final String? error;
  FailedAuthState({this.error});
  @override
  get props => [error];
}
