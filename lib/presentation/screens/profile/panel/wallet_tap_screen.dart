import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/app_config/app_config_cubit.dart';
import 'package:ezeness/logic/cubit/credit_card/card_bloc.dart';
import 'package:ezeness/logic/cubit/payment/payment_cubit.dart';
import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:ezeness/presentation/router/app_router.dart';
import 'package:ezeness/presentation/screens/panel/gold_coins_dashboard_screen/gold_coins_dashboard_screen.dart';
import 'package:ezeness/presentation/screens/panel/gold_coins_dashboard_screen/widgets/wallet_balance_widget.dart';
import 'package:ezeness/presentation/screens/panel/wallet_screen/widgets/top_up_wallet_header_widget.dart';
import 'package:ezeness/presentation/screens/profile/panel/widgets/credit_cards_list.dart';
import 'package:ezeness/presentation/screens/profile/panel/widgets/currency_wallet_widget.dart';
import 'package:ezeness/presentation/utils/app_modal_bottom_sheet.dart';
import 'package:ezeness/presentation/widgets/common/components/elevated_card_arrow_widget.dart';
import 'package:ezeness/presentation/widgets/common/components/lift_up_gold_coins_widget.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../data/models/credit_card/credit_card_model.dart';
import '../../../widgets/common/common.dart';

class WalletTapScreen extends StatefulWidget {
  const WalletTapScreen();

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
          TopUpWalletHeaderWidget(_paymentCubit,
              walletBalance: user.wallet ?? ''),
          20.verticalSpace,

          // Gold coins
          // 20.verticalSpace,
          UpdatedLiftUpGoldCoinsWidget(
            onTap: () => Navigator.of(AppRouter.mainContext)
                .pushNamed(GoldCoinsDashboardScreen.routName),
            withConvert: true,
          ),
          15.verticalSpace,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'CARDS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: "Add Card",
                  icon: Icon(Icons.add_circle, color: Colors.blue),
                  onPressed: () {
                    final TextEditingController cardHolderController =
                        TextEditingController();
                    final TextEditingController cardNumberController =
                        TextEditingController();
                    final TextEditingController expiryDateController =
                        TextEditingController();
                    AppModalBottomSheet.showMainModalBottomSheet(
                        context: context,
                        // height: MediaQuery.sizeOf(context).height,
                        scrollableContent: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            left: 16,
                            right: 16,
                            top: 16,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Add Card',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 16),
                              EditTextField(
                                hintText: S.current.cardHolderName,
                                controller: cardHolderController,
                                label: S.current.cardHolderName,
                                // isNumber: true,
                              ),
                              SizedBox(height: 16),
                              EditTextField(
                                hintText: S.current.cardNumber,
                                controller: cardNumberController,
                                label: S.current.cardNumber,
                                isNumber: true,
                              ),
                              SizedBox(height: 16),
                              EditTextField(
                                hintText: S.current.expirtDate,
                                controller: expiryDateController,
                                label: S.current.expirtDate,
                                isNumber: true,
                              ),
                              SizedBox(height: 16),
                              BlocBuilder<CardBloc, CardState>(
                                builder: (context, state) {
                                  return CustomElevatedButton(
                                    isLoading: state is PaymentLoading,
                                    margin: EdgeInsets.only(bottom: 30),
                                    backgroundColor: AppColors.primaryColor,
                                    onPressed: () {
                                      final newCard = CardModel(
                                        cardType: 'Visa',
                                        lastDigits: cardNumberController.text
                                            .substring(cardNumberController
                                                    .text.length -
                                                4),
                                        cardHolderName:
                                            cardHolderController.text,
                                        expiryDate: expiryDateController.text,
                                      );

                                      context
                                          .read<CardBloc>()
                                          .add(AddCardEvent(newCard));
                                      Navigator.pop(context);
                                    },
                                    child: Text(S.current.addCreditCard,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge
                                            ?.copyWith(
                                                fontSize: 15,
                                                color: Colors.white)),
                                  );
                                },
                              )
                            ],
                          ),
                        ));
                  },
                ),
              ),
            ],
          ),
          10.verticalSpace,

          BlocBuilder<CardBloc, CardState>(
            builder: (context, state) {
              if (state is CardLoadedState) {
                final cardList = state.cards;
                return CreditCardsList(cardList);
              } else if (state is CardInitialState) {
                return Center(child: Text('No cards available'));
              } else if (state is CardErrorState) {
                return Center(child: Text(state.message));
              }
              return Center(child: CircularProgressIndicator());
            },
          ),

          10.verticalSpace,

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
