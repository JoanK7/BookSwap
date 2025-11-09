// data/services/firebase_service.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firebase service singleton
/// Provides centralized access to Firebase instances
/// Note: Firebase Storage removed - using Base64 for images
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  
  factory FirebaseService() => _instance;
  
  FirebaseService._internal();

  /// Firebase Auth instance
  FirebaseAuth get auth => FirebaseAuth.instance;

  /// Firestore instance
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  /// Current authenticated user
  User? get currentUser => auth.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => auth.authStateChanges();

  /// Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  /// Sign out
  Future<void> signOut() async {
    await auth.signOut();
  }

  /// Check if user is signed in
  bool get isSignedIn => currentUser != null;

  /// Get current user ID
  String? get currentUserId => currentUser?.uid;

  /// Enable Firestore offline persistence
  Future<void> enableOfflinePersistence() async {
    try {
      firestore.settings.persistenceEnabled;
    } catch (e) {
      print('Offline persistence error: $e');
    }
  }

  /// Collection references
  CollectionReference get usersCollection => 
      firestore.collection('users');

  CollectionReference get booksCollection => 
      firestore.collection('books');

  CollectionReference get swapsCollection => 
      firestore.collection('swaps');

  CollectionReference get chatsCollection => 
      firestore.collection('chats');

  CollectionReference get messagesCollection => 
      firestore.collection('messages');
}