import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instrive/common/services/extensions.dart';
import 'package:instrive/common/services/navigation.dart';
import 'package:instrive/common/widgets/alert_dialog.dart';
import 'package:instrive/common/widgets/loading_dialog.dart';
import 'package:instrive/common/widgets/widget_util.dart';
import 'package:instrive/posts/screens/posts_page.dart';
import 'package:instrive/profile/profile_screen.dart';
import 'package:instrive/registration_login/services/auth_controller.dart';
import 'package:instrive/registration_login/widgets/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscureText = true;
  bool isRegistrationPage = false;
  String? loginId;
  String? password;

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
              TextField(
                // keyboardType: TextInputType.emailAddress,
                onChanged: (value) => loginId = value,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Email ID",
                ),
              ),
              30.height,
              TextFormField(
                // initialValue: password,
                obscureText: obscureText,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  hintText: 'Your password',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    icon: Icon(Icons.remove_red_eye),
                  ),
                ),
              ),
              30.height,
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    WidgetUtil.loadingDialog(context, title: 'Hold on a while');
                    String? response =
                        await AuthController.signInUser(loginId!, password!);
                    if (!mounted) return;
                    Navigator.pop(context);
                    if (response is String) {
                      if (response == 'New User') {
                        await AuthController.createUser(
                          userEmail: loginId!,
                          password: password!,
                        );
                        if (!mounted) return;
                        CustomNavigation.navigate(
                          context,
                          ProfileScreen(
                            isNewUser: true,
                            emailAddress: loginId,
                            password: password,
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (builder) => CustomAlertDialog(
                            context: context,
                            title: 'Error',
                            columnWidgets: [
                              response.plainText,
                            ],
                            primaryButton: 'Retry',
                            secondaryButton: 'Cancel',
                          ),
                        );
                      }
                    } else {
                      if (!mounted) return;
                      CustomNavigation.navigate(
                        context,
                        PostFeedPage(),
                      );
                    }
                  },
                  child: const Text(
                    "Continue",
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
                    (isRegistrationPage)
                        ? "Already have an account - ".centerText
                        : "Don\'t Have an account - ".centerText,
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isRegistrationPage = !isRegistrationPage;
                        });
                      },
                      // highlightColor: Colors.black,
                      // shape: StadiumBorder(),
                      child: Text(
                        (isRegistrationPage) ? "Sign in" : 'Sign up',
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
