import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AuthStatusChanged extends AuthEvent {
  final User? user;
  const AuthStatusChanged(this.user);
  @override
  List<Object> get props => [user ?? 'null'];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginRequested({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

class AuthLogoutRequested extends AuthEvent {}

enum AuthStatus {
  authenticated,
  unauthenticated,
  unknown,
}