import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentecart/app/errors/api_error_handler.dart';

import 'auth_event.dart';
import 'auth_state.dart';

import '../../domain/repositories/auth_repository.dart';

import '../../../../app/services/secure_storage_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  final SecureStorageService secureStorageService;

  AuthBloc({required this.authRepository, required this.secureStorageService})
    : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);

    on<AuthCheckRequested>(_onAuthCheckRequested);

    on<SignupRequested>(_onSignupRequested);

    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      final response = await authRepository.login(
        email: event.email,
        password: event.password,
      );

      await secureStorageService.saveAccessToken(response.tokens.accessToken);

      await secureStorageService.saveRefreshToken(response.tokens.refreshToken);

      emit(AuthAuthenticated(response.user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthChecking());

    try {
      final token = await secureStorageService.getAccessToken();

      if (token == null) {
        emit(AuthInitial());

        return;
      }

      final user = await authRepository.getCurrentUser();

      emit(AuthAuthenticated(user));
    } catch (e) {
      await secureStorageService.clearTokens();

      emit(AuthInitial());
    }
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      final response = await authRepository.signup(
        name: event.name,
        email: event.email,
        password: event.password,
      );

      await secureStorageService.saveAccessToken(response.tokens.accessToken);

      await secureStorageService.saveRefreshToken(response.tokens.refreshToken);

      emit(AuthAuthenticated(response.user));
    } catch (e) {
      emit(AuthFailure(ApiErrorHandler.getMessage(e)));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await authRepository.logout();
    } catch (_) {}

    await secureStorageService.clearTokens();

    emit(AuthInitial());
  }
}
