// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'category': 'Orders',
      'items': [
        {
          'question': 'How do I place an order?',
          'answer':
              'You can place an order by selecting items from our menu, adding them to your cart, and proceeding to checkout. Follow the simple steps to complete your order.',
        },
        {
          'question': 'Can I modify my order after placing it?',
          'answer':
              'You can modify your order within 5 minutes of placing it. After that, please contact our support team for assistance.',
        },
        {
          'question': 'How do I track my order?',
          'answer':
              'You can track your order in real-time through the "Track Order" section in the app. You\'ll receive updates at each stage of delivery.',
        },
      ],
    },
    {
      'category': 'Payment',
      'items': [
        {
          'question': 'What payment methods are accepted?',
          'answer':
              'We accept credit/debit cards, digital wallets, and cash on delivery. All online payments are processed securely.',
        },
        {
          'question': 'Is it safe to save my card details?',
          'answer':
              'Yes, we use industry-standard encryption to protect your payment information. Your card details are stored securely.',
        },
      ],
    },
    {
      'category': 'Delivery',
      'items': [
        {
          'question': 'What are your delivery hours?',
          'answer':
              'We deliver from 10:00 AM to 10:00 PM daily. Delivery times may vary based on your location and order volume.',
        },
        {
          'question': 'Do you deliver to my area?',
          'answer':
              'You can check if we deliver to your area by entering your address in the app. We\'re constantly expanding our delivery zones.',
        },
      ],
    },
    {
      'category': 'Account',
      'items': [
        {
          'question': 'How do I reset my password?',
          'answer':
              'You can reset your password by clicking "Forgot Password" on the login screen and following the instructions sent to your email.',
        },
        {
          'question': 'How do I update my profile?',
          'answer':
              'Go to Settings > Edit Profile to update your personal information, including name, email, and phone number.',
        },
      ],
    },
  ];

  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'FAQs',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search FAQs',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.green),
                ),
              ),
            ),
          ),

          // Categories
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _faqs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(_faqs[index]['category']),
                    selected: _selectedCategoryIndex == index,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    selectedColor: Colors.green,
                    labelStyle: TextStyle(
                      color: _selectedCategoryIndex == index
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),

          // FAQs List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _faqs[_selectedCategoryIndex]['items'].length,
              itemBuilder: (context, index) {
                final faq = _faqs[_selectedCategoryIndex]['items'][index];
                return _buildFaqCard(
                  question: faq['question'],
                  answer: faq['answer'],
                );
              },
            ),
          ),

          // Help Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Still have questions?',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    // Navigate to contact support
                  },
                  child: const Text('Contact Support'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqCard({
    required String question,
    required String answer,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
