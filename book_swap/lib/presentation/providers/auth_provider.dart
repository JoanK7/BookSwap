import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../domain/entities/user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../data/repositories/auth_repository.dart';

/// Provider for Firebase Auth instance
final firebaseAuthProvider = Provider<auth.FirebaseAuth>((ref) {
  return auth.FirebaseAuth.instance;
});

/// Provider for Auth Repository
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return AuthRepository(firebaseAuth);
});

/// Provider for authentication state stream
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

/// Provider for current user — derived from the auth state stream so it updates
/// automatically when the Firebase auth user changes.
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  // authState is AsyncValue<User?>; when data is available return it, else null
  return authState.asData?.value;
});

/// State notifier for auth operations (sign in, sign up, etc.)
class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final IAuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AsyncValue.data(null));

  /// Sign up with name, email and password
  Future<void> signUp(String name, String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signUp(name, email, password);
    });
  }

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signIn(email, password);
    });
  }

  /// Sign out current user
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signOut();
    });
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.sendPasswordResetEmail(email);
    });
  }
}

/// Provider for auth notifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});