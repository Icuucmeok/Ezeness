import 'package:ezeness/presentation/screens/panel/shopping_cart_screen.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/cart/cart_model.dart';
import '../../../logic/cubit/cart/cart_cubit.dart';
import '../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../widgets/common/common.dart';
import '../../widgets/panel_setting_container_widget.dart';
import '../../widgets/panel_setting_notification_widget.dart';
import '../../widgets/pull_to_refresh.dart';

class OrderScreen extends StatefulWidget {
  static const String routName = 'Order_screen';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late CartCubit _cartCubit;
  @override
  void initState() {
    _cartCubit = context.read<CartCubit>();
    _cartCubit.getMyCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = context.read<SessionControllerCubit>().isLoggedIn();
    return Scaffold(
      body: isLoggedIn
          ? BlocBuilder<CartCubit, CartState>(
              bloc: _cartCubit,
              builder: (context, state) {
                if (state is GetMyCartLoading) {
                  return const CenteredCircularProgressIndicator();
                }
                if (state is GetMyCartLoaded) {
                  List<CartModel> list = state.response.cartModelList!;
                  return PullToRefresh(
                    onRefresh: () {
                      _cartCubit.getMyCart();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          PanelSettingContainerWidget(
                            headerWidget: null,
                            headerIcon: Icons.shopping_cart_rounded,
                            iconColor: Colors.lightGreen,
                            headerTitle: "Shopping Cart",
                            widget: PanelSettingNotificationWidget(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    ShoppingCartScreen.routName,
                                    arguments: {
                                      "withBack": true,
                                    });
                              },
                              notificationText: "Shopping cart",
                              notificationCount: "${list.length}",
                              notificationTextColor:
                                  Theme.of(context).primaryColorDark,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.blackColor,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Row(
                                children: [
                                  SizedBox(
                                    child: Image.network(
                                      "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZHVjdCUyMGltYWdlc3xlbnwwfHwwfHx8MA%3D%3D",
                                      fit: BoxFit.fill,
                                    ),
                                    width: 120.w,
                                    height: 120,
                                  ),
                                  SizedBox(width: 12.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Headphone"),
                                      Text(
                                        "In Progress",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(color: Colors.green),
                                      ),
                                      Text("100 X 1 = 100"),
                                      Text("21 Dec 2023",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              })
          : const GuestCard(),
    );
  }
}
