import 'package:flutter/material.dart';
import 'package:instrive/common/services/extensions.dart';

class GoogleSignInWidget extends StatelessWidget {
  GoogleSignInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
          child: Row(
            children: [
              customDivider,
              "Or sign in with".centerText,
              customDivider,
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              height: 50,
              child: OutlinedButton(
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 32),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    // Icon(
                    //   Icons.facebook_rounded,
                    //   // Icons.twitter,
                    //   size: 20,
                    // ),
                    // SizedBox(
                    //   width: 5,
                    // ),
                    Text(
                      "Google",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                // shape: StadiumBorder(),
                // highlightedBorderColor: Colors.black,
                // borderSide: BorderSide(color: Colors.black),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  final customDivider = Expanded(
    child: Divider(
      color: Colors.grey.shade300,
      thickness: 0.5,
      indent: 8,
      endIndent: 8,
    ),
  );
}
