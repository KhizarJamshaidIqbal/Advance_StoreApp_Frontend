// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomFloatingChatButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;

  const CustomFloatingChatButton({
    Key? key,
    required this.onPressed,
    this.iconData = Icons.chat_rounded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(
          iconData,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
