import '../../domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

/// Data model for User with Firebase serialization
class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.emailVerified,
    required super.createdAt,
  });

  /// Convert Firebase User to UserModel
  factory UserModel.fromFirebaseUser(auth.User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      emailVerified: firebaseUser.emailVerified,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }
}