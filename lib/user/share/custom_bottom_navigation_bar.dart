// ignore_for_file: library_private_types_in_public_api, unused_element, unused_field, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_app/main.dart';
import 'package:store_app/routes/routes.dart';
import 'package:store_app/services/notification_service.dart';
import 'package:store_app/user/Screens/explore_screens/explore_screen.dart';
import 'package:store_app/user/Screens/home_screens/home_screen.dart';
import 'package:store_app/user/Screens/order_screens/order_screen.dart';
import 'package:store_app/user/Screens/reservation_screens/my_reservations_screen.dart';
import 'package:store_app/user/Screens/videos_player_screen/video_list_screen.dart';
import 'package:store_app/user/Screens/whislist_screen/whislist_screen.dart';
import 'package:store_app/widgets/custom_appbar.dart';
import 'package:store_app/widgets/custom_drawer.dart';
import 'package:store_app/widgets/custom_floating_chat_button.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_provider.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int initialIndex;
  final Map<String, dynamic>? exploreArguments;

  const CustomBottomNavigationBar({
    Key? key,
    this.initialIndex = 0,
    this.exploreArguments,
  }) : super(key: key);

  static void switchToExplore(BuildContext context) {
    final state =
        context.findAncestorStateOfType<_CustomBottomNavigationBarState>();
    if (state != null) {
      state._switchToExploreScreen();
    }
  }

  static void switchToExploreFromOutside(BuildContext context,
      {String? category}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomBottomNavigationBar(
          initialIndex: 1,
          exploreArguments: category != null ? {'category': category} : null,
        ),
      ),
    );
  }

  static void switchToWishlistFromOutside(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CustomBottomNavigationBar(
          initialIndex: 2,
        ),
      ),
    );
  }

  static void switchToReservationsFromOutside(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CustomBottomNavigationBar(
          initialIndex: 3,
        ),
      ),
    );
  }

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _updateFCMToken();
    _notificationinit();
    _selectedIndex = widget.initialIndex;
    // Start listening to cart changes
    Provider.of<CartProvider>(context, listen: false)
        .startListeningToCartChanges();
  }

  Future<void> _notificationinit() async {
    await NotificationService.localNotiInit();
    await NotificationService.firebaseInit();
  }

  Future<void> _updateFCMToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get the current FCM token
        String? fcmToken = await NotificationService.getDeviceToken();

        // Get the user document
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final currentToken = userDoc.data()?['fcmToken'];

          // Update token if it doesn't exist or has changed
          if (currentToken != fcmToken) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({'fcmToken': fcmToken});
            print('FCM Token updated successfully');
          }
        } else {
          print('User document not found');
        }
      }
    } catch (e) {
      print('Error updating FCM token: $e');
    }
  }

  void _switchToExploreScreen() {
    if (mounted && _selectedIndex != 1) {
      setState(() {
        _selectedIndex = 1;
      });
    }
  }

  void _onItemTapped(int index) {
    if (mounted && _selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return ExploreScreen(
          onExploreMenue: () => _switchToExploreScreen(),
          selectedCategory: widget.exploreArguments?['category'],
        );
      case 2:
        return const WishlistScreen();
      case 3:
        return const MyReservationsScreen();
      case 4:
        return const OrderScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _getAppBarTitle(),
        onProfilePressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VideoListScreen()),
          );
        },
        onCartPressed: () {
          Navigator.pushNamed(context, Routes.cart);
        },
      ),
      drawer: CustomDrawer(user: _auth.currentUser),
      floatingActionButton: _selectedIndex == 0
          ? CustomFloatingChatButton(
              onPressed: () {
                //TODO: Add your chat functionality here
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: _buildPage(_selectedIndex),
      bottomNavigationBar: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .collection('wishlist')
            .snapshots(),
        builder: (context, snapshot) {
          int wishlistCount = snapshot.hasData ? snapshot.data!.docs.length : 0;

          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.favorite),
                    if (wishlistCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '$wishlistCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Wishlist',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                label: 'Reservations',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.receipt),
                label: 'Orders',
              ),
            ],
          );
        },
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Jinnah Ent';
      case 1:
        return 'Explore Menu';
      case 2:
        return 'Wishlist';
      case 3:
        return 'Reservations';
      case 4:
        return 'Orders';
      default:
        return 'Jinnah Ent';
    }
  }
}
