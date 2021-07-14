import 'package:dio/dio.dart';
import 'package:feedapp/logic/blocs/authBloc/models/user.dart';
import 'package:feedapp/utils/@types/request/checkToken.dart';
import 'package:feedapp/utils/@types/request/login.dart';
import 'package:feedapp/utils/@types/request/register.dart';
import 'package:feedapp/utils/services/app/startupService.dart';
import 'package:feedapp/utils/services/server/authService.dart';
import 'package:feedapp/utils/services/app/secureStorage.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:equatable/equatable.dart';

part 'AuthState.dart';
part 'AuthEvents.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc._() : super(UnknownAuthState());
  static final instance = AuthBloc._();
  static final _auth = AuthService();

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    if (transition.nextState is AuthorizedState &&
        transition.currentState is AuthLoadingState) {
      // Sync auth token
      final token = (transition.nextState as AuthorizedState).token;
      StartupService.instance.storeDeviceToken(token);
    }
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppLogin) {
      final data = LoginRequest(email: event.email, password: event.password);
      try {
        yield AuthLoadingState();
        final response = await _auth.login(data);
        final storage = SecureStorage();
        await storage.setToken(response.token);
        yield AuthorizedState(
          user: User(
            firstName: response.user.firstName,
            lastName: response.user.lastName,
            email: response.user.email,
            createdAt: response.user.createdAt,
            serviceTypeId: response.user.serviceTypeId,
          ),
          token: response.token,
        );
      } catch (e) {
        yield FailedAuthState(error: e.toString());
      }
    }
    if (event is AppRegister) {
      final data = RegisterRequest(
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
          password: event.password);
      try {
        yield AuthLoadingState();
        final response = await _auth.register(data);
        final storage = SecureStorage();
        await storage.setToken(response.token);
        yield AuthorizedState(
          user: User(
            firstName: response.user.firstName,
            lastName: response.user.lastName,
            email: response.user.email,
            createdAt: response.user.createdAt,
            serviceTypeId: response.user.serviceTypeId,
          ),
          token: response.token,
        );
      } catch (e) {
        yield FailedAuthState(error: e.toString());
      }
    }
    if (event is CheckTokenEvent) {
      final data = CheckTokenRequest(token: event.token);
      try {
        final response = await _auth.checkToken(data);
        yield AuthorizedState(
          user: User(
            firstName: response.user.firstName,
            lastName: response.user.lastName,
            email: response.user.email,
            createdAt: response.user.createdAt,
            serviceTypeId: response.user.serviceTypeId,
          ),
          token: event.token,
        );
      } on DioError catch (err) {
        if (err.response == null || err.response?.statusCode == 400) {
          yield CheckTokenFailed();
        } else if (err.response?.statusCode == 500) {
          final storage = SecureStorage();
          await storage.removeToken();
          yield UnathorizedState();
        }
      } catch (e) {}
    }
    if (event is StartupLogout) {
      yield UnathorizedState();
    }

    if (event is ApiForceLogout) {
      final storage = SecureStorage();
      await storage.removeToken();
      yield UnathorizedState();
    }

    if (event is AppLogout) {
      try {
        final storage = SecureStorage();
        await _auth.logout();
        await storage.removeToken();
        yield UnathorizedState();
      } catch (e) {
        // yield FailedAuthState(error: e.toString());
      }
    }
  }
}
