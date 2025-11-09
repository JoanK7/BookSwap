import '../../domain/entities/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Data model for Book with Firebase serialization
class BookModel extends Book {
  BookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.condition,
    super.swapFor,
    super.imageBase64,
    required super.ownerId,
    required super.ownerEmail,
    required super.createdAt,
    required super.updatedAt,
    super.isAvailable,
  });

  /// Convert Firebase document to BookModel
  factory BookModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookModel(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      condition: data['condition'] ?? '',
      swapFor: data['swapFor'],
      imageBase64: data['imageBase64'],
      ownerId: data['ownerId'] ?? '',
      ownerEmail: data['ownerEmail'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isAvailable: data['isAvailable'] ?? true,
    );
  }

  /// Convert BookModel to Firebase document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'author': author,
      'condition': condition,
      'swapFor': swapFor,
      'imageBase64': imageBase64,
      'ownerId': ownerId,
      'ownerEmail': ownerEmail,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isAvailable': isAvailable,
    };
  }

  /// Convert Book entity to BookModel
  factory BookModel.fromEntity(Book book) {
    return BookModel(
      id: book.id,
      title: book.title,
      author: book.author,
      condition: book.condition,
      swapFor: book.swapFor,
      imageBase64: book.imageBase64,
      ownerId: book.ownerId,
      ownerEmail: book.ownerEmail,
      createdAt: book.createdAt,
      updatedAt: book.updatedAt,
      isAvailable: book.isAvailable,
    );
  }
}