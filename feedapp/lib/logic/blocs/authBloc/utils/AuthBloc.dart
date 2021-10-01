import 'package:dio/dio.dart';
import 'package:stolk/logic/blocs/authBloc/models/user.dart';
import 'package:stolk/utils/@types/request/checkToken.dart';
import 'package:stolk/utils/@types/request/login.dart';
import 'package:stolk/utils/@types/request/register.dart';
import 'package:stolk/utils/services/app/logger.dart';
import 'package:stolk/utils/services/app/startupService.dart';
import 'package:stolk/utils/services/server/authService.dart';
import 'package:stolk/utils/services/app/secureStorage.dart';
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
            id: response.user.id,
            firstName: response.user.firstName,
            lastName: response.user.lastName,
            email: response.user.email,
            createdAt: response.user.createdAt,
            serviceTypeId: response.user.serviceTypeId,
            confirmedAt: response.user.confirmedAt,
            bannedAt: response.user.bannedAt,
          ),
          token: response.token,
        );
        AppLogger.analytics.logLogin(loginMethod: "local");
      } catch (e) {
        yield FailedAuthState(error: e.toString());
      }
    }
    if (event is GoogleLogin) {
      try {
        yield AuthLoadingState();
        final response = await _auth.googleLogin(event.idToken);
        final storage = SecureStorage();
        await storage.setToken(response.token);
        yield AuthorizedState(
          user: User(
            id: response.user.id,
            firstName: response.user.firstName,
            lastName: response.user.lastName,
            email: response.user.email,
            createdAt: response.user.createdAt,
            serviceTypeId: response.user.serviceTypeId,
            confirmedAt: response.user.confirmedAt,
            bannedAt: response.user.bannedAt,
          ),
          token: response.token,
        );
        AppLogger.analytics.logLogin(loginMethod: "google");
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
            id: response.user.id,
            firstName: response.user.firstName,
            lastName: response.user.lastName,
            email: response.user.email,
            createdAt: response.user.createdAt,
            serviceTypeId: response.user.serviceTypeId,
            confirmedAt: response.user.confirmedAt,
            bannedAt: response.user.bannedAt,
          ),
          token: response.token,
        );
        AppLogger.analytics.logSignUp(signUpMethod: "local");
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
            id: response.user.id,
            firstName: response.user.firstName,
            lastName: response.user.lastName,
            email: response.user.email,
            createdAt: response.user.createdAt,
            serviceTypeId: response.user.serviceTypeId,
            confirmedAt: response.user.confirmedAt,
            bannedAt: response.user.bannedAt,
          ),
          token: event.token,
        );
      } on DioError catch (err) {
        if (err.response?.statusCode == 500) {
          final storage = SecureStorage();
          await storage.removeToken();
          yield UnathorizedState();
        }
      } catch (e) {
        yield CheckTokenFailed();
      }
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
