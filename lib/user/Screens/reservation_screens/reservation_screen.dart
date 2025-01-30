// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:store_app/models/reservation_model.dart';
import 'package:store_app/user/Screens/reservation_screens/reservation_summary_screen.dart';
import 'package:intl/intl.dart';
import '../menu_screens/menu_selection_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/product_model.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({Key? key}) : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otherEventController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();
  final TextEditingController _specialRequestController =
      TextEditingController();

  String _selectedEventType = 'Birthday';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedSeating = 'Regular';
  String _selectedFoodPreference = 'Menu';
  String _selectedTimePreference = 'Day Time';
  List<String> _selectedItems = [];
  bool _isVegetarian = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, ProductModel> _selectedProducts = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Table Reservation',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Theme.of(context).primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Information Card
                Card(
                  elevation: 4,
                  shadowColor: Colors.green.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 5,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Basic Information',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 22,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person_outline,
                                color: Theme.of(context).primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter your name'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _contactController,
                          decoration: InputDecoration(
                            labelText: 'Contact Number',
                            prefixIcon: Icon(Icons.phone_outlined,
                                color: Theme.of(context).primaryColor),
                            helperText: 'For confirmation purposes',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter your contact number'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email Address (Optional)',
                            prefixIcon: Icon(Icons.email_outlined,
                                color: Theme.of(context).primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Event Details Card
                Card(
                  elevation: 4,
                  shadowColor: Colors.green.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 5,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Event Details',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 22,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        DropdownButtonFormField<String>(
                          value: _selectedEventType,
                          decoration: InputDecoration(
                            labelText: 'Event Type',
                            prefixIcon: Icon(Icons.event_outlined,
                                color: Theme.of(context).primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                          items: [
                            'Birthday',
                            'Family Dinner',
                            'Anniversary',
                            'Business Meeting',
                            'Other'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedEventType = newValue!;
                            });
                          },
                        ),
                        if (_selectedEventType == 'Other') ...[
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _otherEventController,
                            decoration: InputDecoration(
                              labelText: 'Specify Event Type',
                              prefixIcon: Icon(Icons.edit_outlined,
                                  color: Theme.of(context).primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _guestsController,
                          decoration: InputDecoration(
                            labelText: 'Number of Guests',
                            prefixIcon: Icon(Icons.group_outlined,
                                color: Theme.of(context).primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter number of guests'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedTimePreference,
                                decoration: InputDecoration(
                                  labelText: 'Time Preference',
                                  prefixIcon: Icon(Icons.wb_sunny_outlined,
                                      color: Theme.of(context).primaryColor),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: 'Day Time',
                                    child: Row(
                                      children: [
                                        Icon(Icons.wb_sunny_outlined,
                                            color: Colors.orange, size: 20),
                                        const SizedBox(width: 8),
                                        const Text('Day Time (11 AM - 5 PM)'),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Night Time',
                                    child: Row(
                                      children: [
                                        Icon(Icons.nightlight_outlined,
                                            color: Colors.indigo, size: 20),
                                        const SizedBox(width: 8),
                                        const Text('Night Time (6 PM - 11 PM)'),
                                      ],
                                    ),
                                  ),
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedTimePreference = newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () async {
                            final DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                            );
                            if (date != null) {
                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: _selectedTime,
                              );
                              if (time != null) {
                                setState(() {
                                  _selectedDate = date;
                                  _selectedTime = time;
                                });
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade50,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    color: Theme.of(context).primaryColor),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Date and Time',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${DateFormat('MMM dd, yyyy').format(_selectedDate)} at ${_selectedTime.format(context)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Seating and Preferences Card
                Card(
                  elevation: 4,
                  shadowColor: Colors.green.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 5,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Seating & Preferences',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 22,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        DropdownButtonFormField<String>(
                          value: _selectedSeating,
                          decoration: InputDecoration(
                            labelText: 'Seating Preference',
                            prefixIcon: Icon(Icons.chair_outlined,
                                color: Theme.of(context).primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          items: [
                            'Regular',
                            'With Music',
                            'With Decoration',
                            'Private Area'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedSeating = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _specialRequestController,
                          decoration: InputDecoration(
                            labelText: 'Special Requests',
                            prefixIcon: Icon(Icons.note_add_outlined,
                                color: Theme.of(context).primaryColor),
                            helperText: 'Extra space or table for cake, etc.',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: _selectedFoodPreference,
                          decoration: InputDecoration(
                            labelText: 'Food Preference',
                            prefixIcon: Icon(Icons.restaurant_menu_outlined,
                                color: Theme.of(context).primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          items: ['Menu', 'Specific Items'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedFoodPreference = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        if (_selectedFoodPreference == 'Menu')
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                // TODO: Add logic to view menu
                              },
                              icon: const Icon(Icons.menu_book,
                                  size: 20, color: Colors.white),
                              label: const Text('View Menu'),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          )
                        else if (_selectedFoodPreference == 'Specific Items')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final result =
                                      await Navigator.push<List<String>>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MenuSelectionScreen(
                                        isSpecificItems: true,
                                        selectedItems: _selectedItems,
                                      ),
                                    ),
                                  );
                                  if (result != null) {
                                    setState(() {
                                      _selectedItems = result;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.restaurant_menu),
                                label: const Text('Select Specific Items'),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              if (_selectedItems.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Selected Items:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        FutureBuilder<void>(
                                          future: _loadSelectedProducts(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }

                                            return Wrap(
                                              spacing: 8,
                                              children: _selectedItems
                                                  .map((itemId) {
                                                    final product =
                                                        _selectedProducts[
                                                            itemId];
                                                    if (product == null)
                                                      return const SizedBox();

                                                    return Chip(
                                                      label: Text(product.name),
                                                      deleteIcon: const Icon(
                                                          Icons.cancel,
                                                          size: 18),
                                                      onDeleted: () {
                                                        setState(() {
                                                          _selectedItems
                                                              .remove(itemId);
                                                          _selectedProducts
                                                              .remove(itemId);
                                                        });
                                                      },
                                                    );
                                                  })
                                                  .where((widget) =>
                                                      widget is Chip)
                                                  .toList(),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade50,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: SwitchListTile(
                            title: const Text('Vegetarian Preference'),
                            value: _isVegetarian,
                            onChanged: (bool value) {
                              setState(() {
                                _isVegetarian = value;
                              });
                            },
                            activeColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final reservation = ReservationModel(
                          userId: '', // Will be set in summary screen
                          name: _nameController.text,
                          contactNumber: _contactController.text,
                          emailAddress: _emailController.text.isEmpty
                              ? null
                              : _emailController.text,
                          numberOfGuests: int.parse(_guestsController.text),
                          dateTime: _selectedDate,
                          eventType: _selectedEventType == 'Other'
                              ? _otherEventController.text
                              : _selectedEventType,
                          timePreference: _selectedTimePreference,
                          foodPreference: _selectedFoodPreference,
                          selectedItems: _selectedItems,
                          isVegetarian: _isVegetarian,
                          specialRequest: _specialRequestController.text.isEmpty
                              ? null
                              : _specialRequestController.text,
                          createdAt: DateTime.now(),
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReservationSummaryScreen(
                              reservation: reservation,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Review Reservation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadSelectedProducts() async {
    for (final itemId in _selectedItems) {
      if (!_selectedProducts.containsKey(itemId)) {
        final doc = await _firestore.collection('products').doc(itemId).get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          _selectedProducts[itemId] = ProductModel.fromJson(data, doc.id);
        }
      }
    }
  }
}
