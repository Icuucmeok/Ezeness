import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../utils/helpers.dart';

class LanguageDropDownMenuWidget extends StatefulWidget {
  const LanguageDropDownMenuWidget({Key? key}) : super(key: key);

  @override
  State<LanguageDropDownMenuWidget> createState() =>
      _LanguageDropDownMenuWidgetState();
}

class _LanguageDropDownMenuWidgetState
    extends State<LanguageDropDownMenuWidget> {
  late AppConfigCubit _appConfigCubit;
  late SessionControllerCubit _sessionControllerCubit;

  @override
  void initState() {
    _appConfigCubit = context.read<AppConfigCubit>();
    _sessionControllerCubit = context.read<SessionControllerCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      underline: Container(),
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontWeight: FontWeight.w200),
      value: Helpers.getLanguageCode(context),
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
          value: "en",
          child: Text(
            "English",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w300),
          ),
        ),
        DropdownMenuItem(
          value: "ar",
          child: Text(
            "Arabic",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w300),
          ),
        ),
        DropdownMenuItem(
          value: "fa",
          child: Text(
            "Persian",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w300),
          ),
        ),
      ],
      onChanged: (String? v) {
        _appConfigCubit.setLocale(v.toString());
        _sessionControllerCubit.restartApp();
      },
    );
  }
}
