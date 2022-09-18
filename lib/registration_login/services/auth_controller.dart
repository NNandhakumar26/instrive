import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../common/services/navigation.dart';
import '../../posts/screens/posts_page.dart';
import '../../profile/profile_screen.dart';

class AuthController {
// static  final userCredential =
//     await FirebaseAuth.instance.signInWithCredential(credential);

  static FirebaseAuth auth = FirebaseAuth.instance;
  static User? user = auth.currentUser;

  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<UserCredential> createUser(
      {required String userEmail, required String password}) async {
    UserCredential? userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: userEmail,
      password: password,
    );

    return userCredential;
  }

  static Future<String?> signInUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'New User';
      } else if (e.code == 'wrong-password') {
        return 'Incorrect password.';
      } else {
        return e.code;
      }
    }
  }

  // ** Phone Authentication **
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!

        // Sign the user in (or link) with the auto-generated credential
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = 'xxxx';
        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  static void registrationNavigation(
      BuildContext context, UserCredential userCredential) {
    if (userCredential.additionalUserInfo!.isNewUser) {
      CustomNavigation.navigate(
        context,
        const ProfileScreen(
          isNewUser: true,
        ),
      );
    } else {
      CustomNavigation.navigate(
        context,
        PostFeedPage(),
      );
    }
  }
}
