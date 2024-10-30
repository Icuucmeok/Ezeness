import 'dart:convert';

import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../../../logic/cubit/payment/payment_cubit.dart';
import '../../../../../logic/cubit/profile/profile_cubit.dart';
import '../../../../utils/app_modal_bottom_sheet.dart';
import '../../../../widgets/common/common.dart';

class TopUpWalletHeaderWidget extends StatefulWidget {
  final PaymentCubit paymentCubit;
  const TopUpWalletHeaderWidget(this.paymentCubit, {Key? key})
      : super(key: key);

  @override
  State<TopUpWalletHeaderWidget> createState() =>
      _TopUpWalletHeaderWidgetState();
}

class _TopUpWalletHeaderWidgetState extends State<TopUpWalletHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

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
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkColor
                  : AppColors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top up wallet',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontSize: 16),
                ),
                GestureDetector(
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
                                        if (!_keyForm.currentState!
                                            .validate()) {
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
                                                  fontSize: 15,
                                                  color: Colors.white)),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: size.width * .075,
                    height: size.height * .075,
                    decoration: BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.shadowColor,
                              spreadRadius: size.width * .003,
                              blurRadius: size.width * .003,
                              offset:
                                  Offset(size.width * .003, size.width * .003))
                        ],
                        border: Border.all(
                            color: AppColors.whiteColor,
                            width: size.width * .01)),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: size.width * .045,
                    ),
                  ),
                ),
              ],
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
