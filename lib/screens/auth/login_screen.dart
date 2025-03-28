import 'dart:developer';
import 'dart:io';

import 'package:ai_buddy/helper/my_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../helper/global.dart';
import '../home_screen.dart';

//login screen -- implements google sign in or sign up feature for app
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();

    //for auto triggering animation
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isAnimate = true);
    });
  }

  // handles google login button click
  Future<void> _handleGoogleBtnClick() async {
    MyDialog.showLoadingDialog();

    final user = await _signInWithGoogle();

    if (user != null) {
      Get.back();
      log('\nUser: ${user.user}');
      log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

      Get.off(() => const HomeScreen());
    }
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');

      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');

      Get.back();

      MyDialog.error('Something went wrong');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.sizeOf(context);

    return Scaffold(
      //app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to $appName'),
      ),

      //body
      body: Stack(children: [
        //app logo
        AnimatedPositioned(
            top: mq.height * .15,
            right: _isAnimate ? mq.width * .25 : -mq.width * .5,
            width: mq.width * .5,
            duration: const Duration(seconds: 1),
            child: Image.asset('assets/images/logo.png')),

        //google login button
        Positioned(
            bottom: mq.height * .1,
            width: mq.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //google btn
                SizedBox(
                  height: mq.height * .06,
                  width: mq.width * .8,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 223, 255, 187),
                          shape: const StadiumBorder(),
                          elevation: 1),

                      // on tap
                      onPressed: _handleGoogleBtnClick,

                      //google icon
                      icon: Image.asset('assets/images/google.png',
                          height: mq.height * .03),

                      //login with google label
                      label: RichText(
                        text: const TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            children: [
                              TextSpan(text: 'Login with '),
                              TextSpan(
                                  text: 'Google',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ]),
                      )),
                ),

                SizedBox(height: mq.height * .015),

                //continue as guest
                TextButton(
                    onPressed: () => Get.offAll(() => HomeScreen()),
                    child: Text(
                      'Continue as Guest',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ))
              ],
            )),
      ]),
    );
  }
}
