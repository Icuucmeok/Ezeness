import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class DoneButtonImageEditor extends StatelessWidget {
  const DoneButtonImageEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: const Icon(
        IconlyBold.arrow_right_3,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}
