import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instrive/common/services/extensions.dart';
import 'package:instrive/common/widgets/loading_dialog.dart';
import 'package:instrive/posts/screens/posts_page.dart';
import 'package:instrive/profile/profile_screen.dart';
import 'package:instrive/registration_login/screens/login_screen.dart';
import 'package:instrive/registration_login/services/auth_controller.dart';
import 'package:json_theme/json_theme.dart';
import 'registration_login/screens/phone_number_auth.dart';
import 'registration_login/screens/sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = json.decode(themeStr);
  var theme = ThemeDecoder.decodeThemeData(themeJson);

  runApp(MyApp(theme!));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  MyApp(this.theme, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Constants.themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: "Login",
          theme: Constants.lightTheme,
          darkTheme: Constants.darkTheme,
          themeMode: (mode) ? ThemeMode.light : ThemeMode.dark,
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (builder, user) {
        switch (user.connectionState) {
          case ConnectionState.done:
          case ConnectionState.active:
            return (user.data != null) ? PostFeedPage() : LoginPage();
          // : const PhoneAuthenticationPage();
          // : const ProfileScreen(
          //     isNewUser: true,
          //   );
          // ? (user.data!.emailVerified)
          // ? PostFeedPage()
          // : ProfileScreen(
          //     isNewUser: true,
          //   )
          default:
            return const CustomshowLoading(
              title: 'Initalizing...',
            );
        }
      },
    );
  }
}
