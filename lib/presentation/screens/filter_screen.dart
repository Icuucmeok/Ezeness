import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/presentation/widgets/child_lock_widget.dart';
import 'package:ezeness/presentation/widgets/current_location_widget.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  static const String routName = 'filter_screen';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.setting),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Helpers.constVerticalDistance(size.height),
            CurrentLocationWidget(),
            Helpers.constVerticalDistance(size.height),
            ChildLockWidget(),
            Helpers.constVerticalDistance(size.height),
          ],
        ),
      ),
    );
  }
}
