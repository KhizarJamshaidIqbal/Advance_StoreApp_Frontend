// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unused_import

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/auth/auth_service.dart';
import 'package:store_app/main.dart';
import 'package:store_app/models/user_model.dart';
import 'package:store_app/user/share/custom_bottom_navigation_bar.dart';
import 'package:store_app/routes/routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, User? user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const ModernDrawerHeader(),
          _buildListTile(
            context,
            icon: Icons.home_outlined,
            title: 'Home',
            onTap: () {
              Navigator.pushNamed(context, Routes.customBottomNavigationBar);
            },
          ),
          // _buildListTile(
          //   context,
          //   icon: Icons.person_outline,
          //   title: 'Profile',
          //   onTap: () {
          //     Navigator.pushNamed(context, Routes.profile);
          //   },
          // ),
          _buildListTile(
            context,
            icon: Icons.favorite_outline,
            title: 'Wishlist',
            onTap: () {
              CustomBottomNavigationBar.switchToWishlistFromOutside(context);
            },
          ),
          _buildListTile(
            context,
            icon: Icons.receipt_outlined,
            title: 'My Reservations',
            onTap: () {
              CustomBottomNavigationBar.switchToReservationsFromOutside(
                  context);
            },
          ),
          _buildListTile(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              Navigator.pushNamed(context, Routes.settings);
            },
          ),
          _buildListTile(
            context,
            icon: Icons.logout,
            title: 'Sign Out',
            onTap: () async {
              await AuthService().signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.signIn,
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}

class ModernDrawerHeader extends StatefulWidget {
  const ModernDrawerHeader({super.key});

  @override
  State<ModernDrawerHeader> createState() => _ModernDrawerHeaderState();
}

class _ModernDrawerHeaderState extends State<ModernDrawerHeader> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String _userName = '';
  String _userEmail = '';
  String? _profileImageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userData =
            await _firestore.collection('users').doc(user.uid).get();
        if (userData.exists) {
          final data = userData.data() as Map<String, dynamic>;
          if (mounted) {
            setState(() {
              _userName =
                  '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim();
              _userEmail = data['email'] ?? '';
              _profileImageUrl = data['profilePicture'];
              _isLoading = false;
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green.withOpacity(0.2),
            Colors.white,
          ],
        ),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, Routes.profile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'drawer_profile_image',
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : null,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.green,
                            ),
                          )
                        : _profileImageUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 35,
                                color: Colors.grey,
                              )
                            : null,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isLoading
                            ? 'Loading...'
                            : (_userName.isNotEmpty ? _userName : 'User'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isLoading ? '' : _userEmail,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
