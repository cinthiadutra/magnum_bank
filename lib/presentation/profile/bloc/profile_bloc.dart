import 'package:bloc/bloc.dart';
import 'package:magnum_bank/data/repositories/auth_repository.dart';
import 'package:magnum_bank/presentation/profile/bloc/profile_event.dart';
import 'package:magnum_bank/presentation/profile/bloc/profile_state.dart';



class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IAuthRepository _authRepository;
  ProfileBloc({required IAuthRepository authRepository})
      : _authRepository = authRepository,
        super(ProfileInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
  }

  Future<void> _onFetchUserProfile(
      FetchUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profile = await _authRepository.getUserProfile(userId: event.userId);
      if (profile != null) {
        emit(ProfileSuccess(profile: profile));
      } else {
        // Se o perfil não for encontrado, emite um estado de falha
        emit(const ProfileFailure(error: 'Perfil não encontrado.'));
      }
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }
}