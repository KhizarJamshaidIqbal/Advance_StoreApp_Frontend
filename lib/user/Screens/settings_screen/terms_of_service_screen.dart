// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
          'Terms of Service',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last Updated
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                children: const [
                  Text(
                    'Last Updated',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'January 9, 2025',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
                    title: '1. Acceptance of Terms',
                    content:
                        'By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement.',
                  ),
                  _buildSection(
                    title: '2. Use License',
                    content:
                        'Permission is granted to temporarily download one copy of the application for personal, non-commercial transitory viewing only.',
                  ),
                  _buildSection(
                    title: '3. User Account',
                    content:
                        'You must create an account to use certain features of the application. You are responsible for maintaining the confidentiality of your account.',
                  ),
                  _buildSection(
                    title: '4. Order and Delivery',
                    content:
                        'We will make every effort to deliver your order in the specified time. However, delivery times may vary based on various factors.',
                  ),
                  _buildSection(
                    title: '5. Payment Terms',
                    content:
                        'All payments are processed securely through our payment partners. We do not store your payment information.',
                  ),
                  _buildSection(
                    title: '6. Refund Policy',
                    content:
                        'Refunds are processed according to our refund policy. Please refer to the specific terms for different situations.',
                  ),
                  _buildSection(
                    title: '7. Privacy Policy',
                    content:
                        'Your privacy is important to us. Please review our Privacy Policy to understand how we collect and use your information.',
                  ),
                  _buildSection(
                    title: '8. Modifications',
                    content:
                        'We reserve the right to modify these terms at any time. Please check regularly for updates.',
                  ),

                  const SizedBox(height: 32),

                  // Contact Information
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Questions about the Terms of Service?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Contact us at:',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'support@example.com',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
