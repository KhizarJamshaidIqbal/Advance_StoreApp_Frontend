import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();
  List<CartItem> _items = [];
  bool _isLoading = false;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  Future<void> loadCartItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _cartService.getCartItems();
    } catch (e) {
      print('Error loading cart items: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addToCart(Map<String, dynamic> product) async {
    try {
      await _cartService.addToCart(product);
      await loadCartItems(); // Reload cart items to update the UI
    } catch (e) {
      print('Error adding item to cart: $e');
      rethrow;
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _cartService.removeFromCart(cartItemId);
      await loadCartItems();
    } catch (e) {
      print('Error removing item from cart: $e');
      rethrow;
    }
  }

  Future<void> updateQuantity(String cartItemId, int quantity) async {
    try {
      await _cartService.updateQuantity(cartItemId, quantity);
      await loadCartItems();
    } catch (e) {
      print('Error updating quantity: $e');
      rethrow;
    }
  }

  // Listen to cart changes in real-time
  void startListeningToCartChanges() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .snapshots()
          .listen((snapshot) {
        try {
          _items = snapshot.docs.map((doc) {
            try {
              final data = doc.data();
              // Add the document ID to the data
              data['id'] = doc.id;
              return CartItem.fromMap(data);
            } catch (e) {
              debugPrint('Error parsing cart item: $e');
              return null;
            }
          }).whereType<CartItem>().toList(); // Filter out null items
          notifyListeners();
        } catch (e) {
          debugPrint('Error loading cart items: $e');
          _items = [];
          notifyListeners();
        }
      });
    }
  }
}
