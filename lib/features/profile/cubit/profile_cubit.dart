import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/profile/cubit/profile_state.dart';
import 'package:task_manager/features/profile/repo/profile_repo.dart';
import 'package:task_manager/utils/models/result.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.repository) : super(const ProfileState());

  final ProfileRepo repository;

  Future<void> getUserProfile() async {
    try {
      emit(state.copyWith(profileStatus: const Result.loading()));
      final response = await repository.getUserProfile();

      if (response != null) {
        emit(
          state.copyWith(
            profileStatus: const Result.success(null),
            profile: response,
          ),
        );
      }
    } catch (e) {
      log('Error: $e ');
      emit(state.copyWith(profileStatus: Result.failure(e.toString())));
    }
  }
}
