import 'package:flutter/material.dart';

import '../../../../../res/app_res.dart';
import '../../../../widgets/common/components/common_text_widgets.dart';

class AddCardWidget extends StatelessWidget {
  final String title;
  const AddCardWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoldText18(
            title,
          ),
          Container(
            width: size.width * .08,
            height: size.height * .08,
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.shadowColor, width: size.width * .014)),
            child: Icon(
              Icons.add,
              color: AppColors.shadowColor,
              size: size.width * .05,
            ),
          ),
        ],
      ),
    );
  }
}
