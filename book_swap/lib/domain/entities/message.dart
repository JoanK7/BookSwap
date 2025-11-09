/// Message entity for chat functionality
class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String senderEmail;
  final String text;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderEmail,
    required this.text,
    required this.timestamp,
  });
}