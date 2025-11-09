import '../entities/book.dart';

/// Book repository interface
abstract class IBookRepository {
  /// Get all books stream
  Stream<List<Book>> getAllBooks();
  
  /// Get books owned by specific user
  Stream<List<Book>> getUserBooks(String userId);
  
  /// Get book by ID
  Future<Book> getBookById(String bookId);
  
  /// Create a new book listing
  Future<Book> createBook(Book book);
  
  /// Update existing book
  Future<void> updateBook(Book book);
  
  /// Delete book listing
  Future<void> deleteBook(String bookId);
  
  /// Update book availability status
  Future<void> updateBookAvailability(String bookId, bool isAvailable);
}