import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instrive/common/services/extensions.dart';
import 'package:instrive/common/services/navigation.dart';
import 'package:instrive/common/widgets/loading_dialog.dart';
import 'package:instrive/registration_login/screens/phone_number_auth.dart';
import 'package:instrive/registration_login/services/auth_controller.dart';

class SignInOptionsWidget extends StatelessWidget {
  SignInOptionsWidget({super.key});

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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () async => CustomNavigation.navigateBack(
                    context, PhoneAuthenticationPage()),
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 32),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone,
                      size: 18,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Phone",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () async {
                  const CustomshowLoading();
                  UserCredential userCredential =
                      await AuthController.signInWithGoogle();
                  if (userCredential.user != null) {
                    // if (!mounted) return;
                    // ignore: use_build_context_synchronously
                    AuthController.registrationNavigation(
                      context,
                      userCredential,
                    );
                  }
                },
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 32),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/crypto%2Fsearch%20(2).png?alt=media&token=24a918f7-3564-4290-b7e4-08ff54b3c94c",
                      width: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Google",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
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

// class GoogleBtn1 extends StatelessWidget {
//   final Function() onPressed;
//   const GoogleBtn1({
//     required this.onPressed,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 54,
//       margin: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: Colors.white,
//       ),
//       child: TextButton(
//         style: ButtonStyle(
//           shape: MaterialStateProperty.all(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//           ),
//         ),
//         onPressed: onPressed,
//         child: 
//       ),
//     );
//   }
// }
