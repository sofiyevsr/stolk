import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  static final instance = AuthBloc._();
  static final _auth = AuthService();
  AuthBloc._() : super(UnknownAuthState()) {
    on<AppLogin>((event, emit) async {
      final data = LoginRequest(email: event.email, password: event.password);
      try {
        emit(AuthLoadingState());
        final response = await _auth.login(data);
        final storage = SecureStorage();
        await storage.setToken(response.token);
        emit(AuthorizedState(
          user: response.user,
          token: response.token,
        ));
        await AppLogger.analytics
            .logLogin(loginMethod: "local")
            .catchError((_) {});
      } catch (e) {
        emit(FailedAuthState(error: e.toString()));
      }
    });
    on<GoogleLogin>((event, emit) async {
      try {
        emit(AuthLoadingState());
        final response = await _auth.googleLogin(event.idToken);
        final storage = SecureStorage();
        await storage.setToken(response.token);
        emit(AuthorizedState(
          user: response.user,
          token: response.token,
        ));
        await AppLogger.analytics
            .logLogin(loginMethod: "google")
            .catchError((_) {});
      } catch (e) {
        emit(FailedAuthState(error: e.toString()));
      }
    });
    on<FacebookLogin>((event, emit) async {
      try {
        emit(AuthLoadingState());
        final response = await _auth.facebookLogin(event.token);
        final storage = SecureStorage();
        await storage.setToken(response.token);
        emit(AuthorizedState(
          user: response.user,
          token: response.token,
        ));
        await AppLogger.analytics
            .logLogin(loginMethod: "facebook")
            .catchError((_) {});
      } catch (e) {
        emit(FailedAuthState(error: e.toString()));
      }
    });
    on<AppRegister>((event, emit) async {
      final data = RegisterRequest(
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
          password: event.password);
      try {
        emit(AuthLoadingState());
        final response = await _auth.register(data);
        final storage = SecureStorage();
        await storage.setToken(response.token);
        emit(AuthorizedState(
          user: response.user,
          token: response.token,
        ));
        await AppLogger.analytics
            .logSignUp(signUpMethod: "local")
            .catchError((_) {});
      } catch (e) {
        emit(FailedAuthState(error: e.toString()));
      }
    });
    on<CheckTokenEvent>((event, emit) async {
      final data = CheckTokenRequest(token: event.token);
      try {
        final response = await _auth.checkToken(data);
        emit(AuthorizedState(
          user: response.user,
          token: event.token,
        ));
      } on DioError catch (err) {
        if (err.response?.statusCode == 500) {
          final storage = SecureStorage();
          await storage.removeToken();
          emit(UnathorizedState());
        } else
          emit(CheckTokenFailed());
      } catch (e) {
        emit(CheckTokenFailed());
      }
    });
    on<CompleteProfileEvent>((event, emit) async {
      if (state is AuthorizedState) {
        final user = (state as AuthorizedState).user;
        final token = (state as AuthorizedState).token;
        emit(AuthorizedState(
          user: user.completeProfile(event.completedAt),
          token: token,
        ));
      }
    });
    on<StartupLogout>((event, emit) async {
      emit(UnathorizedState());
    });
    on<ApiForceLogout>((event, emit) async {
      final storage = SecureStorage();
      await storage.removeToken();
      emit(UnathorizedState());
      await _userLoggingOut();
    });
    on<AppLogout>((event, emit) async {
      try {
        await _auth.logout();

        final storage = SecureStorage();
        await storage.removeToken();

        emit(UnathorizedState());
        await _userLoggingOut();
      } catch (e) {
        // yield FailedAuthState(error: e.toString());
      }
    });
  }
  Future<void> _userLoggingOut() async {
    // Delete token after state is yielded to avoid onTokenRefresh function to resave token
    await FirebaseMessaging.instance.deleteToken();
  }

  Future<void> _saveUserToken(
    Transition<AuthEvent, AuthState> transition,
  ) async {
    if (transition.nextState is AuthorizedState &&
        transition.currentState is AuthLoadingState) {
      // Make sure to get fresh token on every login
      await FirebaseMessaging.instance.deleteToken();
      await FirebaseMessaging.instance.getToken();
    }
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    _saveUserToken(transition).catchError((_) {});
  }
}
