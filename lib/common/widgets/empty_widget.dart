import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String message;
  final TextAlign textAlign;
  const EmptyWidget(this.message, {Key? key, this.textAlign = TextAlign.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: textAlign,
        // style: Theme.of(context).textTheme.subtitle1!.copyWith(
        //       // color: Colors.black26,
        //       // fontWeight: FontWeight.w600,
        //       // fontSize: 15,
        //     ),
      ),
    );
  }
}
