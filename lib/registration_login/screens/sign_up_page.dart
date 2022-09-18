import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instrive/common/services/extensions.dart';
import 'package:instrive/registration_login/services/validators.dart';
import 'package:instrive/registration_login/widgets/google_sign_in.dart';

import 'login_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;

  bool eye = true;

  void _toggle() {
    setState(() {
      eye = !eye;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 20, 0),
            child: TextButton(
              child: const Text(
                "Log In",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              // highlightColor: Colors.black,
              // shape: StadiumBorder(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                ),
                70.height,
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: (value) =>
                      Validators.isValidEmail(value!) ? null : 'Invalid Email',
                  onSaved: (value) => email = value,
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                ),
                30.height,
                TextFormField(
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Check the password'
                      : null,
                  onSaved: (value) => password = value,
                  decoration: const InputDecoration(
                    labelText: "Name",
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: GestureDetector(
                      onTap: _toggle,
                      child: const Icon(
                        Icons.remove_red_eye,
                      ),
                    ),
                  ),
                  obscureText: eye,
                ),
                const SizedBox(
                  height: 30,
                ),
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
                    onPressed: () {
                      _formKey.currentState!.save();
                      if (_formKey.currentState!.validate()) {}
                    },
                  ),
                ),
                SignInOptionsWidget(),
                // Container(
                //   padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                //   child: const Text(
                //     "Or sign up with social account",
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     SizedBox(
                //       height: 50,
                //       width: 165,
                //       child: OutlinedButton(
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: const <Widget>[
                //             Icon(
                //               Icons.facebook,
                //               size: 20,
                //             ),
                //             SizedBox(
                //               width: 5,
                //             ),
                //             Text("Facebook",
                //                 style: TextStyle(color: Colors.black)),
                //           ],
                //         ),
                //         // shape: const StadiumBorder(),
                //         // highlightedBorderColor: Colors.black,
                //         // borderSide: const BorderSide(color: Colors.black),
                //         onPressed: () {},
                //       ),
                //     ),
                //     const SizedBox(
                //       width: 20,
                //     ),
                //     SizedBox(
                //       height: 50,
                //       width: 165,
                //       child: OutlinedButton(
                //         onPressed: () {},
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: const <Widget>[
                //             Icon(
                //               Icons.facebook,
                //               size: 20,
                //             ),
                //             SizedBox(
                //               width: 5,
                //             ),
                //             Text("Twitter",
                //                 style: TextStyle(color: Colors.black)),
                //           ],
                //         ),
                //         // shape: const StadiumBorder(),
                //         // highlightedBorderColor: Colors.black,
                //         // borderSide: const BorderSide(color: Colors.black),
                //       ),
                //     ),
                //   ],
                // ),

                const SizedBox(height: 60),

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
      ),
    );
  }
}
