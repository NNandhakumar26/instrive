import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instrive/common/widgets/loading_dialog.dart';
import 'package:instrive/posts/screens/posts_page.dart';
import 'package:instrive/profile/profile_screen.dart';
import 'package:instrive/registration_login/screens/login_screen.dart';
import 'package:instrive/registration_login/services/auth_controller.dart';
import 'common/services/themes.dart';
import 'registration_login/screens/phone_number_auth.dart';
import 'registration_login/screens/sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _notifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: "Login",
          theme: CustomTheme.lightTheme,
          darkTheme: CustomTheme.darkTheme,
          themeMode: mode,
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
            return (user.data != null)
                ? (user.data!.emailVerified)
                    ? PostFeedPage()
                    : ProfileScreen(
                        isNewUser: true,
                      )
                : LoginPage();
          // : const PhoneAuthenticationPage();
          // : const ProfileScreen(
          //     isNewUser: true,
          //   );
          default:
            return const CustomshowLoading(
              title: 'Initalizing...',
            );
        }
      },
    );
  }
}
