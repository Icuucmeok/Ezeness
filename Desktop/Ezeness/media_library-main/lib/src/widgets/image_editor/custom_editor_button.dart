import 'package:flutter/material.dart';

class CustomEditorButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  const CustomEditorButton(
      {super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        shadowColor: MaterialStateProperty.all(Colors.grey),
        elevation: MaterialStateProperty.all(5),
        side: MaterialStateProperty.all(const BorderSide(color: Colors.grey)),
        backgroundColor: MaterialStateProperty.all(Colors.grey[800]),
      ),
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      onPressed: onPressed,
    );
  }
}
