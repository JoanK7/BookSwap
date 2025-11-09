import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/swap.dart';
import '../../domain/repositories/i_swap_repository.dart';
import '../models/swap_model.dart';

/// Implementation of swap repository using Cloud Firestore
class SwapRepository implements ISwapRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'swaps';

  SwapRepository(this._firestore);

  @override
  Stream<List<Swap>> getUserSwaps(String userId) {
    // Get swaps where user is either sender or receiver
    return _firestore
        .collection(_collectionName)
        // stored documents use requesterId/ownerId (see SwapModel.toMap)
        .where('requesterId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((senderSnapshot) async {
      // Also get swaps where user is receiver
      final receiverSnapshot = await _firestore
          .collection(_collectionName)
          .where('ownerId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      final allSwaps = <Swap>[];

      // Add sender swaps
      for (var doc in senderSnapshot.docs) {
        final model = SwapModel.fromMap(doc.data(), doc.id);
        allSwaps.add(Swap(
          id: model.id,
          bookId: model.bookId,
          bookTitle: model.bookTitle,
          senderId: model.requesterId,
          senderEmail: model.requesterName,
          receiverId: model.ownerId,
          receiverEmail: model.ownerName,
          status: model.status.toString().split('.').last,
          createdAt: model.createdAt,
          updatedAt: model.respondedAt ?? model.createdAt,
        ));
      }

      // Add receiver swaps
      for (var doc in receiverSnapshot.docs) {
        final model = SwapModel.fromMap(doc.data(), doc.id);
        allSwaps.add(Swap(
          id: model.id,
          bookId: model.bookId,
          bookTitle: model.bookTitle,
          senderId: model.requesterId,
          senderEmail: model.requesterName,
          receiverId: model.ownerId,
          receiverEmail: model.ownerName,
          status: model.status.toString().split('.').last,
          createdAt: model.createdAt,
          updatedAt: model.respondedAt ?? model.createdAt,
        ));
      }

      // Sort by created date
      allSwaps.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return allSwaps;
    });
  }

  @override
  Future<Swap> createSwap(Swap swap) async {
    try {
      // Build SwapModel from domain Swap (map field names)
      final swapModel = SwapModel(
        id: swap.id,
        requesterId: swap.senderId,
        requesterName: swap.senderEmail,
        ownerId: swap.receiverId,
        ownerName: swap.receiverEmail,
        bookId: swap.bookId,
        bookTitle: swap.bookTitle,
        offeredBookId: null,
        offeredBookTitle: null,
        status: SwapStatus.fromString(swap.status),
        createdAt: swap.createdAt,
        respondedAt: swap.updatedAt,
      );

      final docRef = await _firestore
          .collection(_collectionName)
          .add(swapModel.toMap());

      final doc = await docRef.get();
      final createdModel = SwapModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      return Swap(
        id: createdModel.id,
        bookId: createdModel.bookId,
        bookTitle: createdModel.bookTitle,
        senderId: createdModel.requesterId,
        senderEmail: createdModel.requesterName,
        receiverId: createdModel.ownerId,
        receiverEmail: createdModel.ownerName,
        status: createdModel.status.toString().split('.').last,
        createdAt: createdModel.createdAt,
        updatedAt: createdModel.respondedAt ?? createdModel.createdAt,
      );
    } catch (e) {
      throw Exception('Failed to create swap: $e');
    }
  }

  @override
  Future<void> updateSwapStatus(String swapId, String status) async {
    try {
      await _firestore.collection(_collectionName).doc(swapId).update({
        'status': status,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update swap status: $e');
    }
  }

  @override
  Future<void> deleteSwap(String swapId) async {
    try {
      await _firestore.collection(_collectionName).doc(swapId).delete();
    } catch (e) {
      throw Exception('Failed to delete swap: $e');
    }
  }

  @override
  Stream<List<Swap>> getBookSwaps(String bookId) {
    return _firestore
        .collection(_collectionName)
        .where('bookId', isEqualTo: bookId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final model = SwapModel.fromMap(doc.data(), doc.id);
        return Swap(
          id: model.id,
          bookId: model.bookId,
          bookTitle: model.bookTitle,
          senderId: model.requesterId,
          senderEmail: model.requesterName,
          receiverId: model.ownerId,
          receiverEmail: model.ownerName,
          status: model.status.toString().split('.').last,
          createdAt: model.createdAt,
          updatedAt: model.respondedAt ?? model.createdAt,
        );
      }).toList();
    });
  }
}