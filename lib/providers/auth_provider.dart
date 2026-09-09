import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

/// Provider managing application-wide authentication state.
///
/// Reacts to authentication state changes emitted by [AuthService] and
/// provides reactive login, registration, and logout operations for the UI.
class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService() {
    _init();
  }

  final AuthService _authService;
  StreamSubscription<User?>? _authSubscription;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  /// Currently authenticated user, or `null` if unauthenticated.
  User? get currentUser => _currentUser;

  /// Whether a user is currently authenticated.
  bool get isAuthenticated => _currentUser != null;

  /// Whether an authentication operation is in progress.
  bool get isLoading => _isLoading;

  /// Active error message, if any.
  String? get errorMessage => _errorMessage;

  void _init() {
    try {
      _currentUser = _authService.currentUser;
      _authSubscription = _authService.authStateChanges.listen(
        (user) {
          _currentUser = user;
          _isLoading = false;
          notifyListeners();
        },
        onError: (error) {
          _isLoading = false;
          _errorMessage = AuthService.getErrorMessage(error);
          notifyListeners();
        },
      );
    } catch (_) {
      // In test or unconfigured environments, leave unauthenticated
      _currentUser = null;
    }
  }

  /// Clears any currently displayed error message.
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Attempts to authenticate with [email] and [password].
  ///
  /// Returns `true` on success, or `false` on failure with [errorMessage] populated.
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _authService.loginWithEmailAndPassword(
        email,
        password,
      );
      _currentUser = credential.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = AuthService.getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// Attempts to register a new account with [email] and [password].
  ///
  /// Returns `true` on success, or `false` on failure with [errorMessage] populated.
  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _authService.registerWithEmailAndPassword(
        email,
        password,
      );
      _currentUser = credential.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = AuthService.getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// Signs the current user out.
  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.logout();
      _currentUser = null;
    } catch (e) {
      _errorMessage = AuthService.getErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
