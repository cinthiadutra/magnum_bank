import 'package:equatable/equatable.dart';
import 'package:magnum_bank/domain/entities/user.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserProfile profile;
  const ProfileSuccess(UserProfile userProfile, {required this.profile});
  @override
  List<Object> get props => [profile];
}

class ProfileFailure extends ProfileState {
  final String error;
  const ProfileFailure( {required this.error});
  @override
  List<Object> get props => [error];
}