import 'package:ezeness/presentation/router/app_router.dart';
import 'package:ezeness/presentation/utils/app_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:ezeness/data/models/cart/cart_model.dart';
import 'package:ezeness/presentation/utils/app_snackbar.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import '../../data/models/user/user.dart';
import '../../data/models/pay_item_body.dart';
import '../../data/models/post/post.dart';
import '../../data/models/day_time.dart';
import '../../data/models/pick_location_model.dart';
import '../../generated/l10n.dart';
import '../../logic/cubit/app_config/app_config_cubit.dart';
import '../../logic/cubit/cart/cart_cubit.dart';
import '../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../screens/ads_boost/banner/banner_plans_screen.dart';
import '../screens/ads_boost/select_post_to_add_boost_screen.dart';
import '../screens/panel/shopping_cart_screen.dart';
import '../screens/panel/wallet_screen/wallet_screen.dart';
import '../widgets/common/common.dart';
import 'app_dialog.dart';
import 'helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class AppModalBottomSheet {
  AppModalBottomSheet._();

  static dynamic showMainModalBottomSheet<T>({
    required BuildContext context,
    double radius = 16.0,
    required Widget scrollableContent,
    Widget? fixesContent,
    double? height,
    VoidCallback? onScrollEnd,
    bool isExpandable = false,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    height = height ?? screenHeight / 1.5;
    final initialChildSize = (height / screenHeight).clamp(0.25, 0.9);

    return showModalBottomSheet(
      backgroundColor: !isExpandable
          ? Theme.of(context).scaffoldBackgroundColor
          : Colors.transparent,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
      ),
      builder: (context) {
        return isExpandable
            ? Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: DraggableScrollableSheet(
                          initialChildSize: initialChildSize,
                          minChildSize: 0.25,
                          maxChildSize: 0.9,
                          builder: (context, scrollController) {
                            if(onScrollEnd!=null){
                              scrollController.addListener(() {
                                if (scrollController.position.maxScrollExtent ==
                                    scrollController.offset) {
                                  onScrollEnd();
                                }
                              });
                            }
                            return Container(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(radius)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 40.0,
                                    child: Center(
                                      child: Container(
                                        width: 60.0,
                                        height: 5.0,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[700],
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (fixesContent != null) fixesContent,
                                  Expanded(
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: scrollableContent,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )),
                ],
              )
            : SizedBox(
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 40.0,
                      child: Center(
                        child: Container(
                          width: 60.0,
                          height: 5.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                    if (fixesContent != null) fixesContent,
                    Expanded(child: scrollableContent),
                  ],
                ),
              );
      },
    );
  }

  static dynamic showDayTimeBottomSheet(
      {required BuildContext context, required List<DayTime> dayList}) {
    return showMainModalBottomSheet(
        context: context,
        scrollableContent: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: dayList
                .map((e) => Container(
                      padding: EdgeInsets.all(12.w),
                      margin: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkColor.withOpacity(0.5)
                            : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(e.dayName!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(fontSize: 15))),
                          TextButton(
                              onPressed: () {
                                showRoundedTimePicker(
                                  context: context,
                                  barrierDismissible: true,
                                  theme: ThemeData(brightness: Brightness.dark),
                                  initialTime: TimeOfDay.fromDateTime(
                                      e.fromTime == null
                                          ? DateTime.now()
                                          : DateFormat.Hm("en")
                                              .parse(e.fromTime.toString())),
                                ).then((time) {
                                  if (time == null) return;
                                  if (e.toTime != null) {
                                    DateTime parsedTime = DateFormat.Hm("en")
                                        .parse("${time.hour}:${time.minute}");
                                    final DateTime disableTime =
                                        DateFormat.Hm("en")
                                            .parse(e.toTime.toString());
                                    if (parsedTime.isAfter(disableTime)) {
                                      AppToast(
                                              message: S.current
                                                  .timeMustBeBefore(
                                                      e.toTime.toString()))
                                          .show();
                                      return;
                                    }
                                  }
                                  setState(() {
                                    e.fromTime =
                                        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                                  });
                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    S.current.fromTime + ":",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(e.fromTime ?? "00:00",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.copyWith(
                                              color: AppColors.primaryColor)),
                                ],
                              )),
                          TextButton(
                              onPressed: () {
                                showRoundedTimePicker(
                                  context: context,
                                  barrierDismissible: true,
                                  theme: ThemeData(brightness: Brightness.dark),
                                  initialTime: TimeOfDay.fromDateTime(
                                      e.toTime == null
                                          ? DateTime.now()
                                          : DateFormat.Hm("en")
                                              .parse(e.toTime.toString())),
                                ).then((time) {
                                  if (time == null) return;
                                  if (e.fromTime != null) {
                                    DateTime parsedTime = DateFormat.Hm("en")
                                        .parse("${time.hour}:${time.minute}");
                                    final DateTime disableTime =
                                        DateFormat.Hm("en")
                                            .parse(e.fromTime.toString());
                                    if (parsedTime.isBefore(disableTime)) {
                                      AppToast(
                                              message: S.current
                                                  .timeMustBeAfter(
                                                      e.fromTime.toString()))
                                          .show();
                                      return;
                                    }
                                  }
                                  setState(() {
                                    // DateTime parsedTime = DateFormat.jm().parse("${time.hour}:${time.minute}");
                                    // String formattedTime = DateFormat('HH:mm').format(parsedTime);
                                    e.toTime =
                                        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                                  });
                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    S.current.toTime + ":",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(e.toTime ?? "00:00",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.copyWith(
                                              color: AppColors.primaryColor)),
                                ],
                              )),
                        ],
                      ),
                    ))
                .toList(),
          );
        }));
  }

  static dynamic showAddToCartBottomSheet(
      {required BuildContext context, required Post post}) {
    void onAddToCartDone() {
      AppSnackBar(
          context: context,
          message: S.current.addedSuccessfully,
          onTap: () {
            Navigator.of(context)
                .pushNamed(ShoppingCartScreen.routName, arguments: {
              "withBack": true,
            });
          }).showItemAddToCartSnackBar();
      Navigator.of(context).pop();
    }

    bool isVipActive = false;
    TextEditingController isSpecificOrderDate = TextEditingController();
    TextEditingController orderDateController = TextEditingController();
    bool orderDateError = false;
    int orderCount = 1;
    String selectedOrderType = S.current.pickup;
    PickLocationModel? deliveryLocation;
    bool locationError = false;
    return showMainModalBottomSheet(
        context: context,
        scrollableContent: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          late CartCubit cartCubit = context.read<CartCubit>();
          User user = context.read<AppConfigCubit>().getUser();
          String currency =
              context.read<SessionControllerCubit>().getCurrency();
          void checkOrderDateError() {
            if (orderDateController.text.isEmpty &&
                isSpecificOrderDate.text == "true") {
              orderDateError = true;
            } else {
              orderDateError = false;
            }
            setState(() {});
          }

          void checkLocationError() {
            if (deliveryLocation == null &&
                selectedOrderType == S.current.delivery) {
              locationError = true;
            } else {
              locationError = false;
            }
            setState(() {});
          }

          double itemsPrice = post.price! * orderCount;
          return BlocConsumer<CartCubit, CartState>(
              bloc: cartCubit,
              listener: (context, state) {
                if (state is AddToCartDone) {
                  onAddToCartDone();
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Row(
                        children: [
                          if (post.deliveryRange != null &&
                              post.deliveryRange != 0)
                            Expanded(
                              child: CustomElevatedButton(
                                margin: EdgeInsets.symmetric(horizontal: 6),
                                backgroundColor:
                                    selectedOrderType == S.current.delivery
                                        ? AppColors.primaryColor
                                        : Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    selectedOrderType = S.current.delivery;
                                  });
                                },
                                child: Text(S.current.delivery,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                            fontSize: 15, color: Colors.white)),
                              ),
                            ),
                          Expanded(
                            child: CustomElevatedButton(
                              margin: EdgeInsets.symmetric(horizontal: 6),
                              backgroundColor:
                                  selectedOrderType == S.current.pickup
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  selectedOrderType = S.current.pickup;
                                });
                              },
                              child: Text(S.current.pickup,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                          fontSize: 15, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      if (selectedOrderType == S.current.delivery) ...{
                        SizedBox(height: 8.h),
                        PickLocation(
                            isError: locationError,
                            onChange: (location) {
                              deliveryLocation = location;
                            }),
                      },
                      if (post.isVip == 1 &&
                          user.type == Constants.specialInviteKey)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const ImageIconButton(
                                    imageIcon: Constants.vipImage,
                                    hSize: 32,
                                    wSize: 32),
                                Text(
                                  S.current.vipItem,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontSize: 16.0),
                                ),
                              ],
                            ),
                            Switch.adaptive(
                              value: isVipActive,
                              onChanged: (value) {
                                setState(() {
                                  isVipActive = value;
                                });
                              },
                            ),
                          ],
                        ),
                      BoolSelect(
                          controller: isSpecificOrderDate,
                          title: S.current.specificOrderDate,
                          onChange: () => setState(() {})),
                      if (isSpecificOrderDate.text == "true")
                        PickDate(
                            controller: orderDateController,
                            title: S.current.specificOrderDate,
                            isError: orderDateError),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  orderCount++;
                                });
                              },
                              icon: Icon(Icons.add,
                                  color: AppColors.whiteColor, size: 30)),
                          Container(
                            padding: EdgeInsets.all(12.w),
                            child: Text("$orderCount",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.primaryColor)),
                          ),
                          IconButton(
                              onPressed: orderCount == 1
                                  ? null
                                  : () {
                                      setState(() {
                                        orderCount--;
                                      });
                                    },
                              icon: Icon(Icons.remove,
                                  color: AppColors.whiteColor, size: 30)),
                          Expanded(
                            child: CustomElevatedButton(
                              backgroundColor: AppColors.primaryColor,
                              onPressed: () {
                                checkOrderDateError();
                                checkLocationError();
                                if (orderDateError || locationError) {
                                  return;
                                }
                                cartCubit.addToMyCart(CartModel(
                                  post: post,
                                  orderCount: orderCount,
                                  isDelivery:
                                      selectedOrderType == S.current.delivery,
                                  isVip: isVipActive,
                                  orderDate: orderDateController.text.isEmpty
                                      ? null
                                      : orderDateController.toString(),
                                  deliveryLocation: deliveryLocation,
                                ));
                              },
                              child: Text(S.current.addToCart,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                          fontSize: 15, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(S.current.itemsPrice + ":    ",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(color: AppColors.primaryColor)),
                          Text("${post.price} X $orderCount =  ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppColors.whiteColor)),
                          Text("${itemsPrice} $currency",
                              style: Theme.of(context).textTheme.displayLarge),
                        ],
                      ),
                      if (post.discount != null && post.discount != 0)
                        Row(
                          children: [
                            Text(S.current.priceAfterDiscount + ":    ",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(color: AppColors.primaryColor)),
                            Text("${post.discount}%    ",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(color: Colors.red)),
                            Text(
                                "${itemsPrice - (itemsPrice * post.discount!) / 100} $currency",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(color: Colors.white)),
                          ],
                        ),
                      if (selectedOrderType == S.current.delivery)
                        Row(
                          children: [
                            Text(S.current.deliveryCharges + ":    ",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(color: AppColors.primaryColor)),
                            Text("${post.deliveryCharge} $currency",
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
                          if (post.discount != null && post.discount != 0) ...{
                            Text(
                                "${(itemsPrice - (itemsPrice * post.discount!) / 100) + (selectedOrderType == S.current.delivery ? post.deliveryCharge! : 0)} $currency",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(color: Colors.green)),
                          } else ...{
                            Text(
                                "${itemsPrice + (selectedOrderType == S.current.delivery ? post.deliveryCharge! : 0)} $currency",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(color: Colors.green)),
                          },
                        ],
                      ),
                    ],
                  ),
                );
              });
        }));
  }

  static dynamic showPayBottomSheet(
      {required BuildContext context,
      List<PayItemBody>? items,
      required VoidCallback onDone,
      double? orderTotalAmount}) {
    void recharge() {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(WalletScreen.routName, arguments: {
        "withBack": true,
      });
    }

    return showMainModalBottomSheet(
        context: context,
        scrollableContent: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          String currency =
              context.read<SessionControllerCubit>().getCurrency();
          User user = context.read<AppConfigCubit>().getUser();
          double totalAmount = 0;
          return ListView(
            padding: EdgeInsets.all(20.w),
            physics: const BouncingScrollPhysics(),
            children: [
              Text(S.current.paymentDetails,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    letterSpacing: 1,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                    shadows: [
                      Shadow(
                        color: Colors.lightBlue,
                        offset: const Offset(-1, -1),
                      ),
                      Shadow(
                        color: Colors.lightBlue,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  )),
              SizedBox(height: 20.h),
              if (items != null)
                ...items.map((e) {
                  totalAmount += e.price * e.quantity;
                  return Row(
                    children: [
                      Text(e.name + "     ",
                          style: Theme.of(context).textTheme.displayLarge),
                      Text("${e.price} X ${e.quantity} =  ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppColors.whiteColor)),
                      Text("${e.price * e.quantity} $currency",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(color: AppColors.primaryColor)),
                    ],
                  );
                }).toList(),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.current.totalPrice + ":",
                      style: Theme.of(context).textTheme.displayLarge),
                  Text("${orderTotalAmount ?? totalAmount} $currency",
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(color: AppColors.primaryColor)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.wallet + ":",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text("${user.wallet} $currency",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color:
                              totalAmount > double.parse(user.wallet.toString())
                                  ? Colors.red
                                  : Colors.green)),
                ],
              ),
              if (totalAmount > double.parse(user.wallet.toString()))
                Row(
                  children: [
                    Text(S.current.noEnoughBalance,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(color: Colors.red)),
                    SizedBox(width: 4),
                    TextButton(
                      onPressed: recharge,
                      child: Text(S.current.rechargeWallet,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
              CustomElevatedButton(
                backgroundColor: Colors.green,
                borderColor: Colors.green,
                onPressed: totalAmount > double.parse(user.wallet.toString())
                    ? null
                    : () {
                        Navigator.of(context).pop();
                        onDone();
                      },
                child: Text(S.current.confirm,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(fontSize: 15, color: Colors.white)),
              ),
            ],
          );
        }));
  }

  static dynamic showCallNumberBottomSheet(
      {required BuildContext context, required String number}) {
    return showMainModalBottomSheet(
        context: context,
        height: 150,
        scrollableContent: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Helpers.launchURL("tel:$number", context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.secondary,
                ),
                child: Row(
                  children: [
                    Text(S.current.call,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(color: Colors.white)),
                    SizedBox(width: 12.w),
                    Icon(Icons.call, color: AppColors.whiteColor),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Helpers.launchURL("sms:$number", context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.secondary,
                ),
                child: Row(
                  children: [
                    Text(S.current.chat,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(color: Colors.white)),
                    SizedBox(width: 12.w),
                    Icon(Icons.chat_outlined, color: AppColors.whiteColor),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  static void viewBoostBottomSheet(BuildContext context,
      {required bool toSelectPost, Post? post}) {
    AppModalBottomSheet.showMainModalBottomSheet(
      context: context,
      height: 250.h,
      scrollableContent: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomElevatedButton(
              margin: EdgeInsets.only(bottom: 10, left: 40.w, right: 40.w),
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.all(2),
              onPressed: () {
                if (toSelectPost) {
                  Navigator.of(context).pushNamed(
                    SelectPostToAddBoostScreen.routName,
                    arguments: {"isBanner": true},
                  );
                  return;
                }
                Navigator.of(AppRouter.mainContext).pushNamed(
                  BannerPlansScreen.routName,
                  arguments: {"post": post},
                );
              },
              child: Text(S.current.boostAsBanner,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontSize: 15.sp, color: Colors.white)),
            ),
            CustomElevatedButton(
              margin: EdgeInsets.only(bottom: 10, left: 40.w, right: 40.w),
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.all(2),
              onPressed: () {},
              child: Text(
                S.current.boostAsPost,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontSize: 15.sp, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static dynamic showPickLocationBottomSheet({required BuildContext context}) {
    SessionControllerCubit _sessionControllerCubit =
        context.read<SessionControllerCubit>();
    return showMainModalBottomSheet(
        context: context,
        height: 200,
        scrollableContent: Column(
          children: [
            CustomElevatedButton(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              backgroundColor: AppColors.primaryColor,
              withBorderRadius: true,
              onPressed: () async {
                try {
                  AppDialog.showLoadingDialog(context: context);
                  Position location = await Helpers.getCurrentLocation(context);
                  String locationName =
                      await Helpers.getAddressFromLatLng(location);
                  PickLocationModel currentLocation = PickLocationModel(
                      lat: location.latitude,
                      lng: location.longitude,
                      location: locationName);
                  _sessionControllerCubit.setCurrentLocation(currentLocation);
                  _sessionControllerCubit.setUserLocation(currentLocation);
                  AppDialog.closeAppDialog();
                  _sessionControllerCubit.restartApp();
                } catch (_) {
                  AppDialog.closeAppDialog();
                }
              },
              child: Text(S.current.useCurrentLocation,
                  style: TextStyle(color: Colors.white)),
            ),
            CustomElevatedButton(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              backgroundColor: AppColors.primaryColor,
              withBorderRadius: true,
              onPressed: () async {
                bool serviceEnabled =
                    await Geolocator.isLocationServiceEnabled();
                if (!serviceEnabled) {
                  AppSnackBar(
                          context: context,
                          onTap: () => Geolocator.openLocationSettings())
                      .showLocationServiceDisabledSnackBar();
                  return;
                }
                LocationPermission permission =
                    await Geolocator.checkPermission();
                if (permission == LocationPermission.deniedForever ||
                    permission == LocationPermission.denied) {
                  AppSnackBar(context: context)
                      .showLocationPermanentlyDeniedSnackBar();
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Theme(
                      data: ThemeData(brightness: Brightness.light),
                      child: PlacePicker(
                        apiKey: Constants.googleMapKey,
                        onPlacePicked: (result) async {
                          PickLocationModel currentLocation = PickLocationModel(
                              lat: result.geometry!.location.lat,
                              lng: result.geometry!.location.lng,
                              location: result.formattedAddress.toString());
                          Navigator.of(context).pop();
                          _sessionControllerCubit
                              .setCurrentLocation(currentLocation);
                          _sessionControllerCubit.setUserLocation(currentLocation);
                          _sessionControllerCubit.restartApp();
                        },
                        useCurrentLocation: true,
                        resizeToAvoidBottomInset: false,
                        initialPosition: LatLng(0, 0),
                      ),
                    ),
                  ),
                );
              },
              child: Text(S.current.selectFromMap,
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ));
  }
}
