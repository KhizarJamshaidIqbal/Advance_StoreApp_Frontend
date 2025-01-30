import 'package:flutter/material.dart';
import 'package:store_app/utils/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeepLinkingService {
  static Future<void> handleIncomingLink(
      String link, BuildContext context) async {
    try {
      debugPrint('Handling incoming link: $link');
      final uri = Uri.parse(link);

      String? productId;

      // Handle custom scheme: jinnahent.free.nf
      if (uri.scheme == 'jinnahent.free.nf') {
        final segments = uri.pathSegments;
        if (segments.length >= 2 && segments[0] == 'product') {
          productId = segments[1];
        } else if (segments.length == 1) {
          // Handle case where ID might be the only segment
          productId = segments[0];
        }
      }
      // Handle web URLs: https://dfile-99af8.web.app/product/[id]
      else if (uri.scheme == 'https' && uri.host == 'dfile-99af8.web.app') {
        final segments = uri.pathSegments;
        if (segments.length >= 2 && segments[0] == 'product') {
          productId = segments[1];
        }
      }

      debugPrint('Extracted productId: $productId');

      if (productId != null) {
        await _navigateToProduct(context, productId);
      } else {
        debugPrint('No product ID found in link');

        CustomSnackBar.showError(context, 'Invalid product link');
      }
    } catch (e) {
      debugPrint('Error handling deep link: $e');

      CustomSnackBar.showError(context, 'Error opening link: $e');
    }
  }

  static Future<void> _navigateToProduct(
      BuildContext context, String productId) async {
    try {
      // Get product data from Firestore
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (!productDoc.exists) {
        debugPrint('Product not found: $productId');

        CustomSnackBar.showError(context, 'Product not found');
        return;
      }

      if (!context.mounted) return;

      // Navigate to product details
      Navigator.pushNamed(
        context,
        '/product-details',
        arguments: {
          'productId': productId,
          'data': productDoc.data(),
        },
      );
    } catch (e) {
      debugPrint('Error navigating to product: $e');
      if (context.mounted) {
        CustomSnackBar.showError(context, 'Error loading product');
      }
    }
  }

  static Future<void> openLink(String productId) async {
    try {
      // Try custom scheme first
      final appUri = Uri.parse('dfile-99af8.web.app/product/$productId');
      if (await canLaunchUrl(appUri)) {
        debugPrint('Launching app URI: $appUri');
        await launchUrl(
          appUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback to web URL
        final webUri =
            Uri.parse('https://dfile-99af8.web.app/product/$productId');
        debugPrint('Launching web URI: $webUri');
        await launchUrl(
          webUri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      debugPrint('Error opening link: $e');
    }
  }
}
