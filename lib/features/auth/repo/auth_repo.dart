import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepo {
  final auth = FirebaseAuth.instance;
  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credentials = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final firebaseUser = credentials.user;
    if (firebaseUser != null) {
      // For email users, you might not have a displayName.
      await createProfile();
    }
    return credentials.user;
  }

  Future<User?> loginUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credentials = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credentials.user;
  }

  Future<void> signout() async {
    try {
      await auth.signOut();
    } catch (e) {
      log('Something went wrong: $e');
    }
  }

  User? getCurrentUser() {
    return auth.currentUser;
  }

  Future<User?> signInWithGoogle() async {
    // Trigger the Google sign-in flow.
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      // User canceled the sign-in.
      return null;
    }

    final googleAuth = await googleUser.authentication;
    log('Google Token: ${googleAuth.idToken}');
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await auth.signInWithCredential(credential);
    final firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      // After signing in, try to create/update the user profile.
      await createProfile();
    }

    return firebaseUser;
  }

  Future<void> createProfile() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final uid = firebaseUser.uid;
      final email = firebaseUser.email ?? '';
      // Use the displayName if available, otherwise extract a name from the email.
      String name = firebaseUser.displayName ?? _extractNameFromEmail(email);

      final profileData = {
        'uid': uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Save or update the profile document (merge to update existing fields).
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(uid)
          .set(profileData, SetOptions(merge: true));
      log('Profile updated for user: $uid');
    }
  }

// Helper function to extract a simple name from an email address.
  String _extractNameFromEmail(String email) {
    // Splits the email at '@' and capitalizes the first letter.
    if (email.isEmpty) return '';
    final namePart = email.split('@').first;
    return namePart[0].toUpperCase() + namePart.substring(1);
  }
}
