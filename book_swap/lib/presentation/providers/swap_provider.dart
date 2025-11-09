import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/swap.dart';
import '../../domain/repositories/i_swap_repository.dart';
import '../../data/repositories/swap_repository.dart';
import 'auth_provider.dart';
import 'book_provider.dart';

/// Provider for Swap Repository
final swapRepositoryProvider = Provider<ISwapRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return SwapRepository(firestore);
});

/// Provider for user's swaps stream
final userSwapsProvider = StreamProvider<List<Swap>>((ref) {
  final swapRepository = ref.watch(swapRepositoryProvider);
  final currentUser = ref.watch(currentUserProvider);
  
  if (currentUser == null) {
    return Stream.value([]);
  }
  
  return swapRepository.getUserSwaps(currentUser.id);
});

/// State notifier for swap operations
class SwapNotifier extends StateNotifier<AsyncValue<void>> {
  final ISwapRepository _swapRepository;

  SwapNotifier(this._swapRepository) : super(const AsyncValue.data(null));

  /// Create a new swap offer
  Future<Swap?> createSwap({
    required String bookId,
    required String bookTitle,
    required String senderId,
    required String senderEmail,
    required String receiverId,
    required String receiverEmail,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final swap = Swap(
        id: '',
        bookId: bookId,
        bookTitle: bookTitle,
        senderId: senderId,
        senderEmail: senderEmail,
        receiverId: receiverId,
        receiverEmail: receiverEmail,
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final createdSwap = await _swapRepository.createSwap(swap);
      state = const AsyncValue.data(null);
      return createdSwap;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Update swap status
  Future<void> updateSwapStatus(String swapId, String status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _swapRepository.updateSwapStatus(swapId, status);
    });
  }

  /// Delete swap
  Future<void> deleteSwap(String swapId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _swapRepository.deleteSwap(swapId);
    });
  }
}

/// Provider for swap notifier
final swapNotifierProvider = StateNotifierProvider<SwapNotifier, AsyncValue<void>>((ref) {
  final swapRepository = ref.watch(swapRepositoryProvider);
  return SwapNotifier(swapRepository);
});