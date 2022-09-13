import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instrive/common/services/extensions.dart';
import 'package:instrive/common/services/navigation.dart';
import 'package:instrive/main.dart';

class PostFeedPage extends StatelessWidget {
  const PostFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.red,
          child: OutlinedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // if (!mounted) return;

              CustomNavigation.navigate(context, MyApp());
            },
            child: 'Sign out'.plainText,
          ),
        ),
      ),
    );
  }
}
