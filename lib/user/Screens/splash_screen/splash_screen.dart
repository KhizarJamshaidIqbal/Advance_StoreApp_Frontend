// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:store_app/user/widgets/ar_view_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:store_app/auth/auth_service.dart';
import 'package:store_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();
  final String _onboardingCompleteKey = 'onboarding_complete';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Add a minimum delay to show the splash screen
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Check if onboarding is completed
      final prefs = await SharedPreferences.getInstance();
      final onboardingComplete = prefs.getBool(_onboardingCompleteKey) ?? false;

      if (!onboardingComplete) {
        Navigator.pushReplacementNamed(context, Routes.onboarding);
        return;
      }

      // Check user authentication
      final user = await _authService.getCurrentUser();

      if (!mounted) return;

      if (user != null) {
        // User is logged in, navigate based on role
        if (user['role'] == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin/dashboard');
        } else {
          Navigator.pushReplacementNamed(
              context, Routes.customBottomNavigationBar);
        }
      } else {
        // No user is logged in
        Navigator.pushReplacementNamed(context, Routes.signIn);
      }
    } catch (e) {
      debugPrint('Error in splash screen: $e');
      // If there's any error, navigate to onboarding if not completed, otherwise to sign in
      if (!mounted) return;

      try {
        final prefs = await SharedPreferences.getInstance();
        final onboardingComplete =
            prefs.getBool(_onboardingCompleteKey) ?? false;

        if (!onboardingComplete) {
          Navigator.pushReplacementNamed(context, Routes.onboarding);
        } else {
          Navigator.pushReplacementNamed(context, Routes.signIn);
        }
      } catch (e) {
        // If we can't even check shared preferences, default to onboarding
        Navigator.pushReplacementNamed(context, Routes.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/icon.png'),
              ),
            ),
            const SizedBox(height: 30),
            // App Name
            const Text(
              'Jinnah Ent',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Food Delivery App',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            // Loading animation
            SizedBox(
              width: 100,
              height: 100,
              child: Lottie.asset(
                "assets/animations/Loading.json",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
