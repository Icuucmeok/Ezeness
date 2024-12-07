import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/utils/error_handler.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/app_config/app_config_cubit.dart';
import 'package:ezeness/logic/cubit/calculate_coin/calculate_coin_cubit.dart';
import 'package:ezeness/logic/cubit/convert_coin/convert_coin_cubit.dart';
import 'package:ezeness/logic/cubit/profile/profile_cubit.dart';
import 'package:ezeness/presentation/screens/panel/gold_coins_dashboard_screen/widgets/wallet_balance_widget.dart';
import 'package:ezeness/presentation/utils/app_snackbar.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalculateConvertCoinScreen extends StatefulWidget {
  const CalculateConvertCoinScreen({Key? key}) : super(key: key);

  static const String routName = 'calculate_convert_coin';

  @override
  State<CalculateConvertCoinScreen> createState() =>
      _CalculateConvertCoinScreenState();
}

class _CalculateConvertCoinScreenState
    extends State<CalculateConvertCoinScreen> {
  late CalculateCoinCubit _calculateCoinCubit;
  late ConvertCoinCubit _convertCoinCubit;
  late ProfileCubit _profileCubit;
  late User user;

  @override
  void initState() {
    _calculateCoinCubit = context.read<CalculateCoinCubit>();
    _convertCoinCubit = context.read<ConvertCoinCubit>();
    _profileCubit = context.read<ProfileCubit>();

    user = context.read<AppConfigCubit>().getUser();
    _calculateCoinCubit.calculateCoin(isTesting: true);
    //for testing purposes only remove testing after testing completed
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text(S.current.convert)),
      body: BlocBuilder<CalculateCoinCubit, CalculateCoinState>(
        bloc: _calculateCoinCubit,
        builder: (context, state) {
          // Loading case
          if (state is CalculateCoinLoading) {
            return const CenteredCircularProgressIndicator();
          }

          // error case
          if (state is CalculateCoinFailure) {
            return ErrorHandler(exception: state.exception).buildErrorWidget(
                context: context,
                retryCallback: () => _calculateCoinCubit.calculateCoin());
          }

          // success case
          if (state is CalculateCoinDone) {
            return ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05, vertical: 10),
              children: [
                // Wallet Balance Widget
                if (user.wallet != null)
                  WalletBalanceWidget(walletBalance: user.wallet ?? ''),

                SizedBox(height: 30),
                Text(
                  S.current.coinsConversion,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 16.sp,
                      ),
                ),

                SizedBox(height: 7.5),

                _buildRowItem(
                  context,
                  title: S.current.totalCoins,
                  amount: state.response.coins.toString(),
                  isCoin: true,
                ),
                _buildRowItem(
                  context,
                  title: S.current.exchangeRate,
                  amount: state.response.exchangeRate.toString(),
                ),
                _buildRowItem(
                  context,
                  title: S.current.vat,
                  amount: state.response.vat.toString(),
                ),

                _buildRowItem(
                  context,
                  title: S.current.handling,
                  amount: state.response.handling.toString(),
                ),

                Divider(
                  color: Theme.of(context).primaryColorDark,
                ),

                _buildRowItem(
                  context,
                  title: S.current.total,
                  amount: state.response.amount.toString(),
                ),
                SizedBox(height: size.height * 0.05),

                // AppButton
                BlocConsumer<ConvertCoinCubit, ConvertCoinState>(
                  listener: (context, state) async {
                    if (state is ConvertCoinDone) {
                      await _profileCubit
                          .getMyProfileSync(context.read<AppConfigCubit>());

                      AppSnackBar(
                        context: context,
                        message: S.current.coinsConvertedSuccessfully,
                      ).showSuccessSnackBar();
                      Navigator.of(context).pop();
                    }
                    if (state is ConvertCoinFailure) {
                      ErrorHandler(exception: state.exception)
                          .showErrorSnackBar(context: context);
                    }
                  },
                  builder: (context, state) {
                    return CustomElevatedButton(
                      isLoading: state is ConvertCoinLoading,
                      margin: EdgeInsets.only(bottom: 10),
                      backgroundColor: AppColors.primaryColor,
                      withBorderRadius: true,
                      onPressed: () => _convertCoinCubit.convertCoin(),
                      child: Text(
                        S.current.convert,
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 15.sp,
                                  color: AppColors.whiteColor,
                                ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildRowItem(BuildContext context,
      {required String title, required String amount, bool isCoin = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 15.sp),
            ),
          ),
          Text(
            "${!isCoin ? "AED " : ''} ${Helpers.numberFormatter(double.tryParse(amount) ?? 0)} ${isCoin ? S.current.coins : ""}",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 15.sp,
                ),
          ),
        ],
      ),
    );
  }
}
