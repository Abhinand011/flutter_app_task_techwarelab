import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_task_techwarelab/authentication_screens/splash_screen.dart';
import 'package:flutter_app_task_techwarelab/provider_statemanagement/product_provider.dart';
import 'package:flutter_app_task_techwarelab/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication_screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyBF1KROSF6HA0wZIhNoSsNd-co4535OO8Y',
            appId: '1:277246395822:android:fc9fec13bf9aa1234b343f',
            messagingSenderId: '277246395822',
            projectId: 'techwaretask-ba56c'),
      );
      print("firebase connected");
    } catch (E) {
      print("Error in firebase $E");
      return;
    }
  }
  bool loggedIn = await isUserLoggedIn();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProductProvider()),
  ], child:  MyApp(isLoggedIn: loggedIn)));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLoggedIn});
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLoggedIn ? HomeScreen() : SplashScreen(),

      debugShowCheckedModeBanner: false,
    );
  }
}
Future<bool> isUserLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('idToken');
  return token != null;
}


