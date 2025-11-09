import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/i_book_repository.dart';
import '../models/book_model.dart';

/// Implementation of book repository using Cloud Firestore
class BookRepository implements IBookRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'books';

  BookRepository(this._firestore);

  @override
  Stream<List<Book>> getAllBooks() {
    return _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BookModel.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Stream<List<Book>> getUserBooks(String userId) {
    return _firestore
        .collection(_collectionName)
        .where('ownerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BookModel.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Future<Book> getBookById(String bookId) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(bookId).get();
      
      if (!doc.exists) {
        throw Exception('Book not found');
      }
      
      return BookModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get book: $e');
    }
  }

  @override
  Future<Book> createBook(Book book) async {
    try {
      final bookModel = BookModel.fromEntity(book);
      final docRef = await _firestore
          .collection(_collectionName)
          .add(bookModel.toFirestore());

      final doc = await docRef.get();
      return BookModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to create book: $e');
    }
  }

  @override
  Future<void> updateBook(Book book) async {
    try {
      final bookModel = BookModel.fromEntity(book);
      await _firestore
          .collection(_collectionName)
          .doc(book.id)
          .update(bookModel.toFirestore());
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }

  @override
  Future<void> deleteBook(String bookId) async {
    try {
      await _firestore.collection(_collectionName).doc(bookId).delete();
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }

  @override
  Future<void> updateBookAvailability(String bookId, bool isAvailable) async {
    try {
      await _firestore.collection(_collectionName).doc(bookId).update({
        'isAvailable': isAvailable,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update book availability: $e');
    }
  }
}