import 'package:firebase_auth/firebase_auth.dart';

/// Service encapsulating all Firebase Authentication operations.
///
/// Direct Firebase Authentication API calls are isolated here,
/// keeping UI widgets and providers decoupled from SDK internals.
class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth;

  final FirebaseAuth? _auth;

  FirebaseAuth get _firebaseAuth => _auth ?? FirebaseAuth.instance;

  /// Stream of authentication state changes emitting the current [User] or `null`.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Currently authenticated [User], or `null` if unauthenticated.
  User? get currentUser => _firebaseAuth.currentUser;

  /// Registers a new user with [email] and [password].
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Authenticates an existing user with [email] and [password].
  Future<UserCredential> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Signs the currently authenticated user out.
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  /// Converts technical authentication exceptions and error codes into
  /// readable, user-friendly messages.
  static String getErrorMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-credential':
        case 'wrong-password':
          return 'The email or password is incorrect.';
        case 'user-not-found':
          return 'No account found with this email.';
        case 'email-already-in-use':
          return 'An account already exists with this email.';
        case 'weak-password':
          return 'Please choose a stronger password (at least 6 characters).';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'network-request-failed':
          return 'Network error. Please check your connection.';
        case 'operation-not-allowed':
          return 'Email/password sign-in is not enabled in Firebase Console.';
        default:
          return error.message ?? 'Authentication failed. Please try again.';
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
