import 'package:ezeness/data/models/currency_model.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:ezeness/presentation/widgets/common/components/currency_selector_widget.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyWalletWidget extends StatelessWidget {
  const CurrencyWalletWidget({super.key});

  CurrencyModel currencyModel(String currency) => AppData.appCurrencyList
      .where((element) => element.currency == currency)
      .first;

  @override
  Widget build(BuildContext context) {
    String currency = context.read<SessionControllerCubit>().getCurrency();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkColor
            : AppColors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.defaultCurrency,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  currencyModel(currency).countryName ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w300),
                ),
              ),
              CurrencySelectorWidget(
                alignment: AlignmentDirectional.centerEnd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
