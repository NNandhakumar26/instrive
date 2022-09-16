import 'package:flutter/material.dart';
import 'package:instrive/common/services/extensions.dart';
import 'package:instrive/common/widgets/loading_dialog.dart';

class WidgetUtil {
  static Future loadingDialog(BuildContext context,
      {Widget? widget, String? title}) {
    return showDialog(
      context: context,
      builder: (context) => (widget != null)
          ? widget
          : CustomLoadingDialog(
              title: title ?? '',
            ),
    );
  }

  static void showSnackBar(BuildContext context, String message,
          {bool isError = false}) async =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: message.plainText,
          action: SnackBarAction(
            label: 'Done',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        ),
      );
}
