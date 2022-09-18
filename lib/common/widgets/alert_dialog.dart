import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final BuildContext context;
  final String title;
  final List<Widget> columnWidgets;
  final Function? onDone;
  final Function? onCancel;
  final String primaryButton;
  final String secondaryButton;
  final bool noActions;

  CustomAlertDialog({
    Key? key,
    required this.context,
    required this.title,
    required this.columnWidgets,
    this.onDone,
    this.onCancel,
    this.primaryButton = 'Done',
    this.secondaryButton = 'Cancel',
    this.noActions = false,
  }) : super(key: key);
  // const CustomshowLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline6!.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
      ),
      content: Column(
        children: columnWidgets,
      ),
      actions: (!noActions)
          ? [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(16),
                ),
                onPressed: () {
                  if (onCancel != null) {
                    onCancel!();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  secondaryButton,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.87),
                  padding: EdgeInsets.all(8),
                ),
                child: Text(
                  primaryButton,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.white.withOpacity(0.87),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                ),
                onPressed: () {
                  if (onDone != null) {
                    onDone!();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ]
          : [],
    );
  }
}
