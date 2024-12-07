import 'package:ezeness/data/models/currency_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/user/user.dart';
import '../../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../../res/app_res.dart';

class CurrencySelectorWidget extends StatefulWidget {
  const CurrencySelectorWidget({
    Key? key,
    this.alignment = AlignmentDirectional.centerStart,
  }) : super(key: key);

  final AlignmentGeometry alignment;

  @override
  State<CurrencySelectorWidget> createState() => _CurrencySelectorWidgetState();
}

class _CurrencySelectorWidgetState extends State<CurrencySelectorWidget> {
  late SessionControllerCubit _sessionControllerCubit;
  @override
  void initState() {
    _sessionControllerCubit = context.read<SessionControllerCubit>();

    super.initState();
  }

  CurrencyModel currencyModel(String currency) => AppData.appCurrencyList
      .where((element) => element.currency == currency)
      .first;

  @override
  Widget build(BuildContext context) {
    context.select<AppConfigCubit, User>((bloc) => bloc.state.user);
    String currency = context.read<SessionControllerCubit>().getCurrency();

    return DropdownButton<CurrencyModel>(
      underline: Container(),
      value: currencyModel(currency),
      dropdownColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkColor
          : AppColors.grey,
      icon: Padding(
        padding: const EdgeInsetsDirectional.only(start: 10.0),
        child: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.whiteColor
              : AppColors.darkBlue,
        ),
      ),
      alignment: widget.alignment,
      items: AppData.appCurrencyList.map((CurrencyModel items) {
        return DropdownMenuItem(
          value: items,
          child: Text(
            items.currency,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
          ),
        );
      }).toList(),
      onChanged: (CurrencyModel? newValue) {
        _sessionControllerCubit.setCurrency(newValue!.currency);
        _sessionControllerCubit.isGetCurrentCurrency = false;
        _sessionControllerCubit.restartApp();
      },
    );
  }
}
