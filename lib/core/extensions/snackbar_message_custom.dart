import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context,
  String message, {
  Color backgroundColor = Colors.green,
  IconData icon = Icons.check_circle,
  Duration duration = const Duration(seconds: 3),
}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    duration: duration,
    elevation: 6,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
