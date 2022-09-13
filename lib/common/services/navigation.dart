import 'package:flutter/material.dart';

class CustomNavigation {
  static Future<T?> navigate<T>(BuildContext context, Widget widget) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      PageRouteBuilder<T>(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return widget;
        },
        transitionsBuilder:
            (___, Animation<double> animation, ____, Widget child) {
          return SlideTransition(
            position: Tween(
                    begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
                .animate(animation),
            child: child,
          );
        },
      ),
      (route) => false,
    );
  }

  static Future<T?> navigateBack<T>(BuildContext context, Widget widget) {
    return Navigator.push<T>(
      context,
      PageRouteBuilder<T>(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return widget;
        },
        transitionsBuilder:
            (___, Animation<double> animation, ____, Widget child) {
          return SlideTransition(
            position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                .animate(animation),
            child: child,
          );
          // return FadeTransition(
          //   opacity: animation,
          //   child: RotationTransition(
          //     turns:
          //         Tween<double>(begin: 0.5, end: 1.0)
          //             .animate(animation),
          //     child: child,
          //   ),
          // );
        },
      ),
    );
  }
}
