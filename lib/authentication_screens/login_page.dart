import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_task_techwarelab/authentication_screens/signup_screen.dart';
import 'package:flutter_app_task_techwarelab/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
   LoginPage({super.key});

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

   Future<void> loginWithUsername(BuildContext context, String username, String password) async {
     try {
       final query = await FirebaseFirestore.instance
           .collection('users')
           .where('username', isEqualTo: username)
           .limit(1)
           .get();

       if (query.docs.isEmpty) {
         throw Exception("Username not found");
       }

       final email = query.docs.first.data()['email'];

      UserCredential userCredential= await FirebaseAuth.instance.signInWithEmailAndPassword(
         email: email,
         password: password,
       );

       String? idToken = await userCredential.user?.getIdToken();
       String? refreshToken = userCredential.user?.refreshToken;


       if (FirebaseAuth.instance.currentUser != null) {
         SharedPreferences prefs = await SharedPreferences.getInstance();
         if(idToken != null){
           await prefs.setString('idToken', idToken);
           await prefs.setString('refreshToken', refreshToken ?? '');
         }
         print("Login Successfull");
         Navigator.pushAndRemoveUntil(
           context,
           MaterialPageRoute(builder: (context) => HomeScreen()),
               (route) => false,
         );

       }


     } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Login failed: ${e.toString()}")),
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
                    "https://as1.ftcdn.net/v2/jpg/01/85/49/00/1000_F_185490077_TiTMVezMjbhc6iWUm3OOA854i9RHpmX9.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark Overlay
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          // Login Form
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: "fontone",
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(controller: username,
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
                    TextFormField(controller: password,
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
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          loginWithUsername(context, username.text.trim(), password.text.trim());
                        //

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("join with us?",style: TextStyle(color: Colors.white),),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupScreen()));
                            },
                            child: Text("Signup",style: TextStyle(color: Colors.yellowAccent),))
                      ],
                    )
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
