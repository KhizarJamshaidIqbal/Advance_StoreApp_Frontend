// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/main.dart';
import 'package:store_app/utils/custom_snackbar.dart';
import 'package:store_app/user/share/custom_bottom_navigation_bar.dart';
import 'package:store_app/widgets/custom_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/widgets/cached_network_image_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_app/routes/routes.dart';

class ExploreScreen extends StatefulWidget {
  final Function? onExploreMenue;
  final String? selectedCategory;

  const ExploreScreen({
    super.key,
    this.onExploreMenue,
    this.selectedCategory,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TabController? _tabController;
  String? selectedCategory;
  List<String> _categories = ['All'];
  bool _isLoading = false;
  String _searchQuery = '';
  bool _isProcessing = false;

  Future<void> _toggleWishlist(Map<String, dynamic> product) async {
    final user = _auth.currentUser;
    if (user == null) {
      CustomSnackBar.showLoginRequired(context);
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('wishlist');

      final wishlistQuery =
          await userRef.where('productId', isEqualTo: product['id']).get();

      if (wishlistQuery.docs.isEmpty) {
        // Add to wishlist
        await userRef.add({
          'productId': product['id'],
          'name': product['name'],
          'price': product['price'],
          'imageUrl': product['imageUrl'],
          'category': product['category'],
          'addedAt': DateTime.now(),
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
        await wishlistQuery.docs.first.reference.delete();

        if (mounted) {
          CustomSnackBar.showWishlistRemoved(
            context,
            onUndo: () async {
              try {
                await userRef.add({
                  'productId': product['id'],
                  'name': product['name'],
                  'price': product['price'],
                  'imageUrl': product['imageUrl'],
                  'category': product['category'],
                  'addedAt': DateTime.now(),
                });
              } catch (e) {
                CustomSnackBar.showError(context, 'Error undoing action: $e');
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

  // Filter states
  RangeValues _priceRange = const RangeValues(0, 10000); // PKR
  String _sortBy = 'name'; // 'name', 'price_low_high', 'price_high_low'
  bool _onlyAvailable = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    // Start listening to cart changes
    Provider.of<CartProvider>(context, listen: false)
        .startListeningToCartChanges();
  }

  Future<void> _fetchCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .orderBy('createdAt', descending: true)
          .get();

      final categories = snapshot.docs.map((doc) {
        final data = doc.data();
        return data['name'] as String;
      }).toList();

      if (mounted) {
        setState(() {
          _categories = ['All', ...categories];
          _initializeTabController();

          // Handle selected category from widget
          if (widget.selectedCategory != null) {
            final index = _categories.indexOf(widget.selectedCategory!);
            if (index != -1 && _tabController != null) {
              _tabController!.animateTo(index);
            }
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Error fetching categories: $e');
    }
  }

  void _initializeTabController() {
    _tabController?.dispose();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search and Filter Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ModernSearchBar(
                      onSearch: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      onPressed: () {
                        _showFilterBottomSheet(context);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Categories Tab Bar
            if (_tabController != null)
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicator: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  tabs: _categories
                      .map((category) => Tab(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(category),
                            ),
                          ))
                      .toList(),
                ),
              ),

            // Tab Bar View
            if (_tabController != null)
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _categories.map((category) {
                    return _buildFoodGrid(category);
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodGrid(String category) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where(category == 'All' ? 'isAvailable' : 'category',
              isEqualTo: category == 'All' ? true : category)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        // Apply filters
        var filteredDocs = docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;

          // Search filter
          final name = (data['name'] as String? ?? '').toLowerCase();
          final description =
              (data['description'] as String? ?? '').toLowerCase();
          final searchLower = _searchQuery.toLowerCase();
          final matchesSearch =
              name.contains(searchLower) || description.contains(searchLower);

          // Price filter
          final price = (data['price'] as num?)?.toDouble() ?? 0;
          final matchesPrice =
              price >= _priceRange.start && price <= _priceRange.end;

          // Availability filter
          final isAvailable = data['isAvailable'] as bool? ?? false;
          final matchesAvailability = !_onlyAvailable || isAvailable;

          return matchesSearch && matchesPrice && matchesAvailability;
        }).toList();

        // Apply sorting
        filteredDocs.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;

          switch (_sortBy) {
            case 'name':
              return (aData['name'] as String? ?? '')
                  .compareTo(bData['name'] as String? ?? '');
            case 'price_low_high':
              return (aData['price'] as num? ?? 0)
                  .compareTo(bData['price'] as num? ?? 0);
            case 'price_high_low':
              return (bData['price'] as num? ?? 0)
                  .compareTo(aData['price'] as num? ?? 0);
            default:
              return 0;
          }
        });

        if (filteredDocs.isEmpty) {
          return const Center(
            child: Text('No products found'),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            final data = filteredDocs[index].data() as Map<String, dynamic>;
            final product = {
              ...data,
              'id': filteredDocs[index].id,
            };
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.productDetails,
                    arguments: {
                      ...data,
                      'productId': filteredDocs[index].id,
                    },
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: product['imageUrl'] != null
                                ? CachedNetworkImageWidget(
                                    imageUrl: product['imageUrl'],
                                    fit: BoxFit.cover,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                  )
                                : Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: Icon(
                                        Icons.fastfood,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          right: 2,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(_auth.currentUser?.uid)
                                .collection('wishlist')
                                .where('productId', isEqualTo: product['id'])
                                .snapshots(),
                            builder: (context, snapshot) {
                              final isInWishlist = snapshot.hasData &&
                                  snapshot.data!.docs.isNotEmpty;

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
                                          color: isInWishlist
                                              ? Colors.red
                                              : Colors.black,
                                          size: 20,
                                        ),
                                ),
                                onPressed: _isProcessing
                                    ? null
                                    : () => _toggleWishlist(product),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product['category'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'PKR ${product['price']?.toStringAsFixed(0) ?? '0.00'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  if (user == null) {
                                    // Show login dialog if user is not authenticated

                                    CustomSnackBar.showLoginRequired(
                                      context,
                                      message: 'Please login to add to cart',
                                    );
                                    return;
                                  }

                                  if (product['isAvailable'] ?? true) {
                                    try {
                                      await Provider.of<CartProvider>(context,
                                              listen: false)
                                          .addToCart(product);

                                      CustomSnackBar.showCartAdded(
                                        context,
                                        onViewCart: () {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.cart,
                                          );
                                        },
                                      );
                                    } catch (e) {
                                      CustomSnackBar.showError(
                                          context, 'Failed to add to cart: $e');
                                    }
                                  } else {
                                    CustomSnackBar.showError(
                                      context,
                                      'Product is out of stock',
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.green,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      Colors.green.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _priceRange = const RangeValues(0, 10000);
                            _sortBy = 'name';
                            _onlyAvailable = true;
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Price Range
                  const Text(
                    'Price Range (PKR)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 10000,
                    divisions: 100,
                    labels: RangeLabels(
                      _priceRange.start.round().toString(),
                      _priceRange.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // Sort By
                  const Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Name'),
                        selected: _sortBy == 'name',
                        onSelected: (bool selected) {
                          setState(() {
                            _sortBy = 'name';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Price: Low to High'),
                        selected: _sortBy == 'price_low_high',
                        onSelected: (bool selected) {
                          setState(() {
                            _sortBy = 'price_low_high';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Price: High to Low'),
                        selected: _sortBy == 'price_high_low',
                        onSelected: (bool selected) {
                          setState(() {
                            _sortBy = 'price_high_low';
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Availability
                  Row(
                    children: [
                      Switch(
                        value: _onlyAvailable,
                        onChanged: (bool value) {
                          setState(() {
                            _onlyAvailable = value;
                          });
                        },
                      ),
                      const Text('Show only available items'),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        this.setState(() {}); // Refresh the main screen
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
