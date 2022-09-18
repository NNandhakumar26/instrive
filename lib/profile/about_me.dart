import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instrive/common/services/extensions.dart';
import 'package:instrive/common/services/navigation.dart';
import 'package:instrive/common/widgets/common_appbar.dart';
import 'package:instrive/posts/screens/posts_page.dart';
import 'package:instrive/profile/profile_screen.dart';
import 'package:instrive/registration_login/services/auth_controller.dart';

import '../main.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

//   @override
//   State<AboutPage> createState() => _AboutPageState();
// }

// class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          double.infinity,
          MediaQuery.of(context).size.height / 14,
        ),
        child: CompanyAppbar(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  onTap: () => CustomNavigation.navigateBack(
                    context,
                    ProfileScreen(),
                  ),
                  contentPadding: EdgeInsets.all(12),
                  dense: false,
                  title: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      AuthController().user!.displayName ?? '',
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  leading: (AuthController().user?.photoURL == null)
                      ? FlutterLogo()
                      : CircleAvatar(
                          radius: 24,
                          foregroundImage: CachedNetworkImageProvider(
                            AuthController().user!.photoURL!,
                          ),
                        ),
                  subtitle: 'Click to update / view profile'.subTitle,
                  trailing: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 14,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // OutlinedButton.icon(
                    //   onPressed: () {}
                    //   icon: Icon(Icons.restore_outlined),
                    //   label: 'Delete Profile'.plainText,
                    // ),
                    Spacer(),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          // if (!mounted) return;
                          CustomNavigation.navigate(context, HomeScreen());
                        },
                        icon: Icon(Icons.logout_outlined),
                        label: 'Log Out'.plainText,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8,
                  ),
                  child: Text(
                    'Your Posts',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Expanded(
                  child: PostFeedPage(
                    userId: AuthController().user!.uid,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDivider() => SizedBox(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.black87,
                  ),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
                  ),
            ),
          ],
        ),
      );
}

class ProfilePageWidget extends StatelessWidget {
  final String title;
  final List<Widget> widgets;
  const ProfilePageWidget({
    Key? key,
    required this.title,
    required this.widgets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: ThisPageTitle(title: title),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: Column(
            children: widgets,
          ),
        ),
        SizedBox(
          height: 6,
        ),
      ],
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final Widget childWidget;
  const ProjectCard({
    Key? key,
    required this.title,
    required this.childWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ThisPageTitle(title: title),
        Card(
          margin: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 8,
            ),
            child: childWidget,
          ),
        ),
      ],
    );
  }
}

class ThisPageTitle extends StatelessWidget {
  final String title;
  ThisPageTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}
