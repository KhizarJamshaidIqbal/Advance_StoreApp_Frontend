import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationModel {
  final String? id;
  final String userId;
  final String name;
  final String contactNumber;
  final String? emailAddress;
  final int numberOfGuests;
  final DateTime dateTime;
  final String eventType;
  final String timePreference;
  final String foodPreference;
  final List<String> selectedItems;
  final bool isVegetarian;
  final String? specialRequest;
  final DateTime createdAt;
  final String status;

  ReservationModel({
    this.id,
    required this.userId,
    required this.name,
    required this.contactNumber,
    this.emailAddress,
    required this.numberOfGuests,
    required this.dateTime,
    required this.eventType,
    required this.timePreference,
    required this.foodPreference,
    required this.selectedItems,
    required this.isVegetarian,
    this.specialRequest,
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'contactNumber': contactNumber,
      'emailAddress': emailAddress,
      'numberOfGuests': numberOfGuests,
      'dateTime': Timestamp.fromDate(dateTime),
      'eventType': eventType,
      'timePreference': timePreference,
      'foodPreference': foodPreference,
      'selectedItems': selectedItems,
      'isVegetarian': isVegetarian,
      'specialRequest': specialRequest,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
    };
  }

  factory ReservationModel.fromJson(Map<String, dynamic> json, String id) {
    return ReservationModel(
      id: id,
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      emailAddress: json['emailAddress'],
      numberOfGuests: json['numberOfGuests'] ?? 0,
      dateTime: (json['dateTime'] as Timestamp).toDate(),
      eventType: json['eventType'] ?? '',
      timePreference: json['timePreference'] ?? '',
      foodPreference: json['foodPreference'] ?? '',
      selectedItems: List<String>.from(json['selectedItems'] ?? []),
      isVegetarian: json['isVegetarian'] ?? false,
      specialRequest: json['specialRequest'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      status: json['status'] ?? 'pending',
    );
  }

  ReservationModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? contactNumber,
    String? emailAddress,
    int? numberOfGuests,
    DateTime? dateTime,
    String? eventType,
    String? timePreference,
    String? foodPreference,
    List<String>? selectedItems,
    bool? isVegetarian,
    String? specialRequest,
    DateTime? createdAt,
    String? status,
  }) {
    return ReservationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      contactNumber: contactNumber ?? this.contactNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      dateTime: dateTime ?? this.dateTime,
      eventType: eventType ?? this.eventType,
      timePreference: timePreference ?? this.timePreference,
      foodPreference: foodPreference ?? this.foodPreference,
      selectedItems: selectedItems ?? this.selectedItems,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      specialRequest: specialRequest ?? this.specialRequest,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
