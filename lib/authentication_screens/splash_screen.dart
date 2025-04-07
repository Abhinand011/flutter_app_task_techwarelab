import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_task_techwarelab/authentication_screens/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(
                "https://t3.ftcdn.net/jpg/06/47/98/46/360_F_647984617_20NcWOfvlkctAKp9uHUk870m6iGMS6h2.jpg",
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
