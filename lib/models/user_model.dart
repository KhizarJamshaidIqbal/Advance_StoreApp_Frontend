// user_model.dart
class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String address; // Address Line 1
  final String? addressLine2; // Address Line 2 (optional)
  final String zipCode;
  final String city;
  final String country;
  String? profilePicture;
  final double? latitude;
  final double? longitude;
  final bool isEmailVerified;
  // final String role; // Added role field
  String? fcmToken; // Added FCM token field

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.addressLine2,
    required this.zipCode,
    required this.city,
    required this.country,
    this.profilePicture,
    this.latitude,
    this.longitude,
    this.isEmailVerified = false,
    // this.role = 'user', // Default role is user
    this.fcmToken, // Added FCM token parameter
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'addressLine2': addressLine2,
      'zipCode': zipCode,
      'city': city,
      'country': country,
      'profilePicture': profilePicture,
      'latitude': latitude,
      'longitude': longitude,
      'isEmailVerified': isEmailVerified,
      // 'role': role,
      'fcmToken': fcmToken, // Added FCM token to map
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      addressLine2: map['addressLine2'],
      zipCode: map['zipCode'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      profilePicture: map['profilePicture'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      isEmailVerified: map['isEmailVerified'] ?? false,
      // role: map['role'] ?? 'user',
      fcmToken: map['fcmToken'], // Added FCM token to fromMap
    );
  }
}
