// ignore_for_file: public_member_api_docs, sort_constructors_first
// The ColumnBuilder class is a custom widget that helps in generating a column of widgets dynamically.
// It takes an [itemBuilder] function, `itemCount`, and optional parameters to customize the layout of the column.

import 'package:flutter/material.dart';

class ColumnBuilder extends StatelessWidget {
  const ColumnBuilder({
    Key? key,
    required this.itemBuilder,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    required this.itemCount,
    this.padding,
  }) : super(key: key);

  /// The [itemBuilder] is a callback function that takes the [BuildContext] and [index] as parameters
  /// and returns the widget for the corresponding index.
  final IndexedWidgetBuilder? itemBuilder;

  /// The [mainAxisAlignment] determines how the widgets are positioned along the main axis (vertical axis) of the column.
  final MainAxisAlignment mainAxisAlignment;

  /// The [mainAxisSize] determines the height of the column. It can be either [MainAxisSize.max] (occupy all available height)
  /// or [MainAxisSize.min] (take only the necessary height).
  final MainAxisSize mainAxisSize;

  /// The [crossAxisAlignment] determines how the widgets are aligned horizontally within each column.
  final CrossAxisAlignment crossAxisAlignment;

  /// The [textDirection] specifies the reading order of the column (left-to-right or right-to-left).
  final TextDirection? textDirection;

  /// The [verticalDirection] determines the order in which the widgets are placed vertically in the column.
  final VerticalDirection verticalDirection;

  /// The [itemCount] specifies the number of items in the column.
  final int? itemCount;

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        textDirection: textDirection,
        verticalDirection: verticalDirection,

        /// Generate a list of widgets using the [itemBuilder] function and convert it to a list using [toList()].
        children:
            List.generate(itemCount!, (index) => itemBuilder!(context, index))
                .toList(),
      ),
    );
  }
}
