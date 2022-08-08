import 'package:flutter/material.dart';

void showSnackBar(BuildContext context,
    {Function? actionFunction, required String text, String? actionText}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    duration: const Duration(seconds: 5),
    action: SnackBarAction(
      label: actionText ?? 'dismiss',
      textColor: const Color(0xFF1A5A9E),
      onPressed: () {
        if (actionFunction != null) {
          actionFunction();
        }
      },
    ),
  ));
}