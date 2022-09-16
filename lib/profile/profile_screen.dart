import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instrive/common/services/extensions.dart';
import 'package:instrive/common/services/navigation.dart';
import 'package:instrive/common/widgets/empty_widget.dart';
import 'package:instrive/common/widgets/loading_dialog.dart';
import 'package:instrive/posts/screens/posts_page.dart';
import 'package:instrive/registration_login/screens/verification_screen.dart';
import 'package:instrive/registration_login/services/auth_controller.dart';
import 'package:instrive/registration_login/services/validators.dart';

class ProfileScreen extends StatefulWidget {
  final bool isNewUser;
  final String? emailAddress;
  final String? password;
  const ProfileScreen({
    super.key,
    this.isNewUser = false,
    this.emailAddress,
    this.password,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? photoUrl;
  String? userName;
  String? contactNumber;
  String? email;
  String? password;
  String? passwordConfirm;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    User? user = AuthController.user;
    if (user != null) {
      photoUrl = user.photoURL;
      userName = user.displayName;
      contactNumber = user.phoneNumber;
      email = user.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: (widget.isNewUser) ? 0 : 18,
          leading: Visibility(
            visible: !widget.isNewUser,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: Text(
            'Profile Page',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Colors.blue.shade800.withOpacity(0.87),
                  letterSpacing: -0.4,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
          ),
          elevation: 4,
          shadowColor: Colors.black26,
          backgroundColor: Colors.white,
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                24.height,
                Center(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // ImageSelectionBottomSheet(context);
                        },
                        child: CircleAvatar(
                          radius: 60,
                          child: (photoUrl == null)
                              ? const FlutterLogo(
                                  size: 60,
                                )
                              : Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(photoUrl!),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 2,
                        child: GestureDetector(
                          onTap: () {
                            // ImageSelectionBottomSheet(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.87),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // Center(
                //   child: Stack(
                //     children: [
                //       buildImage(),
                //       Positioned(
                //         bottom: 0,
                //         right: 4,
                //         child: buildEditIcon(Style.nearlyDarkBlue),
                //       ),
                //     ],
                //   ),
                // ),
                32.height,
                TextFormField(
                  decoration: inputDecoration('Name', Icons.person_add),
                  initialValue: userName,
                  onSaved: (value) {
                    userName = value;
                  },
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Cannot be empty'
                      : null,
                ),

                ListTile(
                  onTap: () => CustomNavigation.navigateBack(
                    context,
                    VerificationPage(
                      verify: Verify.emailAddress,
                    ),
                  ),
                  title: 'Update Email Address'.plainText,
                  trailing: forwardIcon,
                  subtitle: secondayTitle((AuthController.user!.emailVerified)
                      ? 'Email Verified'
                      : 'Email Verification Pending'),
                ),
                ListTile(
                  title: 'Update Phone Number'.plainText,
                  trailing: forwardIcon,
                  subtitle: secondayTitle('Authenticate phone number'),
                ),
                ListTile(
                  enabled: email?.isNotEmpty ?? false,
                  title: (widget.isNewUser)
                      ? 'Set up password'.plainText
                      : 'Reset Password'.plainText,
                  trailing: forwardIcon,
                  subtitle: secondayTitle('Authenticate to reset password'),
                ),

                TextFormField(
                  decoration:
                      inputDecoration('Mobile Number', Icons.call_rounded),
                  readOnly: true,
                  initialValue: contactNumber,
                  // validator: (value) => Validators.isValidPhoneNumber(value)
                  //     ? null
                  //     : 'Invalid Phone Number',
                  onSaved: (value) {
                    contactNumber = value;
                  },
                ),
                TextFormField(
                  decoration: inputDecoration('Email Address', Icons.mail),
                  validator: (value) =>
                      Validators.isValidEmail(value) ? null : 'Invalid Email',
                  initialValue: email,
                  onSaved: (value) {
                    email = value;
                  },
                ),

                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8)),
                    backgroundColor: MaterialStateProperty.all(
                      Colors.black38,
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      const CustomLoadingDialog(
                        title: 'Updating User Information',
                      );
                      AuthController.user!.updateEmail(email!);
                      AuthController.user!.updateDisplayName(userName!);
                      AuthController.user!.updatePhotoURL(photoUrl);
                      // ** Remove The Popup **
                      Navigator.pop(context);
                      // ** Remove the main screen **
                      if (widget.isNewUser) {
                        CustomNavigation.navigate(context, PostFeedPage());
                      } else {
                        Navigator.pop(context);
                      }
                      return;
                    }
                  },
                  child: Text(
                    (widget.isNewUser) ? 'Submit' : 'Update',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: 0.8,
                          color: Colors.white.withOpacity(0.87),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget secondayTitle(String title) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          EmptyWidget(
            title,
            textAlign: TextAlign.left,
          ),
        ],
      );
  var forwardIcon = Icon(
    Icons.arrow_forward_ios,
    size: 16,
  );
  InputDecoration inputDecoration(String title, IconData iconData) {
    return InputDecoration(
      hintText: title,
      icon: Icon(
        iconData,
      ),
    );
  }
}
