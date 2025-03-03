import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_manager/features/profile/model/user_profile.dart';
import 'package:task_manager/utils/models/result.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(Result<String?>.empty()) Result<String?> profileStatus,
    UserProfile? profile,
  }) = _ProfileState;
}
