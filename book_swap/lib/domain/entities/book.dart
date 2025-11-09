/// Book entity representing a textbook listing
class Book {
  final String id;
  final String title;
  final String author;
  final String condition;
  final String? swapFor;
  final String? imageBase64;
  final String ownerId;
  final String ownerEmail;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isAvailable;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.condition,
    this.swapFor,
    this.imageBase64,
    required this.ownerId,
    required this.ownerEmail,
    required this.createdAt,
    required this.updatedAt,
    this.isAvailable = true,
  });

  /// Create a copy with updated fields
  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? condition,
    String? swapFor,
    String? imageBase64,
    String? ownerId,
    String? ownerEmail,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isAvailable,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      condition: condition ?? this.condition,
      swapFor: swapFor ?? this.swapFor,
      imageBase64: imageBase64 ?? this.imageBase64,
      ownerId: ownerId ?? this.ownerId,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}