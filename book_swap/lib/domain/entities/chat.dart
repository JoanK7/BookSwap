/// Chat entity representing a conversation between two users
/// Domain layer entity for chat business logic
class Chat {
  final String id;
  final List<String> participantIds;
  final Map<String, String> participantNames;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? lastSenderId;
  final Map<String, int> unreadCount;

  const Chat({
    required this.id,
    required this.participantIds,
    required this.participantNames,
    this.lastMessage,
    this.lastMessageTime,
    this.lastSenderId,
    this.unreadCount = const {},
  });

  /// Get the other participant's name
  String getOtherParticipantName(String currentUserId) {
    final otherUserId = participantIds.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
    return participantNames[otherUserId] ?? 'Unknown';
  }

  /// Get the other participant's ID
  String getOtherParticipantId(String currentUserId) {
    return participantIds.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
  }

  /// Get unread count for user
  int getUnreadCount(String userId) {
    return unreadCount[userId] ?? 0;
  }

  /// Check if chat has unread messages for user
  bool hasUnreadMessages(String userId) {
    return getUnreadCount(userId) > 0;
  }

  /// Check if user sent the last message
  bool isLastMessageFromUser(String userId) {
    return lastSenderId == userId;
  }

  /// Copy with method for immutability
  Chat copyWith({
    String? id,
    List<String>? participantIds,
    Map<String, String>? participantNames,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? lastSenderId,
    Map<String, int>? unreadCount,
  }) {
    return Chat(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      participantNames: participantNames ?? this.participantNames,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastSenderId: lastSenderId ?? this.lastSenderId,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Chat && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}