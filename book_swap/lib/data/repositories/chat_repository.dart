import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/i_chat_repository.dart';
import '../models/message_model.dart';

/// Implementation of chat repository using Cloud Firestore
class ChatRepository implements IChatRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'messages';

  ChatRepository(this._firestore);

  @override
  Stream<List<Message>> getChatMessages(String chatId) {
    return _firestore
        .collection(_collectionName)
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Future<Message> sendMessage(Message message) async {
    try {
      final messageModel = MessageModel(
        id: message.id,
        chatId: message.chatId,
        senderId: message.senderId,
        senderEmail: message.senderEmail,
        text: message.text,
        timestamp: message.timestamp,
      );

      final docRef = await _firestore
          .collection(_collectionName)
          .add(messageModel.toFirestore());

      final doc = await docRef.get();
      return MessageModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<List<String>> getUserChatIds(String userId) async {
    try {
      // Get all messages where user is sender or has chat with their ID
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('senderId', isEqualTo: userId)
          .get();

      // Extract unique chat IDs
      final chatIds = <String>{};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data['chatId'] != null) {
          chatIds.add(data['chatId']);
        }
      }

      return chatIds.toList();
    } catch (e) {
      throw Exception('Failed to get user chats: $e');
    }
  }

  @override
  String generateChatId(String userId1, String userId2) {
    // Generate consistent chat ID regardless of order
    final users = [userId1, userId2]..sort();
    return '${users[0]}_${users[1]}';
  }
}