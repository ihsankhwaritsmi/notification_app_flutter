import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notification_app/firebase_options.dart';
import 'package:notification_app/screen/login.dart';
import 'package:notification_app/screen/notification_screen.dart';
import 'package:notification_app/screen/register.dart';
import 'package:notification_app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute: 'login',
      routes: {
        'login': (context) => const LoginScreen(),
        'register': (context) => const RegisterScreen(),
        'notification': (context) => const NotificationScreen(),
      },
    );
  }
}
