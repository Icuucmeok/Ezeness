import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/app_config/app_config_cubit.dart';
import 'package:ezeness/logic/cubit/payment/payment_cubit.dart';
import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:ezeness/presentation/router/app_router.dart';
import 'package:ezeness/presentation/screens/panel/gold_coins_dashboard_screen/gold_coins_dashboard_screen.dart';
import 'package:ezeness/presentation/screens/panel/gold_coins_dashboard_screen/widgets/wallet_balance_widget.dart';
import 'package:ezeness/presentation/screens/panel/wallet_screen/widgets/top_up_wallet_header_widget.dart';
import 'package:ezeness/presentation/screens/profile/panel/widgets/currency_wallet_widget.dart';
import 'package:ezeness/presentation/utils/app_modal_bottom_sheet.dart';
import 'package:ezeness/presentation/widgets/common/components/elevated_card_arrow_widget.dart';
import 'package:ezeness/presentation/widgets/common/components/lift_up_gold_coins_widget.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WalletTapScreen extends StatefulWidget {
  const WalletTapScreen({super.key});

  @override
  State<WalletTapScreen> createState() => _WalletTapScreenState();
}

class _WalletTapScreenState extends State<WalletTapScreen> {
  late PaymentCubit _paymentCubit;
  late SessionControllerCubit _sessionControllerCubit;

  @override
  void initState() {
    _paymentCubit = context.read<PaymentCubit>();
    _sessionControllerCubit = context.read<SessionControllerCubit>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.select<AppConfigCubit, User>((bloc) => bloc.state.user);
    Size size = MediaQuery.of(context).size;
    User user = context.read<AppConfigCubit>().getUser();
    bool isLoggedIn = _sessionControllerCubit.isLoggedIn();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance
          10.verticalSpace,
          WalletBalanceWidget(walletBalance: user.wallet ?? ''),

          // Top up wallet
          8.verticalSpace,
          TopUpWalletHeaderWidget(_paymentCubit),
          20.verticalSpace,

          // Gold coins
          // 20.verticalSpace,
          LiftUpGoldCoinsWidget(
            onTap: () => Navigator.of(AppRouter.mainContext)
                .pushNamed(GoldCoinsDashboardScreen.routName),
            withConvert: true,
          ),
          15.verticalSpace,

          // BOOST & ADS Button
          if (isLoggedIn && AppData.isShowBoostButton)
            ElevatedCardWithArrowWidget(
              onTap: () => AppModalBottomSheet.viewBoostBottomSheet(
                context,
                toSelectPost: true,
              ),
              title: S.current.adBoostPlans,
              icon: SvgPicture.asset(
                Assets.assetsIconsStoreSolid,
                height: size.height * .035,
                width: size.width * .04,
                colorFilter:
                    ColorFilter.mode(AppColors.secondary, BlendMode.srcIn),
              ),
            ),

          // ElevatedOptionWithSubtitleWidget(
          //   title: 'Default Currency',
          //   child: CurrencySelectorWidget(
          //     alignment: AlignmentDirectional.center,
          //   ),
          //   icon: Icon(
          //     IconlyBold.wallet,
          //     color: Theme.of(context).brightness == Brightness.dark
          //         ? AppColors.whiteColor
          //         : AppColors.blackText,
          //     size: 40,
          //   ),
          // ),

          CurrencyWalletWidget(),
          15.verticalSpace,
        ],
      ),
    );
  }
}
