import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instrive/common/services/extensions.dart';
import 'package:instrive/common/services/navigation.dart';
import 'package:instrive/main.dart';
import 'package:instrive/registration_login/services/auth_controller.dart';

class PostFeedPage extends StatelessWidget {
  final user = AuthController.user;
  PostFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.red,
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: CachedNetworkImage(
                    imageUrl: user!.photoURL!,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.face_outlined,
                    ),
                  ),
                ),
                title: Text(
                  user!.displayName ?? 'User',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: 'Click To Edit Profile'.plainText,
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.restore_outlined),
                    label: 'Reset Profile'.plainText,
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      // if (!mounted) return;
                      CustomNavigation.navigate(context, MyApp());
                    },
                    icon: Icon(Icons.logout_outlined),
                    label: 'Log Out'.plainText,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
