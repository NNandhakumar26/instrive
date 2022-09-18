import 'package:flutter/material.dart';
import 'package:instrive/common/services/extensions.dart';

class CustomshowLoading extends StatelessWidget {
  final String title;
  const CustomshowLoading({this.title = 'Loading...', Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 16,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            CircularProgressIndicator(
              color: Colors.grey.shade300,
            ),
            16.width,
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button!.copyWith(
                      fontSize: 14,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
