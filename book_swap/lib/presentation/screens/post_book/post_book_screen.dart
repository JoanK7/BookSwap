import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/image_utils.dart';
import '../../../domain/entities/book.dart';
import '../../providers/book_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/condition_selector.dart';

/// Post book screen for creating/editing book listings
class PostBookScreen extends ConsumerStatefulWidget {
  final Book? bookToEdit;

  const PostBookScreen({super.key, this.bookToEdit});

  @override
  ConsumerState<PostBookScreen> createState() => _PostBookScreenState();
}

class _PostBookScreenState extends ConsumerState<PostBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _swapForController = TextEditingController();
  
  String _selectedCondition = AppStrings.conditionNew;
  String? _imageBase64;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // If editing, populate fields
    if (widget.bookToEdit != null) {
      _titleController.text = widget.bookToEdit!.title;
      _authorController.text = widget.bookToEdit!.author;
      _swapForController.text = widget.bookToEdit!.swapFor ?? '';
      _selectedCondition = widget.bookToEdit!.condition;
      _imageBase64 = widget.bookToEdit!.imageBase64;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _swapForController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final base64 = await ImageUtils.pickImageAsBase64();
    if (base64 != null) {
      setState(() => _imageBase64 = base64);
    }
  }

  Future<void> _submitBook() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) return;

      final bookNotifier = ref.read(bookNotifierProvider.notifier);

      try {
        if (widget.bookToEdit != null) {
          // Update existing book
          final updatedBook = widget.bookToEdit!.copyWith(
            title: _titleController.text.trim(),
            author: _authorController.text.trim(),
            condition: _selectedCondition,
            swapFor: _swapForController.text.trim().isEmpty
                ? null
                : _swapForController.text.trim(),
            imageBase64: _imageBase64,
            updatedAt: DateTime.now(),
          );
          
          await bookNotifier.updateBook(updatedBook);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Book updated successfully'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context);
          }
        } else {
          // Create new book
          await bookNotifier.createBook(
            title: _titleController.text.trim(),
            author: _authorController.text.trim(),
            condition: _selectedCondition,
            swapFor: _swapForController.text.trim().isEmpty
                ? null
                : _swapForController.text.trim(),
            imageBase64: _imageBase64,
            ownerId: currentUser.id,
            ownerEmail: currentUser.email,
          );
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Book posted successfully'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookToEdit != null ? 'Edit Book' : AppStrings.postABook),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: _imageBase64 != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            ImageUtils.base64ToImage(_imageBase64)!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to add book cover',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Book title
              CustomTextField(
                label: AppStrings.bookTitle,
                controller: _titleController,
                validator: (value) => Validators.validateRequired(value, 'Book title'),
              ),
              
              const SizedBox(height: 20),
              
              // Author
              CustomTextField(
                label: AppStrings.author,
                controller: _authorController,
                validator: (value) => Validators.validateRequired(value, 'Author'),
              ),
              
              const SizedBox(height: 20),
              
              // Condition selector
              ConditionSelector(
                selectedCondition: _selectedCondition,
                onConditionSelected: (condition) {
                  setState(() => _selectedCondition = condition);
                },
              ),
              
              const SizedBox(height: 20),
              
              // Swap for (optional)
              CustomTextField(
                label: '${AppStrings.swapFor} (Optional)',
                controller: _swapForController,
                hintText: 'e.g., Database Systems',
              ),
              
              const SizedBox(height: 32),
              
              // Submit button
              CustomButton(
                text: widget.bookToEdit != null ? 'Update' : AppStrings.post,
                onPressed: _submitBook,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}