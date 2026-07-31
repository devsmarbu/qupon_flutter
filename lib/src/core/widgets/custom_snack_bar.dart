import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qupon/src/core/constants/app_colors.dart';

class CustomSnackBar {
  static void showTop(BuildContext context, String message, {bool isError = true}) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final screenHeight = mediaQuery.size.height;

    // Scaffold inherently positions the SnackBar above the bottom safe area padding.
    // So the available height inside the Scaffold is screenHeight - bottomPadding - keyboardHeight.
    final availableHeight = screenHeight - bottomPadding - keyboardHeight;

    // To position the SnackBar below the top safe area (notch),
    // we subtract the topPadding and the SnackBar's estimated height/spacing (approx 80px).
    final bottomMargin = max(
      0.0,
      availableHeight - topPadding - (isError ? 142 : 190),
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.up,
        margin: EdgeInsets.only(
          bottom: bottomMargin,
          left: 20,
          right: 20,
        ),
      ),
    );
  }
}
