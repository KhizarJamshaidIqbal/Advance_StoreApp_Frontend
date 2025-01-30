// ignore_for_file: deprecated_member_use, unused_field

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/user/Screens/cart_screens/checkout_screen.dart';
import 'package:store_app/user/share/custom_bottom_navigation_bar.dart';
import 'package:store_app/user/widgets/ar_view_button.dart';
import 'package:store_app/user/widgets/ar_view_widget.dart';
import 'package:store_app/utils/custom_snackbar.dart';
import 'package:store_app/widgets/cached_network_image_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final String productId;

  const ProductDetailsScreen({
    Key? key,
    required this.product,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  bool _isFavorite = false;
  bool _isLoading = true;
  bool _isProcessing = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _initializeWishlistStatus();
  }

  Future<void> _initializeWishlistStatus() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final isInWishlist = await _checkIfInWishlist();
      if (mounted) {
        setState(() {
          _isFavorite = isInWishlist;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error initializing wishlist status: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> _checkIfInWishlist() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        debugPrint('User not logged in');
        return false;
      }

      final wishlistDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .where('productId', isEqualTo: widget.productId)
          .get();

      return wishlistDoc.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking wishlist: $e');
      return false;
    }
  }

  Future<void> _toggleWishlist() async {
    final user = _auth.currentUser;
    if (user == null) {
      CustomSnackBar.showLoginRequired(context);
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final wishlistRef = userRef.collection('wishlist');

      // Check if product is already in wishlist
      final wishlistDoc = await wishlistRef
          .where('productId', isEqualTo: widget.productId)
          .get();

      if (wishlistDoc.docs.isEmpty) {
        // Add to wishlist
        await wishlistRef.add({
          'productId': widget.productId,
          'name': widget.product['name'],
          'price': widget.product['price'],
          'imageUrl': widget.product['imageUrl'],
          'category': widget.product['category'],
          'addedAt': FieldValue.serverTimestamp(),
        });
        if (mounted) {
          CustomSnackBar.showWishlistAdded(
            context,
            onViewWishlist: () {
              CustomBottomNavigationBar.switchToWishlistFromOutside(context);
            },
          );
        }
      } else {
        // Remove from wishlist
        await wishlistDoc.docs.first.reference.delete();
        if (mounted) {
          CustomSnackBar.showWishlistRemoved(
            context,
            onUndo: () async {
              try {
                await wishlistRef.add({
                  'productId': widget.productId,
                  'name': widget.product['name'],
                  'price': widget.product['price'],
                  'imageUrl': widget.product['imageUrl'],
                  'category': widget.product['category'],
                  'addedAt': FieldValue.serverTimestamp(),
                });
                if (mounted) {
                  CustomSnackBar.showSuccess(
                      context, 'Item restored to wishlist');
                }
              } catch (e) {
                if (mounted) {
                  CustomSnackBar.showError(context, 'Failed to restore item');
                }
              }
            },
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, 'Failed to update wishlist');
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _addToCart() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      CustomSnackBar.showLoginRequired(context);
      return;
    }

    setState(() => _isLoading = true);

    try {
      setState(() => _isProcessing = true);

      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart');

      // Check if product already exists in cart
      final existingItem = await cartRef
          .where('productId',
              isEqualTo: widget.product['productId'] ?? widget.product['id'])
          .get();

      if (existingItem.docs.isNotEmpty) {
        // Update quantity
        final doc = existingItem.docs.first;
        await cartRef.doc(doc.id).update({
          'quantity': FieldValue.increment(_quantity),
        });
      } else {
        // Add new item
        await cartRef.add({
          'productId': widget.product['productId'] ?? widget.product['id'],
          'name': widget.product['name'],
          'price': widget.product['price'],
          'imageUrl': widget.product['imageUrl'],
          'quantity': _quantity,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }

      if (mounted) {
        setState(() => _isLoading = false);
        setState(() => _isProcessing = false);
        CustomSnackBar.showCartAdded(
          context,
          onViewCart: () {
            Navigator.pushNamed(context, '/cart');
          },
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        setState(() => _isProcessing = false);
        CustomSnackBar.showError(
            context, 'Failed to add to cart. Please try again.');
      }
    }
  }

  Future<void> _buyNow() async {
    try {
      setState(() {
        _isProcessing = true;
      });

      // Create cart item from current product
      final cartItem = {
        ...widget.product,
        'quantity': _quantity,
        'totalPrice': (widget.product['price'] as num) * _quantity,
      };

      // Calculate total amount
      final totalAmount =
          (widget.product['price'] as num) * _quantity.toDouble();

      // Navigate to checkout screen with the single item
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutScreen(
              cartItems: [cartItem],
              totalAmount: totalAmount,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, 'Error processing buy now: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.product.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('Product not found'),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // App Bar with Image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(_auth.currentUser?.uid)
                        .collection('wishlist')
                        .where('productId', isEqualTo: widget.productId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final isInWishlist =
                          snapshot.hasData && snapshot.data!.docs.isNotEmpty;

                      return IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: _isProcessing
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  isInWishlist
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      isInWishlist ? Colors.red : Colors.black,
                                  size: 20,
                                ),
                        ),
                        onPressed: _isProcessing ? null : _toggleWishlist,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: widget.product['imageUrl'] != null
                      ? CachedNetworkImageWidget(
                          imageUrl: widget.product['imageUrl'],
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.fastfood,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),

              // Product Details
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.product['name'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                            Text(
                              '${widget.product['price']} PKR',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product['description'] ??
                              'No description available',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 24),
                        // Ingredients
                        const Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product['ingredients'] ??
                              'No ingredients listed',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 24),
                        // Quantity
                        Row(
                          children: [
                            const Text(
                              'Quantity',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      if (_quantity > 1) {
                                        setState(() {
                                          _quantity--;
                                        });
                                      }
                                    },
                                  ),
                                  Text(
                                    _quantity.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        _quantity++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 150), // Space for bottom bar
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 3),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (_quantity > 1) {
                                setState(() => _quantity--);
                              }
                            },
                          ),
                          Text(
                            '$_quantity',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() => _quantity++);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                _isLoading || _isProcessing ? null : _buyNow,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading || _isProcessing
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Buy Now',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                _isLoading || _isProcessing ? null : _addToCart,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading || _isProcessing
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Add to Cart',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 20,
            child: ModernARButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ARViewWidget(
                      alt: '',
                      modelUrl: 'assets/images/old_chair.glb',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
