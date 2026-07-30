import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:http/http.dart' as http;

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  static const String backendUrl = "https://vybe-backend-fbsi.onrender.com";

  // Initialize Firebase & FCM Notifications
  static Future<void> initialize() async {
    await Firebase.initializeApp();

    // Request Notification Permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _messaging.getToken();
      print("FCM Push Token: $token");
      // Optionally sync token with backend for targeted pushes
    }

    // Foreground Notification Handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground Push Received: ${message.notification?.title}');
    });
  }

  // Google OAuth Sign In Flow
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Sync User with Neon DB Backend
        await _syncUserWithBackend(user);
        
        // Log Analytics Event
        await analytics.logLogin(loginMethod: 'google');
      }

      return userCredential;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  // Backend Neon DB User Sync
  static Future<void> _syncUserWithBackend(User user) async {
    try {
      await http.post(
        Uri.parse('$backendUrl/api/v1/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'uid': user.uid,
          'email': user.email,
          'name': user.displayName,
          'photo_url': user.photoURL,
        }),
      );
    } catch (e) {
      print("Backend User Sync Error: $e");
    }
  }

  // Analytics Event Logger
  static Future<void> logCustomEvent(String name, Map<String, Object> parameters) async {
    await analytics.logEvent(name: name, parameters: parameters);
  }

  // Sign Out
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
