// ignore_for_file: equal_keys_in_map, unused_local_variable, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:store_app/services/deep_linking_service.dart';
import 'package:store_app/services/notification_service.dart';
import 'package:store_app/user/Screens/Home_screens/home_screen.dart';
import 'package:store_app/user/Screens/explore_screens/explore_screen.dart';
import 'package:store_app/user/Screens/onboarding/onboarding_screen.dart';
import 'package:store_app/user/Screens/order_screens/order_screen.dart';
import 'package:store_app/user/Screens/order_screens/track_order_screen.dart';
import 'package:store_app/user/Screens/product_screens/product_details_screen.dart';
import 'package:store_app/user/Screens/reservation_screens/my_reservations_screen.dart';
import 'package:store_app/user/Screens/reservation_screens/reservation_screen.dart';
import 'package:store_app/user/Screens/reservation_screens/reservation_summary_screen.dart';
import 'package:store_app/user/Screens/settings_screen/profile_screen.dart';
import 'package:store_app/user/Screens/settings_screen/settings_screen.dart';
import 'package:store_app/user/Screens/settings_screen/help_center_screen.dart';
import 'package:store_app/user/Screens/settings_screen/terms_of_service_screen.dart';
import 'package:store_app/user/Screens/settings_screen/faqs_screen.dart';
import 'package:store_app/auth/sign_in.dart';
import 'package:store_app/auth/sign_up.dart';
import 'package:store_app/auth/forgot_password.dart';
import 'package:store_app/auth/email_verification.dart';
import 'package:store_app/user/Screens/splash_screen/splash_screen.dart';
import 'package:store_app/user/share/custom_bottom_navigation_bar.dart';
import 'package:store_app/user/Screens/whislist_screen/whislist_screen.dart';
import 'package:store_app/user/Screens/cart_screens/cart_screen.dart';
import 'package:store_app/user/Screens/categories_screens/all_categories_screen.dart';
import 'package:store_app/user/Screens/items_screens/all_popular_items_screen.dart';
import 'package:store_app/user/Screens/items_screens/all_recommended_items_screen.dart';
import 'package:provider/provider.dart';
import 'package:store_app/user/Controllers/slider_controller.dart';
import 'package:store_app/user/Controllers/category_controller.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'firebase_options.dart';
import 'package:store_app/theme/app_theme.dart';
import 'package:store_app/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // NotificationServices
  await Firebase.initializeApp();

  // set orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Run main App
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SliderController()),
        ChangeNotifierProvider(create: (_) => CategoryController()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize notifications
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      await NotificationService().initNotification();
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jinnah Ent',
      theme: AppTheme.lightTheme,
      initialRoute: Routes.splash,
      routes: {
        Routes.splash: (context) => const SplashScreen(),
        '/': (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  final user = snapshot.data!;
                  if (!user.emailVerified) {
                    return const EmailVerificationScreen();
                  }
                  return const CustomBottomNavigationBar();
                }
                return const SignInScreen();
              },
            ),
        Routes.signIn: (context) => const SignInScreen(),
        Routes.signUp: (context) => SignUpScreen(),
        Routes.forgotPassword: (context) => const ForgotPasswordScreen(),
        Routes.emailVerification: (context) => const EmailVerificationScreen(),
        Routes.home: (context) => const HomeScreen(),
        Routes.explore: (context) => ExploreScreen(),
        Routes.cart: (context) => const CartScreen(),
        Routes.profile: (context) => const ProfileScreen(),
        Routes.settings: (context) => const SettingsScreen(),
        Routes.wishlist: (context) => const WishlistScreen(),
        Routes.onboarding: (context) => const OnboardingScreen(),
      },
      onGenerateRoute: (settings) {
        // Handle routes that need parameters
        switch (settings.name) {
          case Routes.explore:
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => ExploreScreen(),
              settings: settings,
            );
          case Routes.productDetails:
            final args = settings.arguments as Map<String, dynamic>?;
            if (args == null) return null;
            return MaterialPageRoute(
              builder: (_) => ProductDetailsScreen(
                product: args,
                productId: args['productId'] ?? '',
              ),
            );
          case Routes.reservation_summary_screen:
            final args = settings.arguments as Map<String, dynamic>?;
            if (args == null || args['reservation'] == null) {
              return MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(
                    child: Text('Error: Reservation details not found'),
                  ),
                ),
              );
            }
            return MaterialPageRoute(
              builder: (_) => ReservationSummaryScreen(
                reservation: args['reservation'],
              ),
            );
          default:
            return null;
        }
      },
    );
  }
}
