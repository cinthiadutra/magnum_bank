import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_bloc.dart';
import 'package:magnum_bank/presentation/profile/bloc/profile_bloc.dart';
import 'package:magnum_bank/presentation/profile/bloc/profile_event.dart';
import 'package:magnum_bank/presentation/profile/bloc/profile_state.dart';

import '../../core/setup_locator.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthBloc>().state.user?.uid;
    
    return BlocProvider<ProfileBloc>(
      create: (context) => locator<ProfileBloc>()..add(FetchUserProfile(userId: userId!)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meu Perfil'),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileSuccess) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nome: ${state.profile.name}'),
                    Text('Email: ${state.profile.email}'),
                    Text('Idade: ${state.profile.age}'),
                    Text('Hobbies: ${state.profile.hobbies.join(', ')}'),
                    Text('Número de Posts: ${state.profile.postCount}'),
                  ],
                ),
              );
            }
            if (state is ProfileFailure) {
              return Center(child: Text('Erro: ${state.error}'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
