import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdsolucoes_front_end/domain/usecases/login_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/logout_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/forgot_password_usecase.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/auth/auth_event.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/auth/auth_state.dart';
import 'package:pdsolucoes_front_end/core/network/dio_client.dart';
import 'package:pdsolucoes_front_end/core/utils/storage_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.forgotPasswordUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RefreshTokenEvent>(_onRefreshToken);
    on<LogoutEvent>(_onLogout);
    on<ForgotPasswordEvent>(_onForgotPassword);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final result = await loginUseCase.call(event.email, event.password);
      
      final token = result['token'];
      final refreshToken = result['refreshToken'];
      final user = result['user'];
      
      DioClient.instance.setAuthToken(token);
      
      await StorageService.saveAuthData(
        token: token,
        refreshToken: refreshToken,
        userId: user.id,
        userEmail: user.email,
        userName: user.name,
      );
      
      emit(AuthAuthenticated(
        user: user,
        token: token,
      ));
    } catch (e) {
      emit(AuthError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onRefreshToken(
      RefreshTokenEvent event, Emitter<AuthState> emit) async {
    try {
      final result = await loginUseCase.repository.refreshToken(event.refreshToken);
      
      final token = result['token'];
      final refreshToken = result['refreshToken'];
      
      DioClient.instance.setAuthToken(token);
      
      final userData = await StorageService.getUserData();
      await StorageService.saveAuthData(
        token: token,
        refreshToken: refreshToken,
        userId: userData['userId'] ?? '',
        userEmail: userData['userEmail'] ?? '',
        userName: userData['userName'] ?? '',
      );
    } catch (e) {
      emit(AuthError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onForgotPassword(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await forgotPasswordUseCase.call(event.email);
      emit(ForgotPasswordSuccess(
          message: 'E-mail de recuperação enviado com sucesso!'));
    } catch (e) {
      emit(AuthError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await logoutUseCase.call();
      DioClient.instance.removeAuthToken();
      emit(AuthInitial());
    } catch (e) {
      DioClient.instance.removeAuthToken();
      await StorageService.clearAuthData();
      emit(AuthInitial());
    }
  }
}


