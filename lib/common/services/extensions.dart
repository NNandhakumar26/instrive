import 'package:flutter/material.dart';

extension IntExtensions on int? {
  /// Leaves given height of space
  Widget get height => SizedBox(height: this?.toDouble());

  /// Leaves given width of space
  Widget get width => SizedBox(width: this?.toDouble());
}

extension StringExtensions on String? {
  /// Leaves given height of space
  Widget get plainText => Text(this ?? '');

  Widget get centerText => Text(
        this ?? '',
        textAlign: TextAlign.center,
      );

  Widget get underlineText => Text(
        this ?? '',
        style: const TextStyle(
          decoration: TextDecoration.underline,
        ),
      );

  Widget get loadingDialog => Dialog(
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
                  this ?? '',
                  textAlign: TextAlign.center,
                  // style: Theme.of(context).textTheme.button!.copyWith(
                  //       fontSize: 14,
                  //       color: Colors.black87,
                  //     ),
                ),
              )
            ],
          ),
        ),
      );
}