import 'package:flutter/material.dart';

void showErrorSnackBar(String message, BuildContext context) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[700],
        duration: const Duration(seconds: 1),
      ),
    );
