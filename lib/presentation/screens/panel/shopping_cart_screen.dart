import 'package:ezeness/data/models/cart/cart_model.dart';
import 'package:ezeness/logic/cubit/cart/cart_cubit.dart';
import 'package:ezeness/presentation/router/app_router.dart';
import 'package:ezeness/presentation/screens/checkout_screen.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../res/app_res.dart';
import '../../widgets/cart_item_widget.dart';
import '../../widgets/pull_to_refresh.dart';

class ShoppingCartScreen extends StatefulWidget {
  static const String routName = 'shopping_cart_screen';
  final args;
  const ShoppingCartScreen({this.args, Key? key}) : super(key: key);

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  bool withBack = false;
  late CartCubit _cartCubit;
  @override
  void initState() {
    if (widget.args != null) {
      withBack = widget.args["withBack"] ?? false;
    }
    _cartCubit = context.read<CartCubit>();
    _cartCubit.getMyCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = context.read<SessionControllerCubit>().isLoggedIn();
    return Scaffold(
      appBar: withBack
          ? AppBar(
              title: Text(S.current.shoppingCart),
            )
          : null,
      body: isLoggedIn
          ? BlocConsumer<CartCubit, CartState>(
              bloc: _cartCubit,
              listener: (context, state) {
                if (state is RemoveFromCartDone) {
                  _cartCubit.getMyCart();
                }
              },
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
                          ...List.generate(list.length, (index) {
                            return CartItemWidget(
                                cart: list[index],
                                onRemoveTap: () {
                                  _cartCubit.removeFromMyCart(index);
                                });
                          }).toList(),
                          if (list.isNotEmpty)
                            CustomElevatedButton(
                              margin: EdgeInsets.all(8.w),
                              backgroundColor: AppColors.primaryColor,
                              onPressed: () {
                                Navigator.of(AppRouter.mainContext).pushNamed(
                                    CheckoutScreen.routName,
                                    arguments: {
                                      "cartList": list,
                                    });
                              },
                              child: Text(S.current.checkout,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                          fontSize: 15, color: Colors.white)),
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
