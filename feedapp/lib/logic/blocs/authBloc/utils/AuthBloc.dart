import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
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
  final _settingsBox = Hive.box("settings");
  final storage = SecureStorage();

  AuthBloc._() : super(UnknownAuthState()) {
    on<AppLogin>((event, emit) async {
      final data = LoginRequest(email: event.email, password: event.password);
      try {
        emit(AuthLoadingState());
        final response = await _auth.login(data);
        await storage.setToken(response.token);
        emit(AuthorizedState(
          user: response.user,
          token: response.token,
        ));
        AppLogger.analytics.logLogin(loginMethod: "local");
      } catch (e) {
        emit(FailedAuthState(error: e.toString()));
      }
    });
    on<GoogleLogin>((event, emit) async {
      try {
        emit(AuthLoadingState());
        final response = await _auth.googleLogin(event.idToken);
        await storage.setToken(response.token);
        emit(AuthorizedState(
          user: response.user,
          token: response.token,
        ));
        AppLogger.analytics.logLogin(loginMethod: "google");
      } catch (e) {
        emit(FailedAuthState(error: e.toString()));
      }
    });
    on<FacebookLogin>((event, emit) async {
      try {
        emit(AuthLoadingState());
        final response = await _auth.facebookLogin(event.token);
        await storage.setToken(response.token);
        emit(AuthorizedState(
          user: response.user,
          token: response.token,
        ));
        AppLogger.analytics.logLogin(loginMethod: "facebook");
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
        await storage.setToken(response.token);
        emit(AuthorizedState(
          user: response.user,
          token: response.token,
        ));
        AppLogger.analytics.logSignUp(signUpMethod: "local");
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
      try {
        await storage.removeToken();
        // Delete notification token locally to be able to save token on later login
        await StartupService.instance.deleteTokenLocally();
        emit(UnathorizedState());
      } catch (e) {}
    });
    on<AppLogout>((event, emit) async {
      try {
        await _auth.logout();

        await storage.removeToken();
        // Delete notification token locally to be able to save token on later login
        await StartupService.instance.deleteTokenLocally();

        emit(UnathorizedState());
      } catch (e) {}
    });
  }

  Future<void> _saveUserToken(
    Transition<AuthEvent, AuthState> transition,
  ) async {
    if (transition.nextState is AuthorizedState &&
        transition.currentState is AuthLoadingState) {
      final authToken = (transition.nextState as AuthorizedState).token;
      await _settingsBox.delete("notificationToken");
      await StartupService.instance.storeDeviceToken(authToken);
    }
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    _saveUserToken(transition).catchError((_) {});
  }
}
