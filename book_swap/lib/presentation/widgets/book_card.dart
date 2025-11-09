import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/image_utils.dart';
import '../../domain/entities/book.dart';

/// Book card widget for displaying book information
class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onSwap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showSwapButton;
  final bool showEditDelete;

  const BookCard({
    super.key,
    required this.book,
    this.onSwap,
    this.onEdit,
    this.onDelete,
    this.showSwapButton = false,
    this.showEditDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book cover
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: book.imageBase64 != null
                  ? Image.memory(
                      ImageUtils.base64ToImage(book.imageBase64)!,
                      width: 80,
                      height: 120,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 80,
                      height: 120,
                      color: AppColors.primary,
                      child: const Icon(
                        Icons.menu_book,
                        color: AppColors.secondary,
                        size: 40,
                      ),
                    ),
            ),
            
            const SizedBox(width: 12),
            
            // Book details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Author
                  Text(
                    'By ${book.author}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Condition badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getConditionColor(book.condition).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      book.condition,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _getConditionColor(book.condition),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Swap for
                  if (book.swapFor != null && book.swapFor!.isNotEmpty)
                    Text(
                      'Swap for: ${book.swapFor}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  
                  const SizedBox(height: 4),
                  
                  // Posted date
                  Text(
                    _formatDate(book.createdAt),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textLight,
                    ),
                  ),
                  
                  // Availability status
                  if (!book.isAvailable) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Pending Swap',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                  
                  // Action buttons
                  if (showSwapButton || showEditDelete) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (showSwapButton && book.isAvailable)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onSwap,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary,
                                foregroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Swap',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        
                        if (showEditDelete) ...[
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: onEdit,
                              icon: const Icon(Icons.edit, size: 16),
                              label: const Text('Edit'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                side: const BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete_outline),
                            color: AppColors.error,
                            iconSize: 20,
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get color based on condition
  Color _getConditionColor(String condition) {
    switch (condition) {
      case 'New':
        return AppColors.conditionNew;
      case 'Like New':
        return AppColors.conditionLikeNew;
      case 'Good':
        return AppColors.conditionGood;
      case 'Used':
        return AppColors.conditionUsed;
      default:
        return AppColors.textSecondary;
    }
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}