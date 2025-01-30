import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addToCart(Map<String, dynamic> product) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Validate required fields
      if (product['id'] == null) {
        throw Exception('Product ID is required');
      }
      if (product['name'] == null) {
        throw Exception('Product name is required');
      }
      if (product['price'] == null) {
        throw Exception('Product price is required');
      }

      final cartRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart');

      // Check if product already exists in cart
      final existingItem = await cartRef
          .where('productId', isEqualTo: product['id'])
          .get();

      if (existingItem.docs.isNotEmpty) {
        // Update quantity
        final doc = existingItem.docs.first;
        await cartRef.doc(doc.id).update({
          'quantity': FieldValue.increment(1),
        });
      } else {
        // Add new item
        final cartItem = CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: product['id'],
          name: product['name'],
          price: (product['price'] as num).toDouble(),
          imageUrl: product['imageUrl'] ?? 'assets/images/placeholder.jpg',
        );

        await cartRef.doc(cartItem.id).set(cartItem.toMap());
      }
    } catch (e) {
      throw Exception('Failed to add item to cart: $e');
    }
  }

  Future<List<CartItem>> getCartItems() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();

      return snapshot.docs
          .map((doc) => CartItem.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get cart items: $e');
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(cartItemId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove item from cart: $e');
    }
  }

  Future<void> updateQuantity(String cartItemId, int quantity) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      if (quantity <= 0) {
        await removeFromCart(cartItemId);
      } else {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(cartItemId)
            .update({'quantity': quantity});
      }
    } catch (e) {
      throw Exception('Failed to update quantity: $e');
    }
  }
}
