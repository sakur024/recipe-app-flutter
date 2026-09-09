import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/providers/auth_provider.dart';
import 'package:recipe_app/services/auth_service.dart';

class FakeUser implements User {
  FakeUser({this.email = 'test@example.com'});

  @override
  final String? email;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeUserCredential implements UserCredential {
  FakeUserCredential([this.user]);

  @override
  final User? user;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAuthService extends AuthService {
  FakeAuthService({User? stubUser})
      : stubUser = stubUser ?? FakeUser(),
        super(auth: null);

  final User stubUser;
  final StreamController<User?> _controller =
      StreamController<User?>.broadcast();
  User? _current;

  bool shouldFail = false;
  String failCode = 'invalid-credential';
  Completer<void>? pendingCompleter;

  @override
  Stream<User?> get authStateChanges => _controller.stream;

  @override
  User? get currentUser => _current;

  void emitUser(User? user) {
    _current = user;
    _controller.add(user);
  }

  @override
  Future<UserCredential> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (pendingCompleter != null) {
      await pendingCompleter!.future;
    }
    if (shouldFail) {
      throw FirebaseAuthException(code: failCode);
    }
    _current = stubUser;
    _controller.add(_current);
    return FakeUserCredential(stubUser);
  }

  @override
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (pendingCompleter != null) {
      await pendingCompleter!.future;
    }
    if (shouldFail) {
      throw FirebaseAuthException(code: failCode);
    }
    _current = stubUser;
    _controller.add(_current);
    return FakeUserCredential(stubUser);
  }

  @override
  Future<void> logout() async {
    _current = null;
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}

void main() {
  late FakeAuthService fakeService;
  late AuthProvider provider;

  setUp(() {
    fakeService = FakeAuthService();
    provider = AuthProvider(authService: fakeService);
  });

  tearDown(() {
    provider.dispose();
    fakeService.dispose();
  });

  group('AuthProvider Unit Tests', () {
    // 5. AuthProvider initial state is correct.
    test('initial state is correct', () {
      expect(provider.currentUser, isNull);
      expect(provider.isAuthenticated, isFalse);
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
    });

    // 6. Authentication loading state behaves correctly.
    test('loading state behaves correctly during authentication', () async {
      fakeService.pendingCompleter = Completer<void>();

      final loginFuture = provider.login('test@example.com', 'password123');

      // While pending, isLoading should be true
      expect(provider.isLoading, isTrue);
      expect(provider.errorMessage, isNull);

      // Complete async operation
      fakeService.pendingCompleter!.complete();
      final result = await loginFuture;

      expect(result, isTrue);
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
    });

    test('error handling updates errorMessage and resets loading', () async {
      fakeService.shouldFail = true;
      fakeService.failCode = 'wrong-password';

      final result = await provider.login('test@example.com', 'wrong');

      expect(result, isFalse);
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, 'The email or password is incorrect.');

      provider.clearError();
      expect(provider.errorMessage, isNull);
    });

    test('register success and failure scenarios', () async {
      fakeService.shouldFail = true;
      fakeService.failCode = 'email-already-in-use';

      final failed = await provider.register('existing@example.com', 'secret');
      expect(failed, isFalse);
      expect(
        provider.errorMessage,
        'An account already exists with this email.',
      );

      fakeService.shouldFail = false;
      final success = await provider.register('new@example.com', 'secret123');
      expect(success, isTrue);
      expect(provider.errorMessage, isNull);
    });

    test('logout clears user and updates state', () async {
      await provider.login('user@example.com', 'password123');
      expect(provider.isAuthenticated, isTrue);

      await provider.logout();

      expect(provider.currentUser, isNull);
      expect(provider.isAuthenticated, isFalse);
      expect(provider.isLoading, isFalse);
    });
  });
}
