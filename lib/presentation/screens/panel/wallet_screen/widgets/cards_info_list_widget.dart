

import 'package:flutter/material.dart';

import 'add_card_widget.dart';
import 'card_info_item_widget.dart';

class CardInfoListWidget extends StatelessWidget {
  const CardInfoListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.sizeOf(context);
    return Container(
      child: Column(
        children: [
          AddCardWidget(title: "Cards"),
          CardInfoItemWidget(),
          CardInfoItemWidget(),
        ],
      ),
    );
  }
}
