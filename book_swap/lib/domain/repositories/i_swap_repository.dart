import '../entities/swap.dart';

/// Swap repository interface
abstract class ISwapRepository {
  /// Get all swaps for a user (sent and received)
  Stream<List<Swap>> getUserSwaps(String userId);
  
  /// Get swaps for a specific book
  Stream<List<Swap>> getBookSwaps(String bookId);
  
  /// Create a new swap offer
  Future<Swap> createSwap(Swap swap);
  
  /// Update swap status (accepted, rejected, etc.)
  Future<void> updateSwapStatus(String swapId, String status);
  
  /// Delete swap offer
  Future<void> deleteSwap(String swapId);
}