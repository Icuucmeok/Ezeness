import 'package:ezeness/res/app_res.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/cubit/session_controller/session_controller_cubit.dart';

class CountryDropDownMenuWidget extends StatefulWidget {
  const CountryDropDownMenuWidget({Key? key}) : super(key: key);

  @override
  State<CountryDropDownMenuWidget> createState() =>
      _CountryDropDownMenuWidgetState();
}

class _CountryDropDownMenuWidgetState extends State<CountryDropDownMenuWidget> {
  late SessionControllerCubit _sessionControllerCubit;

  @override
  void initState() {
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      underline: Container(),
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontWeight: FontWeight.w200),
      value: _sessionControllerCubit.getAppCountry()?.value,
      alignment: AlignmentDirectional.centerEnd,
      icon: Padding(
        padding: const EdgeInsetsDirectional.only(start: 10.0),
        child: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.whiteColor
              : AppColors.darkBlue,
        ),
      ),
      menuWidth: 300,
      items: AppData.countries
          .map(
            (e) => DropdownMenuItem<String>(
              value: e.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      e.title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                          ),
                    ),
                  ),
                  Text(
                    "  (${e.value})",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: (String? v) {
        if (v == null) return;
        final country =
            AppData.countries.firstWhereOrNull((element) => element.value == v);
        if (country == null) return;
        _sessionControllerCubit.setAppCountry(country);
        setState(() {});
      },
      selectedItemBuilder: (BuildContext context) {
        return AppData.countries.map<Widget>((e) {
          return Center(
            child: Text(
              e.value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
            ),
          );
        }).toList();
      },
    );
  }
}
