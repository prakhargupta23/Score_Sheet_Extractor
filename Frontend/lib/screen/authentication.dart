import 'dart:ui';

import 'package:btp/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_button/sign_in_button.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? _user;

  void signout() {
    setState(() {
      auth.signOut();
    });
  }

  Positioned _buildFloatingBox(double top, double left, double size) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  void _handleGoogleSignIn() async {
    print("yes i am here");
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      await auth.signInWithProvider(_googleAuthProvider);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    auth: auth,
                  )));
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   actions: [
      //     Center(
      //       child: Container(
      //
      //           child:
      //       ),
      //     ),
      //   ],
      // ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.black, Color.fromARGB(255, 0, 20, 153)],
                radius: 1.5,
              ),
            ),
          ),
          // Glass boxes in the background
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // Logo in the center
          Positioned(
            top: MediaQuery.of(context).size.height * 0.7,
            left: MediaQuery.of(context).size.height * 0.1,

            child: const Text(
              'Smart Score',
              style: TextStyle(
                fontSize: 35.0,
                letterSpacing: 1.8,
                fontWeight: FontWeight.w900,
                color: Colors.white, // Text color
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.01,
            left: MediaQuery.of(context).size.height * 0.09,
            // right: MediaQuery.of(context).size.height * 0.2,
            child: Center(
              child: SizedBox(
                height: 250,
                width: 250,
                child: Image.asset('assets/images/lnmiit.png'),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                height: 250,
                width: 250,
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
          ),
          // Sign In button at the bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _handleGoogleSignIn,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 80.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text(
                    'Login with Google',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Text at the top
          // Positioned(
          //   top: 40,
          //   left: 0,
          //   right: 0,
          //   child: Center(
          //     child: Text(
          //       'Smart Score',
          //       style: TextStyle(
          //         fontSize: 22.0,
          //         letterSpacing: 1.8,
          //         fontWeight: FontWeight.w900,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
          // Small floating boxes
          _buildFloatingBox(100, 20, 60),
          _buildFloatingBox(450, 30, 60),
          _buildFloatingBox(300, 0, 40),
          _buildFloatingBox(200, 40, 45),
          _buildFloatingBox(450, 250, 55),
          _buildFloatingBox(200, 300, 35),
          _buildFloatingBox(300, 300, 45),
        ],
      ),
      // body: Container(
      //   width: double.infinity,
      //   decoration: const BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter,
      //       colors: [Colors.blue, Color(0xff0001AD)],
      //     ),
      //   ),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       Image.asset('assets/images/lnmiit.png'),
      //       const Text(
      //         'Smart Score',
      //         style: TextStyle(
      //           fontSize: 35.0,
      //           letterSpacing: 1.8,
      //           fontWeight: FontWeight.w900,
      //           color: Colors.white, // Text color
      //         ),
      //       ),
      //       const SizedBox(height: 5),
      //       SizedBox(
      //         height: 250,
      //         width: 250,
      //         child: Image.asset('assets/images/logo.png'),
      //       ),
      //       const SizedBox(height: 25),
      //       GestureDetector(
      //         onTap: _handleGoogleSignIn,
      //         child: Container(
      //           padding: const EdgeInsets.symmetric(
      //             horizontal: 80.0,
      //             vertical: 12.0,
      //           ),
      //           decoration: BoxDecoration(
      //             color: Colors.white, // Button color
      //             borderRadius: BorderRadius.circular(10.0),
      //           ),
      //           child: const Text(
      //             'Login with Google',
      //             style: TextStyle(
      //               color: Colors.blue, // Text color
      //               fontSize: 16,
      //               fontWeight: FontWeight.w600,
      //             ),
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 10),
      //       // SignInButton(Button.g, onPressed: onPressed)
      //     ],
      //   ),
      // ),
    );
  }
}
