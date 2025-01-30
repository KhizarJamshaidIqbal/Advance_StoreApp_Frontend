// ignore_for_file: dead_code, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/main.dart';
import 'package:store_app/routes/routes.dart';
import 'package:store_app/utils/custom_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lottie/lottie.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  final _formKey = GlobalKey<FormState>();
  File? _image;
  bool _isEditing = false;
  bool _isLoading = true;
  String? _profileImageUrl;

  // Controllers for text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  Future<void> _loadUserData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final userData =
          await _firestore.collection('users').doc(user?.uid).get();
      if (userData.exists) {
        final data = userData.data() as Map<String, dynamic>;
        _firstNameController.text = data['firstName'] ?? '';
        _lastNameController.text = data['lastName'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phoneNumber'] ?? '';
        _addressLine1Controller.text = data['address'] ?? '';
        _addressLine2Controller.text = data['addressLine2'] ?? '';
        _cityController.text = data['city'] ?? '';
        _countryController.text = data['country'] ?? '';
        _zipCodeController.text = data['zipCode'] ?? '';
        _profileImageUrl = data['profilePicture'];
      }
    } catch (e) {
      _showErrorSnackBar('Error loading user data');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error picking image');
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      String? imageUrl = _profileImageUrl;
      if (_image != null) {
        final ref = _storage.ref().child('profile_images/${user?.uid}');
        await ref.putFile(_image!);
        imageUrl = await ref.getDownloadURL();
      }

      await _firestore.collection('users').doc(user?.uid).update({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'phoneNumber': _phoneController.text,
        'address': _addressLine1Controller.text,
        'addressLine2': _addressLine2Controller.text,
        'city': _cityController.text,
        'country': _countryController.text,
        'zipCode': _zipCodeController.text,
        if (imageUrl != null) 'profilePicture': imageUrl,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      setState(() {
        _isEditing = false;
        _profileImageUrl = imageUrl;
      });

      if (mounted) {
        CustomSnackBar.showSuccess(context, 'Profile updated successfully');
      }
    } catch (e) {
      _showErrorSnackBar('Error updating profile');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    CustomSnackBar.showError(context, message);
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Lottie.asset(
                  'assets/animations/Loading.json',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Loading Profile...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  _updateProfile();
                } else {
                  _isEditing = true;
                }
              });
            },
            icon: Icon(
              _isEditing ? Icons.save : Icons.edit,
              color: Colors.green,
            ),
            label: Text(
              _isEditing ? 'Save' : 'Edit',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Picture Section
                Container(
                  height: 200,
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
                  child: Center(
                    child: Stack(
                      children: [
                        Hero(
                          tag: 'profile_image',
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: _getProfileImage(),
                            child: _getProfileImage() == null
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: _pickImage,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              '${_firstNameController.text} ${_lastNameController.text}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _emailController.text,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Personal Information Section
                      _buildSectionHeader('Personal Information'),
                      _buildTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        enabled: _isEditing,
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        enabled: _isEditing,
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),

                      // Contact Information Section
                      _buildSectionHeader('Contact Information'),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        enabled: false,
                        prefixIcon: Icons.email_outlined,
                        suffixIcon: _buildVerificationBadge(),
                      ),
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        enabled: _isEditing,
                        prefixIcon: Icons.phone_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),

                      // Address Section
                      _buildSectionHeader('Address'),
                      _buildTextField(
                        controller: _addressLine1Controller,
                        label: 'Address Line 1',
                        enabled: _isEditing,
                        prefixIcon: Icons.location_on_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _addressLine2Controller,
                        label: 'Address Line 2 (Optional)',
                        enabled: _isEditing,
                        prefixIcon: Icons.location_on_outlined,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _cityController,
                              label: 'City',
                              enabled: _isEditing,
                              prefixIcon: Icons.location_city_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your city';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _zipCodeController,
                              label: 'ZIP Code',
                              enabled: _isEditing,
                              prefixIcon: Icons.pin_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter ZIP code';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      _buildTextField(
                        controller: _countryController,
                        label: 'Country',
                        enabled: _isEditing,
                        prefixIcon: Icons.public_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your country';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),

                      if (!_isEditing)
                        Center(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Account'),
                                  content: const Text(
                                    'Are you sure you want to delete your account? This action cannot be undone.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // TODO: Implement delete account
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            label: const Text('Delete Account'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
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
      ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (_image != null) {
      return FileImage(_image!);
    } else if (_profileImageUrl != null) {
      return NetworkImage(_profileImageUrl!);
    }
    return null;
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool enabled,
    required IconData prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: enabled ? Colors.green : Colors.grey,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: enabled ? Colors.green : Colors.grey,
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.green, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          filled: !enabled,
          fillColor: enabled ? Colors.transparent : Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildVerificationBadge() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        final isVerified = snapshot.hasData &&
            (snapshot.data?.get('isEmailVerified') == true ||
                FirebaseAuth.instance.currentUser?.emailVerified == true);

        return InkWell(
          onTap: () async {
            if (!isVerified) {
              await Navigator.pushNamed(context, Routes.emailVerification);
              // Refresh both Firebase Auth and Firestore status
              await FirebaseAuth.instance.currentUser?.reload();
              if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .update({'isEmailVerified': true});
              }
              setState(() {});
            }
          },
          child: Tooltip(
            message: isVerified ? 'Email Verified' : 'Email Not Verified',
            child: Icon(
              isVerified ? Icons.verified : Icons.error_outline,
              color: isVerified ? Colors.green : Colors.orange,
            ),
          ),
        );
      },
    );
  }
}
