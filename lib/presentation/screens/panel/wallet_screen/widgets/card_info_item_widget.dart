import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/common/components/common_text_widgets.dart';

class CardInfoItemWidget extends StatelessWidget {
  const CardInfoItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RadioMenuButton(
            value: true,
            groupValue: true,
            style: ButtonStyle(
              iconColor: WidgetStateProperty.all(AppColors.blackColor),
            ),
            onChanged: (val) {},
            child: SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RegularText14(
                      'Visa **** 1234',
                    ),
                    RegularText14(
                      'Card holder name',
                    ),
                    RegularText14(
                      'Expires 01/2025',
                    ),
                  ],
                ),
                Icon(
                  Icons.credit_score,
                  color: AppColors.blackColor,
                  size: size.width * .1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
