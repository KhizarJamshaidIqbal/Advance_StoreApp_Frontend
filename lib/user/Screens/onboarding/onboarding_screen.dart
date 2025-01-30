// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:store_app/main.dart';
import 'package:store_app/routes/routes.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _lottieController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  int _currentPage = 0;
  final String _onboardingCompleteKey = 'onboarding_complete';

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: 'Welcome to\nJinnah Ent',
      description:
          'Experience the finest dining with our authentic cuisine and exceptional service.',
      lottieAsset: 'assets/animations/Welcome.json',
      backgroundColor: const Color(0xFF1E3799),
      secondaryColor: const Color(0xFF4A69BD),
      icon: Icons.restaurant_menu,
      gradientColors: const [
        Color(0xFF1E3799),
        Color(0xFF4A69BD),
        Color(0xFF6A89CC)
      ],
    ),
    OnboardingContent(
      title: 'Fast Delivery\nAt Your Doorstep',
      description:
          'Enjoy our delicious meals delivered right to your home with lightning-fast service.',
      lottieAsset: 'assets/animations/Delivery Dron.json',
      backgroundColor: const Color(0xFF006266),
      secondaryColor: const Color(0xFF009432),
      icon: Icons.delivery_dining,
      gradientColors: const [
        Color(0xFF006266),
        Color(0xFF009432),
        Color(0xFF00B894)
      ],
    ),
    OnboardingContent(
      title: 'Secure Ordering\n& Payment',
      description:
          'Order with confidence using our secure payment system and encrypted data protection.',
      lottieAsset: 'assets/animations/Cyber Security.json',
      backgroundColor: const Color(0xFF6F1E51),
      secondaryColor: const Color(0xFF833471),
      icon: Icons.security,
      gradientColors: const [
        Color(0xFF6F1E51),
        Color(0xFF833471),
        Color(0xFFB83280)
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingComplete = prefs.getBool(_onboardingCompleteKey) ?? false;

    if (onboardingComplete && mounted) {
      Navigator.pushReplacementNamed(context, Routes.customBottomNavigationBar);
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
    if (mounted) {
      Navigator.pushReplacementNamed(context, Routes.signIn);
    }
  }

  void _onGetStartedPressed() async {
    await _completeOnboarding();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _lottieController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background with Gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _contents[_currentPage].gradientColors,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Particle Animation
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CircularParticle(
              key: UniqueKey(),
              awayRadius: 80,
              numberOfParticles: 50,
              speedOfParticles: 1.0,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              onTapAnimation: true,
              particleColor: Colors.white.withOpacity(0.1),
              awayAnimationDuration: const Duration(milliseconds: 600),
              maxParticleSize: 4,
              isRandSize: true,
              isRandomColor: true,
              randColorList: [
                Colors.white.withOpacity(0.1),
                _contents[_currentPage].secondaryColor.withOpacity(0.2),
                _contents[_currentPage].backgroundColor.withOpacity(0.2),
              ],
              awayAnimationCurve: Curves.easeInOutBack,
              enableHover: true,
              hoverColor: Colors.white,
              hoverRadius: 90,
              connectDots: false,
            ),
          ),
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Skip button with modern glass effect
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _slideController,
                        curve: Curves.easeOut,
                      )),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.1),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, Routes.signIn);
                          },
                          icon: const Icon(
                            Icons.skip_next_rounded,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Skip',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Page Content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                        _lottieController.reset();
                        _lottieController.forward();
                        _fadeController.reset();
                        _fadeController.forward();
                        _slideController.reset();
                        _slideController.forward();
                      });
                    },
                    itemCount: _contents.length,
                    itemBuilder: (context, index) {
                      return FadeTransition(
                        opacity: _fadeController,
                        child: OnboardingPage(
                          content: _contents[index],
                          controller: _lottieController,
                          slideController: _slideController,
                        ),
                      );
                    },
                  ),
                ),
                // Modern Progress Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _contents.length,
                    (index) => buildDot(index),
                  ),
                ),
                const SizedBox(height: 30),
                // Enhanced Next/Get Started Button
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _slideController,
                    curve: Curves.easeOut,
                  )),
                  child: ElevatedButton(
                    onPressed: _currentPage == _contents.length - 1
                        ? _onGetStartedPressed
                        : () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _contents[_currentPage].backgroundColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPage == _contents.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _currentPage == _contents.length - 1
                              ? Icons.rocket_launch_rounded
                              : Icons.arrow_forward_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Colors.white
            : Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
        boxShadow: _currentPage == index
            ? [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingContent content;
  final AnimationController controller;
  final AnimationController slideController;

  const OnboardingPage({
    super.key,
    required this.content,
    required this.controller,
    required this.slideController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            // Animated Icon with Enhanced Glass Effect
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: slideController,
                curve: Curves.easeOut,
              )),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  content.icon,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            // Enhanced Lottie Animation
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: slideController,
                curve: Curves.easeOut,
              )),
              child: Lottie.asset(
                content.lottieAsset,
                height: MediaQuery.of(context).size.height * 0.3,
                controller: controller,
                onLoaded: (composition) {
                  controller.duration = composition.duration;
                  controller.forward();
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            // Animated Title with Enhanced Shadow
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: slideController,
                curve: Curves.easeOut,
              )),
              child: Text(
                content.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            // Enhanced Description with Modern Glass Effect
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: slideController,
                curve: Curves.easeOut,
              )),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  content.description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          ],
        ),
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final String lottieAsset;
  final Color backgroundColor;
  final Color secondaryColor;
  final IconData icon;
  final List<Color> gradientColors;

  const OnboardingContent({
    required this.title,
    required this.description,
    required this.lottieAsset,
    required this.backgroundColor,
    required this.secondaryColor,
    required this.icon,
    required this.gradientColors,
  });
}
