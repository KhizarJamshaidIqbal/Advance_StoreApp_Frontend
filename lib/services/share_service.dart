import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';

class ShareService {
  static const String _webDomain = 'dfile-99af8.web.app';
  static const String _appScheme = 'jinnahent';

  static Future<void> shareProduct({
    required String productId,
    required String productName,
    String? description,
    String? imageUrl,
  }) async {
    try {
      if (imageUrl != null && imageUrl.isNotEmpty) {
        // Download the image
        final response = await http.get(Uri.parse(imageUrl), headers: {
          'Accept': 'image/*',
        });

        if (response.statusCode == 200) {
          // Get the content type from headers or detect from bytes
          String? contentType = response.headers['content-type'];
          if (contentType == null || !contentType.startsWith('image/')) {
            contentType = lookupMimeType('', headerBytes: response.bodyBytes);
          }

          // Ensure we're dealing with an image
          if (contentType == null || !contentType.startsWith('image/')) {
            throw Exception('Invalid image format');
          }

          // Get appropriate file extension
          String fileExtension;
          switch (contentType) {
            case 'image/jpeg':
            case 'image/jpg':
              fileExtension = '.jpg';
              break;
            case 'image/png':
              fileExtension = '.png';
              break;
            case 'image/gif':
              fileExtension = '.gif';
              break;
            case 'image/webp':
              fileExtension = '.webp';
              break;
            default:
              fileExtension = '.jpg'; // default to jpg
          }

          // Get temporary directory
          final tempDir = await getTemporaryDirectory();
          final fileName =
              'product_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
          final file = File('${tempDir.path}/$fileName');

          // Write the image to temporary file
          await file.writeAsBytes(response.bodyBytes);

          // Prepare share text with deep link
          final shareText = _buildShareText(productId, productName, description);

          // Share with proper MIME type
          await Share.shareXFiles(
            [
              XFile(
                file.path,
                mimeType: contentType,
                name: fileName,
              )
            ],
            text: shareText,
            subject: productName,
          );
          return;
        }
      }

      // Fallback to text-only sharing
      final shareText = _buildShareText(productId, productName, description);
      await Share.share(shareText);
    } catch (e) {
      print('Error sharing product: $e');
      // Fallback to basic sharing if anything fails
      final shareText = _buildShareText(productId, productName, description);
      await Share.share(shareText);
    }
  }

  static String _buildShareText(
      String productId, String productName, String? description) {
    final appLink = '$_appScheme://product/$productId';
    final webLink = 'https://$_webDomain/product/$productId';

    String shareText = 'Check out $productName!\n\n';

    if (description != null && description.isNotEmpty) {
      shareText += '$description\n\n';
    }

    shareText += 'Open in app: $appLink\n';
    shareText += 'Or visit: $webLink';

    return shareText;
  }
}
