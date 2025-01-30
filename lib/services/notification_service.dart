import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    // Initialize both local and Firebase notifications
    await localNotiInit();
    await firebaseInit();
  }

  // Initialize local notifications
  static Future<void> localNotiInit() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );
  }

  // Initialize Firebase Messaging
  static Future<void> firebaseInit() async {
    await requestNotificationPermission();
    await getDeviceToken();
    isTokenRefresh();

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showSimpleNotification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        payload: message.data['payload'] ?? '',
      );
    });

    // Handle notification open events when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked: ${message.data}');
    });
  }

  // Request notification permissions
  static Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  // Get device FCM token
  static Future<String?> getDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      print('Device Token: $token');
      await saveTokentoFirestore(token);
    }
    return token;
  }

  // Listen for token refresh
  static void isTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((String token) {
      saveTokentoFirestore(token);
    });
  }

  // Save FCM token to Firestore
  static Future<void> saveTokentoFirestore(String token) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth
              .instance.currentUser!.uid) // You might want to use user ID here
          .set({
        'fcmToken': token,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  // Handle notification tap
  static void onNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      print('Notification payload: ${response.payload}');
      // Handle the notification tap here
    }
  }

  // Show local notification
  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Send notification to all users
  static Future<void> sendNotificationToAll({
    required String title,
    required String body,
    required String payload,
  }) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      List<String> tokens = [];

      for (var doc in querySnapshot.docs) {
        if (doc.exists) {
          String? token = (doc.data() as Map<String, dynamic>)['fcmToken'];
          if (token != null && token.isNotEmpty) {
            tokens.add(token);
          }
        }
      }

      if (tokens.isNotEmpty) {
        await sendFCMNotification(tokens, title, body, payload);
        print('Notifications sent successfully to all devices.');
      } else {
        print('No tokens found in Firestore.');
      }
    } catch (e) {
      print('Failed to send notifications. Error: $e');
    }
  }

  static Future<void> sendFCMNotification(
    List<String> tokens,
    String title,
    String body,
    String payload,
  ) async {
    try {
      // Using computer's IP address
      final url = Uri.parse('http://192.168.1.5:3000/send-notification-to-all');

      final headers = {
        'Content-Type': 'application/json',
      };

      final bodyData = {
        'tokens': tokens,
        'title': title,
        'body': body,
        'payload': payload,
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        print('Notifications sent successfully!');
      } else {
        print('Failed to send notifications. Status: ${response.statusCode}');
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error sending notifications: $e');
      throw e;
    }
  }

  static void showNotification(
      {required String payload, required String title, required String body}) {}
}

// Handle background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
