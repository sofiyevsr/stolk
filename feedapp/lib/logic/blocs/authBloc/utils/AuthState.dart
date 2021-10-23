part of "AuthBloc.dart";

abstract class AuthState extends Equatable {
  @override
  get props => [];
}

class AuthorizedState extends AuthState {
  final String token;
  final User user;
  final bool isLoggingOut;
  AuthorizedState({
    required this.user,
    required this.token,
    this.isLoggingOut = false,
  });
  AuthorizedState changeStatus(bool status) => AuthorizedState(
        user: this.user,
        token: this.token,
        isLoggingOut: status,
      );
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
