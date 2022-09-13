import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instrive/common/services/extensions.dart';
import 'package:instrive/common/services/navigation.dart';
import 'package:instrive/posts/screens/posts_page.dart';
import 'package:instrive/profile/profile_screen.dart';
import 'package:instrive/registration_login/services/auth_controller.dart';

import '../services/validators.dart';

class PhoneAuthenticationPage extends StatefulWidget {
  const PhoneAuthenticationPage({super.key});

  @override
  State<PhoneAuthenticationPage> createState() =>
      _PhoneAuthenticationPageState();
}

class _PhoneAuthenticationPageState extends State<PhoneAuthenticationPage> {
  final _formKey = GlobalKey<FormState>();
  bool isContactNumberPage = true;
  String? contactNumber;
  String? otp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        // actions: <Widget>[
        //   Padding(
        //     padding: const EdgeInsets.fromLTRB(0, 15, 20, 0),
        //     child: TextButton(
        //       child: const Text(
        //         "Phone Number Authentication",
        //         style: TextStyle(
        //           color: Colors.grey,
        //           fontSize: 18,
        //         ),
        //       ),
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => const LoginPage(),
        //           ),
        //         );
        //       },
        //       // highlightColor: Colors.black,
        //       // shape: StadiumBorder(),
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                (isContactNumberPage)
                    ? "Phone Number Authentication"
                    : 'OTP Verfication',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              70.height,
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                // validator: (value) => Validators.isValidPhoneNumber(value!)
                //     ? null
                //     : 'Invalid Contact Number',
                onChanged: (value) => contactNumber = value,
                decoration: const InputDecoration(
                  labelText: "Contact Number",
                ),
              ),
              30.height,
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  // color: Colors.black,
                  // elevation: 15.0,
                  // shape: StadiumBorder(),
                  // splashColor: Colors.white54,
                  onPressed: () => (isContactNumberPage)
                      ? contactNumberRegistration()
                      : validateOtp(),
                ),
              ),
              30.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  "By signing up you agree to our ".plainText,
                  GestureDetector(
                    child: "Terms of Use".underlineText,
                    onTap: () {},
                  )
                ],
              ),
              5.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  "and ".plainText,
                  GestureDetector(
                    child: "Privacy Policy".underlineText,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void contactNumberRegistration() async {
    if (Validators.isValidPhoneNumber(contactNumber)) {
      showSnackBar('Please wait...');
      final auth = AuthController.auth;

      await auth.verifyPhoneNumber(
        phoneNumber: '+91$contactNumber',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential =
              await auth.signInWithCredential(credential);

          if (userCredential.user != null) {
            if (!mounted) return;
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
                const PostFeedPage(),
              );
            }
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            showSnackBar('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          String smsCode = 'xxxx';
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: smsCode,
          );
          await auth.signInWithCredential(credential);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } else {
      showDialog(
        context: context,
        builder: (builder) => AlertDialog(
          title: 'Invalid Phone Number'.plainText,
          titlePadding: const EdgeInsets.all(8),
          actions: ['Retry', 'Cancel']
              .map(
                (e) => TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: e.plainText,
                ),
              )
              .toList(),
        ),
      );
      return;
    }
  }

  Future<void> validateOtp() async {}

  void showSnackBar(String message, {bool isError = false}) async =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: message.plainText,
          action: SnackBarAction(
            label: 'Done',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        ),
      );
}
