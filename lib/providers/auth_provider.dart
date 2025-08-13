import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _loading = false;
  String? _error;

  UserModel? get user => _user;
  bool get loading => _loading;
  String? get error => _error;
  Stream<UserModel?> get authStateChanges => _authService.user;

  AuthProvider() {
    _authService.user.listen((UserModel? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _setLoading(true);
      _error = null;

      final user = await _authService.signInWithEmailAndPassword(email, password);
      _user = user;

      _setLoading(false);
      return user != null;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String email, String password, String displayName) async {
    try {
      _setLoading(true);
      _error = null;

      final user = await _authService.registerWithEmailAndPassword(
        email,
        password,
        displayName,
      );
      _user = user;

      _setLoading(false);
      return user != null;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _authService.signOut();
      _user = null;
      _setLoading(false);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}