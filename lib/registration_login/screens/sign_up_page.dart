import 'package:flutter/material.dart';

import 'login_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
                    builder: (context) => const SecondRoute(),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                "Sign up",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: 70,
              ),
              const TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: InputDecoration(
                  // hintText: "Email",
                  labelText: "Email",
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const TextField(
                keyboardType: TextInputType.text,
                autocorrect: false,
                decoration: InputDecoration(
                  // hintText: "Email",
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
                  child: const Text("Sign up",
                      style: TextStyle(color: Colors.white)),
                  // color: Colors.black,
                  // elevation: 15.0,
                  // shape: StadiumBorder(),
                  // splashColor: Colors.white54,
                  onPressed: () {},
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: const Text(
                  "Or sign up with social account",
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    width: 165,
                    child: OutlinedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.facebook,
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Facebook",
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                      // shape: const StadiumBorder(),
                      // highlightedBorderColor: Colors.black,
                      // borderSide: const BorderSide(color: Colors.black),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: 50,
                    width: 165,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.facebook,
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Twitter",
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                      // shape: const StadiumBorder(),
                      // highlightedBorderColor: Colors.black,
                      // borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("By signing up you agree to our "),
                  GestureDetector(
                      child: const Text("Terms of Use",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          )),
                      onTap: () {})
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("and "),
                  GestureDetector(
                      child: const Text("Privacy Policy",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          )),
                      onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
