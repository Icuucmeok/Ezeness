import 'package:ezeness/data/models/cart/cart_model.dart';
import 'package:ezeness/presentation/widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/l10n.dart';
import '../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../res/app_res.dart';
import '../utils/helpers.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({Key? key, required this.cart, this.onRemoveTap})
      : super(key: key);

  final CartModel cart;
  final VoidCallback? onRemoveTap;

  @override
  Widget build(BuildContext context) {
    double itemsPrice = cart.post.price! * cart.orderCount;
    String currency = context.read<SessionControllerCubit>().getCurrency();
    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColorDark.withOpacity(0.1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: Helpers.getPostWidgetWidth(context),
                  child: PostWidget(post: cart.post)),
              SizedBox(width: 5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(S.current.receivingMethod + ": ",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(color: AppColors.primaryColor)),
                        Text(
                            "${cart.isDelivery ? S.current.delivery : S.current.pickup}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge?.copyWith(color: AppColors.whiteColor)),
                      ],
                    ),
                    Text(
                        "${cart.isDelivery ? cart.deliveryLocation?.location : cart.post.user?.address}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge?.copyWith(color: AppColors.whiteColor)),
                    Row(
                      children: [
                        Text(S.current.orderDate + ": ",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(color: AppColors.primaryColor)),
                        Text(
                            "${cart.orderDate == null ? DateFormat("yyyy-MM-dd").format(DateTime.now()) : cart.orderDate}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge?.copyWith(color: AppColors.whiteColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(S.current.itemsPrice + ":    ",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(color: AppColors.primaryColor)),
                      Text("${cart.post.price} X ${cart.orderCount} =  ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppColors.whiteColor)),
                      Text("${itemsPrice} $currency",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(color: AppColors.whiteColor)),
                    ],
                  ),
                  if (cart.post.discount != null && cart.post.discount != 0)
                    Row(
                      children: [
                        Text(S.current.priceAfterDiscount + ":    ",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(color: AppColors.primaryColor)),
                        Text("${cart.post.discount}%    ",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(color: Colors.red)),
                        Text(
                            "${itemsPrice - (itemsPrice * cart.post.discount!) / 100} $currency",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(color: Colors.white)),
                      ],
                    ),
                  if (cart.isDelivery)
                    Row(
                      children: [
                        Text(S.current.deliveryCharges + ":    ",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(color: AppColors.primaryColor)),
                        Text("${cart.post.deliveryCharge} $currency",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(color: AppColors.whiteColor)),
                      ],
                    ),
                  Row(
                    children: [
                      Text(S.current.totalPrice + ":    ",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(color: AppColors.primaryColor)),
                      if (cart.post.discount != null &&
                          cart.post.discount != 0) ...{
                        Text(
                            "${(itemsPrice - (itemsPrice * cart.post.discount!) / 100) + (cart.isDelivery ? cart.post.deliveryCharge! : 0)} $currency",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(color: Colors.green)),
                      } else ...{
                        Text(
                            "${itemsPrice + (cart.isDelivery ? cart.post.deliveryCharge! : 0)} $currency",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(color: Colors.green)),
                      },
                    ],
                  ),
                ],
              ),
              if (onRemoveTap != null)
                IconButton(
                  onPressed: onRemoveTap,
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
