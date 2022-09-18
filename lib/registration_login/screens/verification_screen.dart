import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instrive/common/services/extensions.dart';
import 'package:instrive/common/widgets/widget_util.dart';
import 'package:instrive/registration_login/services/auth_controller.dart';
import 'package:instrive/registration_login/services/validators.dart';

enum Verify {
  emailAddress,
  password,
  phoneNumber,
}

class VerificationPage extends StatefulWidget {
  final Verify verify;

  const VerificationPage({
    super.key,
    required this.verify,
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  Verify? verify;
  String? emailID;
  String? password;
  String? phoneNumber;

  final _formKey = GlobalKey<FormState>();
  User? user = AuthController().user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verify = widget.verify;
    emailID = user!.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: displayWidget(),
          ),
        ),
      ),
    );
  }

  List<Widget> displayWidget() {
    switch (verify) {
      case Verify.emailAddress:
        return [
          8.height,
          Form(
            key: _formKey,
            child: TextFormField(
              initialValue: emailID,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Your Email Address',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                suffixIcon: TextButton(
                  onPressed: () async {
                    await user?.sendEmailVerification();
                    // if (!ismounted) return;
                    WidgetUtil.showSnackBar(context, 'Verification Mail Sent');
                  },
                  child: 'Verify'.plainText,
                ),
              ),
              onChanged: (value) {
                emailID = value;
              },
              validator: (value) => Validators.isValidEmail(
                value ?? "",
              )
                  ? 'Invalid email address'
                  : null,
            ),
          ),
          8.height,
          TextField(),
        ];

      default:
        return [
          TextFormField(),
          8.height,
          TextField(),
        ];
    }
  }

  Future<void> primaryFunction() async {
    switch (verify) {
      case Verify.emailAddress:
        break;
      default:
    }
  }

  Widget get primaryButton =>
      OutlinedButton(onPressed: () {}, child: 'child'.plainText);
}
