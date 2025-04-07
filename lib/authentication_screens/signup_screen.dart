import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_task_techwarelab/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController repassword = TextEditingController();

  Future<void> signUp(BuildContext context) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      final uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': email.text.trim(),
        'username': username.text.trim(),
      });

      //
      // String? idToken = await userCredential.user?.getIdToken();
      // String? refreshToken = userCredential.user?.refreshToken;


      if (FirebaseAuth.instance.currentUser != null) {
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // if(idToken != null){
        //   await prefs.setString('idToken', idToken);
        //   await prefs.setString('refreshToken', refreshToken ?? '');
        // }
        print("Login Successfull");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
        );

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed: ${e.toString()}")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://as1.ftcdn.net/v2/jpg/01/85/49/00/1000_F_185490077_TiTMVezMjbhc6iWUm3OOA854i9RHpmX9.jpg",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark Overlay
          Container(color: Colors.black.withOpacity(0.7)),

          // Signup Form
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Signup",
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: "fontone",
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Get what you need",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Username
                    TextFormField(
                      controller: username,
                      decoration: InputDecoration(
                        hintText: "Enter Username",
                        prefixIcon: const Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Email
                    TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        hintText: "Enter Email",
                        prefixIcon: const Icon(CupertinoIcons.mail),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Password
                    TextFormField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        prefixIcon: const Icon(CupertinoIcons.lock_fill),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Re-enter Password
                    TextFormField(
                      controller: repassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Re-enter Password",
                        prefixIcon: const Icon(CupertinoIcons.lock_fill),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Signup Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          signUp(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Signup",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
