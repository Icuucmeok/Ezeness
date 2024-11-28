import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/common/components/common_text_widgets.dart';
import '../../../../widgets/common/components/money_value_text_widget.dart';

class TagUpRequestsWidget extends StatelessWidget {
  const TagUpRequestsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      height: .22 * size.height,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: .07 * size.height,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SemiBoldText14(
                  "Tag Up Request",
                  color: Colors.white,
                ),
                MediumText14(
                  "15",
                  color: Colors.white,
                )
              ],
            ),
          ),
          _infoWidget("Accepted", "10", size),
          _infoWidget("Pending", "5", size),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: size.height * .05,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 1,
                  color: AppColors.blackText,
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MediumText14(
                  "Total Income",
                ),
                MoneyTextWidget('999,99'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _infoWidget(String title, String value, Size size) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 4, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MediumText14(
            title,
          ),
          MediumText14(
            value,
          ),
        ],
      ),
    );
  }
}
