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
  String? verificationId;

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
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
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
              // 70.height,
              (isContactNumberPage)
                  ? TextField(
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      // validator: (value) => Validators.isValidPhoneNumber(value!)
                      //     ? null
                      //     : 'Invalid Contact Number',
                      onChanged: (value) => contactNumber = value,

                      decoration: const InputDecoration(
                        labelText: "Contact Number",
                      ),
                    )
                  : Column(
                      children: [
                        'OTP has been sent to the number'.centerText,
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            contactNumber.toString(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        8.height,
                        TextField(
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          // validator: (value) => Validators.isValidPhoneNumber(value!)
                          //     ? null
                          //     : 'Invalid Contact Number',
                          onChanged: (value) => otp = value,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            labelText: "OTP Number",
                          ),
                        ),
                      ],
                    ),
              30.height,
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: Text(
                    (isContactNumberPage) ? "Send OTP" : 'Verify OTP',
                    style: const TextStyle(
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
      // hide the keyboard if it is open

      FocusManager.instance.primaryFocus?.unfocus();

      final auth = AuthController.auth;

      await auth.verifyPhoneNumber(
        phoneNumber: '+91$contactNumber',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('verification Completed function');
          UserCredential userCredential =
              await auth.signInWithCredential(credential);

          if (userCredential.user != null) {
            if (!mounted) return;
            AuthController.registrationNavigation(context, userCredential);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print('verification failed');
          if (e.code == 'invalid-phone-number') {
            showSnackBar('The provided phone number is not valid.');
          }
        },
        codeSent: (String thisVerificationId, int? resendToken) async {
          print('code sent function');
          setState(() {
            isContactNumberPage = false;
            verificationId = thisVerificationId;
          });
          showSnackBar('OTP has been sent successfully');
        },
        codeAutoRetrievalTimeout: (String thisVerificationId) {
          print('Inside code auto retrieval timeout');
          verificationId = thisVerificationId;
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (builder) => AlertDialog(
          title: 'Invalid Phone Number'.centerText,
          titlePadding: const EdgeInsets.all(16),
          actions: ['Cancel', 'Retry']
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

  Future<void> validateOtp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otp!,
    );
    UserCredential userCredential =
        await AuthController.auth.signInWithCredential(credential);
    if (userCredential.user != null) {
      if (!mounted) return;
      AuthController.registrationNavigation(context, userCredential);
    }
  }

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
