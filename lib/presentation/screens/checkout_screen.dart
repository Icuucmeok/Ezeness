import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/cart/cart_model.dart';
import '../../generated/l10n.dart';
import '../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../utils/app_modal_bottom_sheet.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/common/common.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  static const String routName = 'checkout_screen';
  const CheckoutScreen({required this.cartList, Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectedPaymentMethod = Constants.walletPaymentKey;

  @override
  Widget build(BuildContext context) {
    String currency = context.read<SessionControllerCubit>().getCurrency();
    double totalPrice = CartModel.calculateOrderTotalAmount(widget.cartList);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.checkout,
            style: Theme.of(context).textTheme.bodySmall),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        children: [
          ...widget.cartList.map((e) => CartItemWidget(cart: e)).toList(),
          Text(S.current.paymentMethod),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    AppCheckBox(
                      value:
                          selectedPaymentMethod == Constants.walletPaymentKey,
                      onChange: () => setState(() {
                        selectedPaymentMethod = Constants.walletPaymentKey;
                      }),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      S.current.walletPayment,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).primaryColorDark,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    AppCheckBox(
                      value:
                          selectedPaymentMethod == Constants.cashOnDeliveryKey,
                      onChange: () => setState(() {
                        selectedPaymentMethod = Constants.cashOnDeliveryKey;
                      }),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      S.current.cashOnDelivery,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).primaryColorDark,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.totalPrice + ":",
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(color: AppColors.whiteColor, fontSize: 16),
              ),
              Text(
                "${totalPrice} $currency",
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(color: AppColors.primaryColor, fontSize: 20.sp),
              ),
            ],
          ),
          CustomElevatedButton(
            backgroundColor: AppColors.primaryColor,
            onPressed: () {
              AppModalBottomSheet.showPayBottomSheet(
                context: context,
                orderTotalAmount: totalPrice,
                onDone: () {},
              );
            },
            child: Text(
              S.current.confirm,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(fontSize: 15, color: AppColors.whiteColor),
            ),
          ),
        ],
      ),
    );
  }
}
