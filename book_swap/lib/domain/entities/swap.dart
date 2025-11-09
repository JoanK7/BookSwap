/// Swap entity representing a book swap offer
class Swap {
  final String id;
  final String bookId;
  final String bookTitle;
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String receiverEmail;
  final String status; // pending, accepted, rejected
  final DateTime createdAt;
  final DateTime updatedAt;

  Swap({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.receiverEmail,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a copy with updated fields
  Swap copyWith({
    String? id,
    String? bookId,
    String? bookTitle,
    String? senderId,
    String? senderEmail,
    String? receiverId,
    String? receiverEmail,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Swap(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      bookTitle: bookTitle ?? this.bookTitle,
      senderId: senderId ?? this.senderId,
      senderEmail: senderEmail ?? this.senderEmail,
      receiverId: receiverId ?? this.receiverId,
      receiverEmail: receiverEmail ?? this.receiverEmail,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}