import 'package:flutter/material.dart';
import 'package:instrive/common/services/extensions.dart';
import 'package:instrive/common/services/navigation.dart';
import 'package:instrive/profile/about_me.dart';

import '../../main.dart';

class CompanyAppbar extends StatelessWidget {
  final bool showProfileIcon;
  final Widget? actionWidget;
  CompanyAppbar({
    super.key,
    this.showProfileIcon = false,
    this.actionWidget,
  });
  // final ThemeNotifier themeNotifier = ThemeNotifier();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: 'Instrive'.plainText,
      leadingWidth: 0,
      leading: SizedBox.shrink(),
      actions: [
        if (actionWidget != null) actionWidget!,
        if (showProfileIcon)
          IconButton(
            onPressed: () => CustomNavigation.navigateBack(
              context,
              AboutPage(),
            ),
            icon: Icon(
              Icons.face,
            ),
          ),
        IconButton(
          onPressed: () {
            Constants.themeNotifier.value = !Constants.themeNotifier.value;
          },
          icon: Icon(
            Icons.sunny,
          ),
        ),
      ],
    );
  }
}
