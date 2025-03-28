// ignore_for_file: use_build_context_synchronously

import 'package:ai_buddy/helper/my_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../helper/global.dart';
import '../../widget/profile_image.dart';
import 'login_screen.dart';

//profile screen -- to show signed in user info
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      // for hiding keyboard
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
          //app bar
          appBar: AppBar(title: const Text('Profile Screen')),

          //floating button to log out
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
                backgroundColor: Colors.redAccent,
                onPressed: () async {
                  //for showing progress dialog
                  MyDialog.showLoadingDialog();

                  await FirebaseAuth.instance.signOut();

                  await GoogleSignIn().signOut();

                  Get.back();

                  //replacing home screen with login screen
                  Get.offAll(() => const LoginScreen());
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout')),
          ),

          //body
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // for adding some space
                  SizedBox(width: mq.width, height: mq.height * .03),

                  //image from server
                  ProfileImage(
                    size: mq.height * .2,
                    url: '${user?.photoURL}',
                  ),

                  // for adding some space
                  SizedBox(height: mq.height * .03),

                  // user email label
                  Text(user?.email ?? '',
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 16)),

                  // for adding some space
                  SizedBox(height: mq.height * .05),
                ],
              ),
            ),
          )),
    );
  }
}
