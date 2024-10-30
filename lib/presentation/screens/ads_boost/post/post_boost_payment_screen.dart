import 'package:ezeness/data/models/boost/plans/boost_plans_model.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/utils/error_handler.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/add_post_boost/add_post_boost_cubit.dart';
import 'package:ezeness/logic/cubit/app_config/app_config_cubit.dart';
import 'package:ezeness/logic/cubit/payment/payment_cubit.dart';
import 'package:ezeness/logic/cubit/profile/profile_cubit.dart';
import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:ezeness/presentation/screens/home/home_screen.dart';
import 'package:ezeness/presentation/screens/panel/gold_coins_dashboard_screen/widgets/wallet_balance_widget.dart';
import 'package:ezeness/presentation/screens/panel/wallet_screen/widgets/top_up_wallet_header_widget.dart';
import 'package:ezeness/presentation/utils/app_snackbar.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

class PostBoostPaymentScreen extends StatefulWidget {
  static const String routName = 'post_payment';

  const PostBoostPaymentScreen({
    Key? key,
    required this.plan,
    required this.post,
  }) : super(key: key);

  final Post post;
  final BoostPlansModel plan;

  @override
  State<PostBoostPaymentScreen> createState() => _PostBoostPaymentScreenState();
}

class _PostBoostPaymentScreenState extends State<PostBoostPaymentScreen> {
  late User user;
  late AddPostBoostCubit _addPostBoostCubit;
  late ProfileCubit _profileCubit;
  late PaymentCubit _paymentCubit;
  late String currency;

  @override
  void initState() {
    user = context.read<AppConfigCubit>().getUser();
    _addPostBoostCubit = context.read<AddPostBoostCubit>();
    _profileCubit = context.read<ProfileCubit>();
    _paymentCubit = context.read<PaymentCubit>();
    currency = context.read<SessionControllerCubit>().getCurrency();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(S.current.postBoostPayment),
          elevation: 0,
        ),
        body: ListView(
          padding:
              EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
          children: [
            // Wallet Balance Widget
            if (user.wallet != null)
              WalletBalanceWidget(walletBalance: user.wallet ?? ''),
            if (user.wallet != null) TopUpWalletHeaderWidget(_paymentCubit),

            SizedBox(height: 30),
            Text(
              S.current.coinsConversion,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
            ),

            SizedBox(height: 7.5),

            _buildRowItem(
              context,
              title: S.current.subTotal,
              amount: widget.plan.cost.toString(),
            ),

            Divider(
              color: Theme.of(context).primaryColorDark,
            ),

            _buildRowItem(
              context,
              title: S.current.total,
              amount: widget.plan.cost.toString(),
            ),
            SizedBox(height: size.height * 0.05),

            BlocConsumer<AddPostBoostCubit, AddPostBoostState>(
              listener: (context, state) async {
                if (state is AddPostBoostDone) {
                  await _profileCubit
                      .getMyProfileSync(context.read<AppConfigCubit>());

                  AppSnackBar(
                    context: context,
                    message: S.current.boostRequestedSuccessfully,
                  ).showSuccessSnackBar();
                  Navigator.of(context)
                      .pushReplacementNamed(HomeScreen.routName);

                  // Navigator.of(context).pop();
                }
                if (state is AddPostBoostFailure) {
                  ErrorHandler(exception: state.exception)
                      .showErrorSnackBar(context: context);
                }
              },
              builder: (context, state) {
                return CustomElevatedButton(
                  isLoading: state is AddPostBoostLoading,
                  margin: EdgeInsets.only(bottom: 10),
                  backgroundColor: user.wallet == null ||
                          (num.tryParse(user.wallet!) ?? 0) <= 0
                      ? AppColors.grey
                      : AppColors.primaryColor,
                  withBorderRadius: true,
                  onPressed: user.wallet == null ||
                          (num.tryParse(user.wallet!) ?? 0) <= 0
                      ? null
                      : () => _addPostBoostCubit.addPostBoost(
                            planId: widget.plan.id,
                            postId: widget.post.id,
                            startDate: widget.plan.availableDate ??
                                intl.DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now()), // TODO:
                          ),
                  child: Text(
                    S.current.pay,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 15.sp,
                          color: user.wallet == null ||
                                  (num.tryParse(user.wallet!) ?? 0) <= 0
                              ? AppColors.primaryColor
                              : AppColors.whiteColor,
                        ),
                  ),
                );
              },
            ),
          ],
        ));
  }

  Widget _buildRowItem(BuildContext context,
      {required String title, required String amount}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 15.sp),
            ),
          ),
          Text(
            "${currency} ${Helpers.numberFormatter(double.tryParse(amount) ?? 0)}",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 15.sp,
                ),
          ),
        ],
      ),
    );
  }
}
