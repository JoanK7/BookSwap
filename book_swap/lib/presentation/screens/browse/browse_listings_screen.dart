import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/swap_provider.dart';
import '../../providers/book_provider.dart';
import '../../widgets/book_card.dart';

/// Browse listings screen showing all available books
class BrowseListingsScreen extends ConsumerWidget {
  const BrowseListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(allBooksProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.browseListings),
        elevation: 0,
      ),
      body: booksAsync.when(
        data: (books) {
          // Filter out user's own books and unavailable books
          final availableBooks = books.where((book) {
            return book.isAvailable && book.ownerId != currentUser?.id;
          }).toList();

          if (availableBooks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 80,
                    color: AppColors.textLight,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No books available',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Check back later for new listings',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Refresh is handled automatically by Riverpod stream
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: availableBooks.length,
              itemBuilder: (context, index) {
                final book = availableBooks[index];
                return BookCard(
                  book: book,
                  onSwap: () => _showSwapDialog(context, ref, book),
                  showSwapButton: true,
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 60,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading books',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show swap confirmation dialog
  void _showSwapDialog(BuildContext context, WidgetRef ref, book) {
    final currentUser = ref.read(currentUserProvider);
    
    if (currentUser == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Swap'),
        content: Text(
          'Do you want to request a swap for "${book.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final swapNotifier = ref.read(swapNotifierProvider.notifier);
              final bookNotifier = ref.read(bookNotifierProvider.notifier);
              
              // Create swap
              final swap = await swapNotifier.createSwap(
                bookId: book.id,
                bookTitle: book.title,
                senderId: currentUser.id,
                senderEmail: currentUser.email,
                receiverId: book.ownerId,
                receiverEmail: book.ownerEmail,
              );
              
              if (swap != null) {
                // Update book availability
                await bookNotifier.updateBookAvailability(book.id, false);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Swap request sent!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
            ),
            child: const Text('Request Swap'),
          ),
        ],
      ),
    );
  }
}