import 'package:ezeness/presentation/router/app_router.dart';
import 'package:ezeness/presentation/screens/panel/gold_coins_dashboard_screen/gold_coins_dashboard_screen.dart';
import 'package:ezeness/presentation/screens/panel/wallet_screen/widgets/top_up_wallet_header_widget.dart';
import 'package:ezeness/presentation/screens/profile/panel/widgets/currency_wallet_widget.dart';
import 'package:ezeness/presentation/widgets/common/components/lift_up_gold_coins_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/user/user.dart';
import '../../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../../logic/cubit/payment/payment_cubit.dart';
import '../../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../widgets/common/common.dart';
import '../../../widgets/common/components/wallet_card_widget.dart';

class WalletScreen extends StatefulWidget {
  static const String routName = 'wallet_screen';
  final args;

  const WalletScreen({this.args, Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool withBack = false;
  late PaymentCubit _paymentCubit;

  @override
  void initState() {
    _paymentCubit = context.read<PaymentCubit>();
    if (widget.args != null) {
      withBack = widget.args["withBack"] ?? false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.select<AppConfigCubit, User>((bloc) => bloc.state.user);
    bool isLoggedIn = context.read<SessionControllerCubit>().isLoggedIn();
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: withBack ? AppBar() : null,
      body: isLoggedIn
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WalletCardWidget(
                      iconColor: Theme.of(context).primaryColorDark,
                    ),
                    SizedBox(height: size.height * .02),
                    LiftUpGoldCoinsWidget(
                      onTap: () => Navigator.of(AppRouter.mainContext)
                          .pushNamed(GoldCoinsDashboardScreen.routName),
                      withConvert: true,
                    ),
                    SizedBox(height: size.height * .02),

                    TopUpWalletHeaderWidget(_paymentCubit),
                    SizedBox(height: size.height * .02),
                    // ElevatedOptionWithSubtitleWidget(
                    //   title: 'Default Currency',
                    //   child: CurrencySelectorWidget(
                    //     alignment: AlignmentDirectional.center,
                    //   ),
                    //   icon: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Icon(
                    //       IconlyBold.wallet,
                    //       color: Theme.of(context).brightness == Brightness.dark
                    //           ? AppColors.whiteColor
                    //           : AppColors.blackText,
                    //       size: size.width * .09,
                    //     ),
                    //   ),
                    // ),

                    CurrencyWalletWidget(),

                    SizedBox(height: size.height * .02),
                  ],
                ),
              ),
            )
          : const GuestCard(),
    );
  }
}
