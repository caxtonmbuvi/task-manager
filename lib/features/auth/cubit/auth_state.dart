import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_manager/utils/models/result.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(Result<String?>.empty()) Result<String?> authStatus,
    User? user,
  }) = _AuthState;
}
