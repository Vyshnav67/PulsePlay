import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/features/home/ui/home.dart';
import 'package:provider/provider.dart';

import '../../../controller/authentication_controller.dart';
import '../../welcome/ui/welcome.dart';

class VerificationAlert extends StatelessWidget {
  const VerificationAlert({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationController authenticationController =
        Provider.of<AuthenticationController>(context);
    return AlertDialog(
      title: const Text('Mail sent'),
      content: const Text(
          "A verification Mail has been sent to your email.\nVerify to Continue"),
      actions: [
        TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .delete();
              FirebaseAuth.instance.currentUser!
                  .delete()
                  .then((value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomeScreen(),
                        ),
                      ));
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              if (authenticationController.checkEmailVerified()) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ));
              }
            },
            child: const Text('Continue')),
      ],
    );
  }
}
