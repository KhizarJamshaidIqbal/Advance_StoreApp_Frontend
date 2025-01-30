// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ModernSearchBar extends StatelessWidget {
  final Function(String)? onSearch;
  final String hintText;
  final bool isEnabled;
  final Color? fillColor;

  const ModernSearchBar({
    super.key,
    this.onSearch,
    this.hintText = 'Search for dishes...',
    this.isEnabled = true,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search,
              color: Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              enabled: isEnabled,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: hintText,
                fillColor: fillColor,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
