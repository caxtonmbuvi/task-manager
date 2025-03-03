import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/auth/cubit/auth_state.dart';
import 'package:task_manager/features/auth/repo/auth_repo.dart';
import 'package:task_manager/features/task/repo/tasks_repo.dart';
import 'package:task_manager/utils/models/result.dart';
import 'package:task_manager/utils/services/firebase_service.dart';
import 'package:task_manager/utils/services/sync_service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.repository) : super(const AuthState());
  final AuthRepo repository;

  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(authStatus: const Result.loading()));
    try {
      final response = await repository.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (response != null) {
        emit(
          state.copyWith(
            authStatus: Result.success(null),
            user: response,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handling specific registration errors.
      if (e.code == 'email-already-in-use') {
        emit(
          state.copyWith(
            authStatus: Result.failure(
                'The email is already registered. Please sign in instead.'),
          ),
        );
      } else if (e.code == 'invalid-email') {
        emit(
          state.copyWith(
            authStatus: Result.failure('The provided email is invalid.'),
          ),
        );
      } else if (e.code == 'weak-password') {
        emit(
          state.copyWith(
            authStatus: Result.failure('The provided password is too weak.'),
          ),
        );
      } else {
        emit(
          state.copyWith(
            authStatus: Result.failure('Error: ${e.message}'),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          authStatus: Result.failure(
              'An unexpected error occurred. Please try again later. $e'),
        ),
      );
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(authStatus: const Result.loading()));
    try {
      final response = await repository.loginUserWithEmailAndPassword(
          email: email, password: password);
      if (response != null) {
        // Immediately fetch tasks from Firebase and update the local database.
        await SyncService(
          tasksRepo: TasksRepo(),
          firebaseService: FirebaseService(),
        ).syncTasks();
        emit(
          state.copyWith(
            authStatus: Result.success(null),
            user: response,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(
          state.copyWith(
            authStatus: Result.failure(
                'No account found for that email. Please sign up first.'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        emit(
          state.copyWith(
            authStatus: Result.failure('Incorrect password provided.'),
          ),
        );
      } else if (e.code == 'invalid-email') {
        emit(
          state.copyWith(
            authStatus: Result.failure('The provided email is invalid.'),
          ),
        );
      } else {
        emit(
          state.copyWith(
            authStatus: Result.failure('Error: ${e.message}'),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          authStatus: Result.failure(
              'An unexpected error occurred. Please try again later. $e'),
        ),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(authStatus: const Result.loading()));
    try {
      final response = await repository.signInWithGoogle();
      if (response != null) {
        await SyncService(
          tasksRepo: TasksRepo(),
          firebaseService: FirebaseService(),
        ).syncTasks();
        emit(
          state.copyWith(
            authStatus: Result.success(null),
            user: response,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          authStatus: Result.failure('Google Sign-In error: ${e.message}'),
        ),
      );
    } catch (e) {
      log('Error here: $e');
      emit(
        state.copyWith(
          authStatus: Result.failure(
              'An unexpected error occurred during Google Sign-In. $e'),
        ),
      );
    }
  }
}