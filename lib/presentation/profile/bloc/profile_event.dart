import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object> get props => [];
}

class FetchUserProfile extends ProfileEvent {
  final String userId;
  const FetchUserProfile({required this.userId});
  @override
  List<Object> get props => [userId];
}