import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_manager/features/profile/model/user_profile.dart';
import 'package:task_manager/utils/services/database_helper.dart';
import 'package:path/path.dart' as p;

class ProfileRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Retrieves the current user's profile from Firestore.
  Future<UserProfile?> getUserProfile() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return null;

    try {
      final doc =
          await _firestore.collection('profiles').doc(firebaseUser.uid).get();
      if (doc.exists && doc.data() != null) {
        return UserProfile.fromJson(doc.data()!);
      }
    } catch (e) {
      log('Error fetching user profile: $e');
    }
    return null;
  }

  Future<void> clearDatabase() async {
    try {
      // Ensure the database is closed.
      if (DatabaseHelper.instance.myDatabase != null &&
          DatabaseHelper.instance.myDatabase!.isOpen) {
        await DatabaseHelper.instance.myDatabase!.close();
      }

      // Get the database path.
      final directory = await getApplicationDocumentsDirectory();
      final dbPath = p.join(directory.path, 'taskManager.db');

      // Delete the database file if it exists.
      final file = File(dbPath);
      if (file.existsSync()) {
        await file.delete();
      }

      // Re-initialize the database so it can be used again.
      await DatabaseHelper.instance.reinitializeDatabase();
    } catch (e) {
      log('Error clearing database: $e');
    }
  }
}
