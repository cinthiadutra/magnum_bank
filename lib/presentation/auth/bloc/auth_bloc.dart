import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:magnum_bank/data/repositories/auth_repository.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_event.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository;

  AuthBloc({required IAuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.unauthenticated()) {
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);

    _authRepository.authStateChanges.listen((user) {
      add(AuthStatusChanged(user));
    });
  }

  void _onAuthStatusChanged(
      AuthStatusChanged event, Emitter<AuthState> emit) async {
    if (event.user != null) {
      emit(AuthState.authenticated(event.user!));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.signInWithEmail(
          email: event.email, password: event.password);
    } catch (e) {
      debugPrint('Login failed: $e');
    }
  }

  Future<void> _onAuthLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
  }
}