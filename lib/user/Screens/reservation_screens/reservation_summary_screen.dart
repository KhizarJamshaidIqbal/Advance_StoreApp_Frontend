// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_app/user/share/custom_bottom_navigation_bar.dart';
import 'package:store_app/utils/custom_snackbar.dart';
import 'package:intl/intl.dart';
import '../../../models/reservation_model.dart';

class ReservationSummaryScreen extends StatelessWidget {
  final ReservationModel reservation;

  const ReservationSummaryScreen({
    Key? key,
    required this.reservation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reservation Summary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.event_available,
                    size: 64,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Review Your Reservation',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please review the details below before confirming',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    context,
                    'Event Details',
                    Icons.celebration,
                    [
                      _buildDetailRow(
                        context,
                        'Event Type',
                        reservation.eventType,
                        Icons.event,
                      ),
                      _buildDetailRow(
                        context,
                        'Date',
                        DateFormat('MMMM dd, yyyy')
                            .format(reservation.dateTime),
                        Icons.calendar_today,
                      ),
                      _buildDetailRow(
                        context,
                        'Time',
                        reservation.timePreference,
                        Icons.access_time,
                      ),
                      _buildDetailRow(
                        context,
                        'Number of Guests',
                        '${reservation.numberOfGuests} people',
                        Icons.people,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    'Contact Information',
                    Icons.contact_mail,
                    [
                      _buildDetailRow(
                        context,
                        'Name',
                        reservation.name,
                        Icons.person,
                      ),
                      _buildDetailRow(
                        context,
                        'Phone',
                        reservation.contactNumber,
                        Icons.phone,
                      ),
                      if (reservation.emailAddress != null)
                        _buildDetailRow(
                          context,
                          'Email',
                          reservation.emailAddress!,
                          Icons.email,
                        ),
                    ],
                  ),
                  if (reservation.selectedItems.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSection(
                      context,
                      'Selected Items',
                      Icons.restaurant_menu,
                      [
                        FutureBuilder<List<String>>(
                          future:
                              _getSelectedItemNames(reservation.selectedItems),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text('No items selected');
                            }
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: snapshot.data!.map((item) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        size: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        item,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                  if (reservation.specialRequest != null &&
                      reservation.specialRequest!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSection(
                      context,
                      'Special Request',
                      Icons.note,
                      [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            reservation.specialRequest!,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _confirmReservation(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Confirm Reservation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Edit Reservation',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
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
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReservation(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      CustomSnackBar.showError(
        context,
        'Please login to confirm your reservation',
      );
      return;
    }

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Confirming your reservation...',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Update reservation with user ID and status
      final updatedReservation = reservation.copyWith(
        userId: user.uid,
        status: 'pending',
        dateTime: reservation.dateTime,
        timePreference: reservation.timePreference,
        numberOfGuests: reservation.numberOfGuests,
        eventType: reservation.eventType,
        name: reservation.name,
        contactNumber: reservation.contactNumber,
        emailAddress: reservation.emailAddress,
        selectedItems: reservation.selectedItems,
        specialRequest: reservation.specialRequest,
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('reservations')
          .add(updatedReservation.toJson());

      if (context.mounted) {
        // Close loading dialog
        Navigator.pop(context);

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green[600],
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text('Success!'),
              ],
            ),
            content: const Text(
              'Your reservation has been confirmed. You can view and manage your reservations in the My Reservations section.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigator.pop(context); // Close dialog
                  CustomBottomNavigationBar.switchToReservationsFromOutside(
                      context);
                },
                child: const Text('View My Reservations'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        // Close loading dialog
        Navigator.pop(context);

        CustomSnackBar.showError(context, e.toString());
      }
    }
  }

  Future<List<String>> _getSelectedItemNames(List<String> itemIds) async {
    final itemNames = <String>[];
    for (final itemId in itemIds) {
      final doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(itemId)
          .get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        itemNames.add(data['name'] as String);
      }
    }
    return itemNames;
  }
}
