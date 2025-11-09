import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

/// Utility class for image handling and base64 conversion
class ImageUtils {
  static final ImagePicker _picker = ImagePicker();
  
  /// Pick an image from gallery and convert to base64
  static Future<String?> pickImageAsBase64() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image == null) return null;
      
      final bytes = await image.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }
  
  /// Convert base64 string to Uint8List for display
  static Uint8List? base64ToImage(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;
    
    try {
      return base64Decode(base64String);
    } catch (e) {
      print('Error decoding base64: $e');
      return null;
    }
  }
  
  /// Get a placeholder image as base64
  static String getPlaceholderBase64() {
    // Small 1x1 gray pixel as placeholder
    return 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==';
  }
}