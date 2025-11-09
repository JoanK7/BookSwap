import '../entities/user.dart';

/// Authentication repository interface
abstract class IAuthRepository {
  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;
  
  /// Get current authenticated user
  User? get currentUser;
  
  /// Sign up a new user
  ///
  /// `name` is the display name to persist for the user (saved to Firestore).
  Future<User> signUp(String name, String email, String password);
  
  /// Sign in existing user
  Future<User> signIn(String email, String password);
  
  /// Sign out current user
  Future<void> signOut();
  
  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);
}