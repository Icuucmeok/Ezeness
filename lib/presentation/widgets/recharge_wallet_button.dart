import 'dart:convert';

import 'package:ezeness/logic/cubit/payment/payment_cubit.dart';
import 'package:ezeness/logic/cubit/profile/profile_cubit.dart';
import 'package:ezeness/presentation/utils/app_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../generated/l10n.dart';
import '../../logic/cubit/app_config/app_config_cubit.dart';
import '../../res/app_res.dart';
import 'common/common.dart';

class RechargeWalletButton extends StatefulWidget {
  final PaymentCubit paymentCubit;
  const RechargeWalletButton(this.paymentCubit, {Key? key}) : super(key: key);

  @override
  State<RechargeWalletButton> createState() => _RechargeWalletButtonState();
}

class _RechargeWalletButtonState extends State<RechargeWalletButton> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
        bloc: widget.paymentCubit,
        listener: (context, state) {
          if (state is PaymentLoaded) {
            Navigator.of(context).pop();
            openPaymentSheet(jsonDecode(state.response));
          }
        },
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              onTap: () {
                final _keyForm = GlobalKey<FormState>();
                final TextEditingController amountController =
                    TextEditingController();
                AppModalBottomSheet.showMainModalBottomSheet(
                  context: context,
                  scrollableContent: Form(
                    key: _keyForm,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Text(
                            S.current.howMuchYouWantToRecharge,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(height: 8.h),
                          EditTextField(
                            controller: amountController,
                            label: S.current.price,
                            isNumber: true,
                          ),
                          SizedBox(height: 8.h),
                          BlocBuilder<PaymentCubit, PaymentState>(
                              bloc: widget.paymentCubit,
                              builder: (context, state) {
                                return CustomElevatedButton(
                                  isLoading: state is PaymentLoading,
                                  margin: EdgeInsets.only(bottom: 30),
                                  backgroundColor: AppColors.primaryColor,
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (!_keyForm.currentState!.validate()) {
                                      return;
                                    }
                                    widget.paymentCubit.createPaymentIntent(
                                        amountController.text);
                                  },
                                  child: Text(S.current.pay,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.copyWith(
                                              fontSize: 15.sp,
                                              color: Colors.white)),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                );
              },
              title: Text(S.current.rechargeWallet),
              trailing: Icon(Icons.account_balance_wallet_outlined,
                  color: AppColors.primaryColor),
            ),
          );
        });
  }

  Future<void> openPaymentSheet(Map<String, dynamic> data) async {
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: data["data"]['client_secret'],
      applePay: PaymentSheetApplePay(merchantCountryCode: 'AE'),
      merchantDisplayName: "Name",
      style: ThemeMode.dark,
    ));
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        context
            .read<ProfileCubit>()
            .getMyProfile(context.read<AppConfigCubit>());
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!"),
                    ],
                  ),
                ));
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
    ;
  }
}
