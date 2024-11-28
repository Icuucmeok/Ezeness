import 'package:ezeness/presentation/widgets/common/components/common_text_widgets.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';

class CustomRoundedElevatedButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Size? fixedSize;
  const CustomRoundedElevatedButton(
      {Key? key, required this.title, required this.onPressed, this.fixedSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: AppColors.secondary,
        fixedSize: fixedSize ?? Size(size.width, size.height * .06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              (fixedSize != null ? (fixedSize!.width / 6) : size.width) *
                  .2), // Adjust for desired roundness
        ),
      ),
      child: MediumText14(
        title,
        color: Colors.white,
      ),
    );
  }
}
