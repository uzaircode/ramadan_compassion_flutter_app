import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Convert Firebase User to UserModel
  UserModel? _userFromFirebaseUser(User? user) {
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  // Auth state changes stream
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Get current user
  UserModel? get currentUser {
    return _userFromFirebaseUser(_auth.currentUser);
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Register with email and password
  Future<UserModel?> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
    ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      User? user = result.user;

      // Update display name
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.reload();
        user = _auth.currentUser;
      }

      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      throw 'Failed to sign out: ${e.toString()}';
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'user-disabled':
        return 'This account has been disabled.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }
}