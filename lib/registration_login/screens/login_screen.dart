import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instrive/common/services/extensions.dart';
import 'package:instrive/registration_login/widgets/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      // resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                "Log in",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              const TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Email",
                ),
              ),
              30.height,
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
              30.height,
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  // color: Colors.black,
                  // elevation: 15.0,
                  // shape: StadiumBorder(),
                  // splashColor: Colors.white54,
                  onPressed: () {},
                  child: const Text(
                    "Log in",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    "Already Have an account - ".centerText,
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      // highlightColor: Colors.black,
                      // shape: StadiumBorder(),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GoogleSignInWidget(),
              20.height,
            ],
          ),
        ),
      ),
    );
  }
}
