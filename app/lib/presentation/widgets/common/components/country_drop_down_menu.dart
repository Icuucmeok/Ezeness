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
  late TextStyle _bodyMediumTextStyle;

  @override
  void initState() {
    super.initState();
    _sessionControllerCubit = context.read<SessionControllerCubit>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bodyMediumTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 15,
        ) ??
        const TextStyle(fontSize: 15);
  }

  @override
  Widget build(BuildContext context) {
    final selectedCountry = _sessionControllerCubit.getAppCountry();
    final currentCountryValue = selectedCountry?.value ?? '';

    return Builder(
      builder: (context) {
        return Container(
          width: 300,
          child: DropdownButton<String>(
            value: currentCountryValue.isNotEmpty ? currentCountryValue : null,
            onChanged: (String? selectedValue) {
              if (selectedValue == null) return;
              final country = AppData.countries.firstWhereOrNull(
                (element) => element.value == selectedValue,
              );
              if (country != null) {
                _sessionControllerCubit.setAppCountry(country);
              }
            },
            underline: const SizedBox(),
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
            isExpanded: true,
            items: AppData.countries.map((country) {
              return DropdownMenuItem<String>(
                value: country.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        country.title,
                        overflow: TextOverflow.ellipsis,
                        style: _bodyMediumTextStyle,
                      ),
                    ),
                    Text(
                      "  (${country.value})",
                      textAlign: TextAlign.start,
                      style: _bodyMediumTextStyle.copyWith(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }).toList(),
            selectedItemBuilder: (BuildContext context) {
              return AppData.countries.map<Widget>((country) {
                return Center(
                  child: Text(
                    country.value,
                    style: _bodyMediumTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                );
              }).toList();
            },
            hint: Text(
              'Select Country',
              style: _bodyMediumTextStyle.copyWith(color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
