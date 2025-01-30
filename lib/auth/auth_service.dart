// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/services/notification_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up
  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
    String? addressLine2,
    required String zipCode,
    required String city,
    required String country,
    double? latitude,
    double? longitude,
  }) async {
    try {
      // Create user with email and password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get FCM token
      String? fcmToken = await NotificationService.getDeviceToken();

      // Create user data map
      final Map<String, dynamic> userData = {
        'uid': userCredential.user!.uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'address': address,
        'addressLine2': addressLine2,
        'zipCode': zipCode,
        'city': city,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
        'fcmToken': fcmToken, // Add FCM token here
        // 'role': 'user',
        'isEmailVerified': false,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Store user data in Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userData);

      // Send email verification
      await userCredential.user!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered';
          break;
        case 'invalid-email':
          message = 'The email address is invalid';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled';
          break;
        case 'weak-password':
          message = 'The password is too weak';
          break;
        default:
          message = e.message ?? 'An error occurred during sign up';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Failed to create account: ${e.toString()}');
    }
  }

  // Sign In
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('Failed to sign in');

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      final userData = userDoc.data();
      if (userData == null) {
        throw Exception('User data is empty');
      }

      // return userData['role'] as String? ?? 'user';
      return 'user';
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Wrong password provided';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        case 'invalid-email':
          message = 'The email address is invalid';
          break;
        default:
          message = e.message ?? 'An error occurred during sign in';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user and role
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return null;

      final userData = userDoc.data();
      if (userData == null) return null;

      return {
        'uid': user.uid,
        'email': user.email,
        // 'role': userData['role'] ?? 'user',
        ...userData,
      };
    } catch (e) {
      return null;
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      String message = 'Failed to send password reset email';
      if (e.code == 'user-not-found') {
        message = 'No user found with this email';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Failed to reset password: ${e.toString()}');
    }
  }
}
