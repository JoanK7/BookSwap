import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/i_book_repository.dart';
import '../../data/repositories/book_repository.dart';
import 'auth_provider.dart';

/// Provider for Firestore instance
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Provider for Book Repository
final bookRepositoryProvider = Provider<IBookRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return BookRepository(firestore);
});

/// Provider for all books stream
final allBooksProvider = StreamProvider<List<Book>>((ref) {
  final bookRepository = ref.watch(bookRepositoryProvider);
  return bookRepository.getAllBooks();
});

/// Provider for user's books stream
final userBooksProvider = StreamProvider<List<Book>>((ref) {
  final bookRepository = ref.watch(bookRepositoryProvider);
  final currentUser = ref.watch(currentUserProvider);
  
  if (currentUser == null) {
    return Stream.value([]);
  }
  
  return bookRepository.getUserBooks(currentUser.id);
});

/// State notifier for book operations
class BookNotifier extends StateNotifier<AsyncValue<void>> {
  final IBookRepository _bookRepository;

  BookNotifier(this._bookRepository) : super(const AsyncValue.data(null));

  /// Create a new book listing
  Future<Book?> createBook({
    required String title,
    required String author,
    required String condition,
    String? swapFor,
    String? imageBase64,
    required String ownerId,
    required String ownerEmail,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final book = Book(
        id: '',
        title: title,
        author: author,
        condition: condition,
        swapFor: swapFor,
        imageBase64: imageBase64,
        ownerId: ownerId,
        ownerEmail: ownerEmail,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isAvailable: true,
      );
      
      final createdBook = await _bookRepository.createBook(book);
      state = const AsyncValue.data(null);
      return createdBook;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Update existing book
  Future<void> updateBook(Book book) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updatedBook = book.copyWith(updatedAt: DateTime.now());
      await _bookRepository.updateBook(updatedBook);
    });
  }

  /// Delete book listing
  Future<void> deleteBook(String bookId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _bookRepository.deleteBook(bookId);
    });
  }

  /// Update book availability
  Future<void> updateBookAvailability(String bookId, bool isAvailable) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _bookRepository.updateBookAvailability(bookId, isAvailable);
    });
  }
}

/// Provider for book notifier
final bookNotifierProvider = StateNotifierProvider<BookNotifier, AsyncValue<void>>((ref) {
  final bookRepository = ref.watch(bookRepositoryProvider);
  return BookNotifier(bookRepository);
});