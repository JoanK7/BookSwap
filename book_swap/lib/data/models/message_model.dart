import '../../domain/entities/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Data model for Message with Firebase serialization
class MessageModel extends Message {
  MessageModel({
    required super.id,
    required super.chatId,
    required super.senderId,
    required super.senderEmail,
    required super.text,
    required super.timestamp,
  });

  /// Convert Firebase document to MessageModel
  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      chatId: data['chatId'] ?? '',
      senderId: data['senderId'] ?? '',
      senderEmail: data['senderEmail'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  /// Convert MessageModel to Firebase document
  Map<String, dynamic> toFirestore() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'senderEmail': senderEmail,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}