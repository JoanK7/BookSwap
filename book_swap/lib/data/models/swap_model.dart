/// Swap request data model
/// Represents a swap offer between two users
class SwapModel {
  final String id;
  final String requesterId; // User who initiated the swap
  final String requesterName;
  final String ownerId; // Owner of the book being requested
  final String ownerName;
  final String bookId; // Book being requested for swap
  final String bookTitle;
  final String? offeredBookId; // Optional: book offered in exchange
  final String? offeredBookTitle;
  final SwapStatus status;
  final DateTime createdAt;
  final DateTime? respondedAt;

  SwapModel({
    required this.id,
    required this.requesterId,
    required this.requesterName,
    required this.ownerId,
    required this.ownerName,
    required this.bookId,
    required this.bookTitle,
    this.offeredBookId,
    this.offeredBookTitle,
    this.status = SwapStatus.pending,
    required this.createdAt,
    this.respondedAt,
  });

  /// Create SwapModel from Firestore document
  factory SwapModel.fromMap(Map<String, dynamic> map, String id) {
    return SwapModel(
      id: id,
      requesterId: map['requesterId'] ?? '',
      requesterName: map['requesterName'] ?? '',
      ownerId: map['ownerId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      bookId: map['bookId'] ?? '',
      bookTitle: map['bookTitle'] ?? '',
      offeredBookId: map['offeredBookId'],
      offeredBookTitle: map['offeredBookTitle'],
      status: SwapStatus.fromString(map['status'] ?? 'pending'),
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      respondedAt: map['respondedAt']?.toDate(),
    );
  }

  /// Convert SwapModel to map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'requesterId': requesterId,
      'requesterName': requesterName,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'offeredBookId': offeredBookId,
      'offeredBookTitle': offeredBookTitle,
      'status': status.toString().split('.').last,
      'createdAt': createdAt,
      'respondedAt': respondedAt,
    };
  }

  /// Create a copy of SwapModel with updated fields
  SwapModel copyWith({
    String? id,
    String? requesterId,
    String? requesterName,
    String? ownerId,
    String? ownerName,
    String? bookId,
    String? bookTitle,
    String? offeredBookId,
    String? offeredBookTitle,
    SwapStatus? status,
    DateTime? createdAt,
    DateTime? respondedAt,
  }) {
    return SwapModel(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      requesterName: requesterName ?? this.requesterName,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      bookId: bookId ?? this.bookId,
      bookTitle: bookTitle ?? this.bookTitle,
      offeredBookId: offeredBookId ?? this.offeredBookId,
      offeredBookTitle: offeredBookTitle ?? this.offeredBookTitle,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }
}

/// Swap status enum to track the state of a swap request
enum SwapStatus {
  pending,
  accepted,
  rejected,
  cancelled;

  /// Convert string to SwapStatus enum
  static SwapStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return SwapStatus.accepted;
      case 'rejected':
        return SwapStatus.rejected;
      case 'cancelled':
        return SwapStatus.cancelled;
      default:
        return SwapStatus.pending;
    }
  }
}