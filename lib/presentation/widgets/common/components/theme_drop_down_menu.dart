import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/app_config/app_config_cubit.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeDropDownMenuWidget extends StatefulWidget {
  const ThemeDropDownMenuWidget({super.key});

  @override
  State<ThemeDropDownMenuWidget> createState() =>
      _ThemeDropDownMenuWidgetState();
}

class _ThemeDropDownMenuWidgetState extends State<ThemeDropDownMenuWidget> {
  late AppConfigCubit _appConfigCubit;
  @override
  void initState() {
    _appConfigCubit = context.read<AppConfigCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = _appConfigCubit.getUser();
    return DropdownButton(
      underline: Container(),
      value: user.themeMood,
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
      items: [
        DropdownMenuItem(
          value: Constants.defaultSystemThemeKey,
          child: Text(
            S.current.systemDefault,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w300),
          ),
        ),
        DropdownMenuItem(
          value: Constants.darkThemeKey,
          child: Text(
            S.current.darkTheme,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w300),
          ),
        ),
        DropdownMenuItem(
          value: Constants.lightThemeKey,
          child: Text(
            S.current.lightTheme,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w300),
          ),
        ),
      ],
      onChanged: (String? v) {
        _appConfigCubit.setUser(user.copyWith(themeMood: v), isEditTheme: true);
      },
    );
  }
}
