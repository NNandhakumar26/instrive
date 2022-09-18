import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instrive/common/services/app_utils.dart';
import 'package:instrive/common/services/extensions.dart';
import 'package:instrive/common/services/navigation.dart';
import 'package:instrive/common/widgets/empty_widget.dart';
import 'package:instrive/common/widgets/loading_dialog.dart';
import 'package:instrive/common/widgets/widget_util.dart';
import 'package:instrive/modals/app_users.dart';
import 'package:instrive/posts/screens/posts_page.dart';
import 'package:instrive/registration_login/screens/verification_screen.dart';
import 'package:instrive/registration_login/services/auth_controller.dart';
import 'package:instrive/registration_login/services/validators.dart';
import '../common/services/network_database.dart';
import '../posts/widgets/image_picker.dart';

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
  String? userName;
  String? contactNumber;
  String? email;
  String? password;
  String? passwordConfirm;
  AppUser? appUser;
  final TextEditingController aboutMeController = TextEditingController();
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    user = AuthController().user;
    initializeAppuser(user);
    if (user != null) {
      userName = user!.displayName;
      contactNumber = user!.phoneNumber;
      email = user!.email;
    }
  }

  void initializeAppuser(User? user) {
    if (!widget.isNewUser) {
      Network.readUser(user!.uid).then(
        (value) => setState(
          () {
            appUser = value;
            aboutMeController.text = appUser?.bio ?? '';
          },
        ),
      );
    } else {
      appUser = AppUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leadingWidth: (widget.isNewUser) ? 0 : 18,
          leading: Visibility(
            visible: !widget.isNewUser,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: Text(
            'Profile Page',
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                24.height,
                displayImageWidget(scaffoldKey.currentContext ?? context),
                24.height,
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
                8.height,
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
                8.height,
                TextFormField(
                  decoration: inputDecoration('Email Address', Icons.mail),
                  // validator: (value) =>
                  //     Validators.isValidEmail(value) ? null : 'Invalid Email',
                  initialValue: email,
                  readOnly: true,
                  onSaved: (value) {
                    email = value;
                  },
                ),
                8.height,
                TextFormField(
                  decoration: inputDecoration(
                    'About',
                    Icons.description_outlined,
                  ),
                  controller: aboutMeController,
                  maxLines: 4,
                  onSaved: (value) {
                    appUser!.bio = value;
                    print('Inside save function ${appUser!.bio}');
                  },
                ),
                12.height,
                ListTile(
                  onTap: () => CustomNavigation.navigateBack(
                    context,
                    VerificationPage(
                      verify: Verify.emailAddress,
                    ),
                  ),
                  enabled: false,
                  title: 'Update Email Address'.plainText,
                  trailing: forwardIcon,
                  subtitle: 'Feature under Development'.plainText,
                  // subtitle: secondayTitle((AuthController().user!.emailVerified)
                  //     ? 'Email Verified'
                  //     : 'Email Verification Pending'),
                ),
                ListTile(
                  title: 'Update Phone Number'.plainText,
                  trailing: forwardIcon,
                  enabled: false,
                  subtitle: secondayTitle('Authenticate phone number'),
                ),
                ListTile(
                  enabled: false,
                  // enabled: email?.isNotEmpty ?? false,
                  title: (widget.isNewUser)
                      ? 'Set up password'.plainText
                      : 'Reset Password'.plainText,
                  trailing: forwardIcon,
                  subtitle: secondayTitle('Authenticate to update password'),
                ),
                16.height,
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      WidgetUtil.showLoading(
                        context,
                        title: 'Updating info',
                      );
                      await updateDetailsToDatabase();

                      // ** Remove The Popup **
                      Navigator.of(context).pop();

                      // ** Remove the main screen **
                      // if (!context.mounted) return;

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

  Widget displayImageWidget(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: scaffoldKey.currentContext!,
                builder: (context) => GetImageWidget(),
              ).then(
                (imageFile) {
                  if (imageFile != null) {
                    showDialog(
                      context: scaffoldKey.currentContext!,
                      builder: (builder) => CustomshowLoading(
                        title: 'Uploading image',
                      ),
                    );

                    AppUtil.uploadFile(
                      isPost: false,
                      file: imageFile[0],
                      updateFileUrl: AuthController().user?.photoURL,
                    ).then(
                      (imageUrl) {
                        appUser!.imageUrl = imageUrl;
                        print('Done');

                        AuthController().user!.updatePhotoURL(imageUrl).then(
                              (value) =>
                                  Navigator.pop(scaffoldKey.currentContext!),
                            );
                        print('Done 2');
                        return;
                      },
                    );
                  }
                },
              );
            },
            child: CircleAvatar(
              radius: 60,
              child: (AuthController().user?.photoURL == null)
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
                          image: NetworkImage(
                            AuthController().user!.photoURL!,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          Positioned(
            right: 4,
            top: 2,
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
          )
        ],
      ),
    );
  }

  Future<void> updateDetailsToDatabase() async {
    User? user = AuthController().user!;
    // await user.updateEmail(email!);
    await user.updateDisplayName(userName!);
    user = AuthController().user;
    print('The user name is $userName');
    appUser = appUser!.copyWith(
      name: user!.displayName,
      imageUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
      userID: user.uid,
      email: user.email,
    );
    if (appUser != null) await Network.updateUser(appUser!);
  }

  Widget secondayTitle(String title) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          EmptyWidget(
            'Feature Under Development',
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
