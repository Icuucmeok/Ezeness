import 'package:ezeness/data/models/upgrade_username_plan/upgrade_username_plan.dart';
import 'package:ezeness/logic/cubit/payment/payment_cubit.dart';
import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:ezeness/logic/cubit/upgrade_username/upgrade_username_cubit.dart';
import 'package:ezeness/presentation/screens/panel/gold_coins_dashboard_screen/widgets/wallet_balance_widget.dart';
import 'package:ezeness/presentation/screens/panel/wallet_screen/widgets/top_up_wallet_header_widget.dart';
import 'package:ezeness/presentation/screens/profile/username_upgrade/widgets/username_upgrade_plan_widget.dart';
import 'package:ezeness/presentation/utils/app_snackbar.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models/user/user.dart';
import '../../../../data/utils/error_handler.dart';
import '../../../../generated/l10n.dart';
import '../../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../../logic/cubit/profile/profile_cubit.dart';
import '../../../../res/app_res.dart';
import '../../../utils/text_input_validator.dart';
import '../../../widgets/common/common.dart';

class UserNameUpgradeScreen extends StatefulWidget {
  static const String routName = 'userName_upgrade_screen';
  final args;
  const UserNameUpgradeScreen({this.args, Key? key}) : super(key: key);

  @override
  State<UserNameUpgradeScreen> createState() => _UserNameUpgradeScreenState();
}

class _UserNameUpgradeScreenState extends State<UserNameUpgradeScreen> {
  late PageController _pageController;
  final _formKey = GlobalKey<FormState>();

  TextEditingController userNameController = TextEditingController();

  List<String> suggestions = [];
  List<UpgradeUsernamePlan> plans = [];
  int? selectedPlanId;
  UpgradeUsernamePlan? selectedPlan;
  void nextPage() {
    _pageController.animateToPage(_pageController.page!.toInt() + 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void previousPage() {
    _pageController.animateToPage(_pageController.page!.toInt() - 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  late String currency;

  late PaymentCubit _paymentCubit;

  late UpgradeUserNameCubit _upgradeUserNameCubit;
  late ProfileCubit _profileCubit;
  late User user;
  @override
  void initState() {
    currency = context.read<SessionControllerCubit>().getCurrency();

    _paymentCubit = context.read<PaymentCubit>();

    _pageController = PageController();
    _upgradeUserNameCubit = context.read<UpgradeUserNameCubit>();
    _profileCubit = context.read<ProfileCubit>();
    user = context.read<AppConfigCubit>().getUser();
    _upgradeUserNameCubit.getPlan();
    if (user.proUsername != null && user.usernamePlan != null) {
      userNameController.text = user.proUsername!;
      selectedPlanId = user.usernamePlan!.planId;
    }
    super.initState();
  }

  int indexOfSelectedPlan(List<UpgradeUsernamePlan> list) {
    return list.indexWhere((element) =>
        element.id ==
        (selectedPlan?.id ??
            (user.usernamePlan != null &&
                    user.usernamePlan?.planId == selectedPlanId
                ? selectedPlanId
                : null)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.topProfilePlan),
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            _buildPlansPage(context),
            _buildTermsPage(context),
            _buildPaymentPage(context),
            _buildUserNamePage(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserNamePage(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 18),
        child: BlocConsumer<UpgradeUserNameCubit, UpgradeUserNameState>(
            bloc: _upgradeUserNameCubit,
            listener: (context, state) {
              if (state is MySuggestionLoaded) {
                suggestions = state.response;
              }
              if (state is UpgradeUserNameDone) {
                AppSnackBar(
                        message: S.current.editSuccessfully, context: context)
                    .showSuccessSnackBar();
                _profileCubit.getMyProfile(context.read<AppConfigCubit>());
                Navigator.pop(context);
              }
              if (state is UpgradeUserNameFailure) {
                ErrorHandler(exception: state.exception)
                    .showErrorSnackBar(context: context);
              }
            },
            builder: (context, state) {
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Text(
                    S.current.createAUsername,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackColor,
                        ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    S.current.addUsernameDescription,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 40),
                  EditTextField(
                    hintText: S.current.userName,
                    controller: userNameController,
                    label: S.current.userName,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    validator: (text) {
                      return TextInputValidator(validators: [
                        InputValidator.requiredField,
                        InputValidator.userName,
                      ]).validate(text);
                    },
                  ),
                  SizedBox(height: 15.h),
                  Text(S.current.suggestion + " " + S.current.userName,
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(color: AppColors.secondary, fontSize: 16)),
                  SizedBox(height: 10.h),
                  if (state is GetMySuggestionLoading) ...{
                    const CenteredCircularProgressIndicator(),
                  } else ...{
                    ...suggestions
                        .map(
                          (e) => InkWell(
                              onTap: () {
                                setState(() {
                                  userNameController.text = e;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(e,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: Colors.green, fontSize: 16)),
                              )),
                        )
                        .toList(),
                  },
                  SizedBox(height: 20),
                  CustomElevatedButton(
                    withBorderRadius: true,
                    isLoading: state is UpgradeUserNameLoading,
                    margin: EdgeInsets.only(bottom: 30),
                    backgroundColor: AppColors.secondary,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      _upgradeUserNameCubit.subscribeToPlan(
                          planId: selectedPlanId!,
                          proUsername: userNameController.text);
                    },
                    child: Text(S.current.done,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(
                                fontSize: 15.sp, color: AppColors.whiteColor)),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget _buildPaymentPage(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(
        padding:
            EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
        children: [
          // Wallet Balance Widget
          if (user.wallet != null)
            WalletBalanceWidget(walletBalance: user.wallet ?? ''),
          SizedBox(height: 10),
          if (user.wallet != null) TopUpWalletHeaderWidget(_paymentCubit),

          SizedBox(height: 30),

          _buildRowItem(
            context,
            title: S.current.subTotal,
            amount: selectedPlan?.cost?.toString() ?? "",
          ),

          Divider(
            color: Theme.of(context).primaryColorDark,
          ),

          _buildRowItem(
            context,
            title: S.current.total,
            amount: selectedPlan?.cost.toString() ?? "",
          ),
          SizedBox(height: size.height * 0.05),
          CustomElevatedButton(
            margin: EdgeInsets.only(bottom: 10),
            // backgroundColor: AppColors.secondary,
            backgroundColor: (user.wallet == null ||
                        (num.tryParse(user.wallet!) ?? 0) <= 0) &&
                    (selectedPlan?.cost ?? 0) > 0
                ? AppColors.grey
                : AppColors.secondary,
            withBorderRadius: true,
            onPressed: (user.wallet == null ||
                        (num.tryParse(user.wallet!) ?? 0) <= 0) &&
                    (selectedPlan?.cost ?? 0) > 0
                ? null
                : () {
                    if (selectedPlanId == null) {
                      AppSnackBar(
                              message: S.current.selectToContinue,
                              context: context)
                          .showErrorSnackBar();
                      return;
                    }
                    if (user.usernamePlan != null &&
                        user.usernamePlan?.planId == selectedPlanId) {
                      AppSnackBar(
                              message: S.current.editToContinue,
                              context: context)
                          .showErrorSnackBar();
                      return;
                    }

                    nextPage();
                    _upgradeUserNameCubit.getMySuggestion();
                  },
            child: Text(
              S.current.pay,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.whiteColor,
                  ),
            ),
          )
        ]);
  }

  Widget _buildTermsPage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            S.current.agreeTermsConditions,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 20),
          Text(
            S.current.peopleUseServices,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.greyDark, fontSize: 18.sp),
          ),
          SizedBox(height: 40),
          // Next button
          CustomElevatedButton(
            margin: EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
            backgroundColor: AppColors.secondary,
            withBorderRadius: true,
            onPressed: () {
              nextPage();
            },
            child: Text(
              S.current.iAgree,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.whiteColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansPage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(100.r),
                boxShadow: [Helpers.boxShadow(context)]),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Text(
              S.current.makeYourselfIdentical,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Text(S.current.selectVerificationPlan),
          ),
          SizedBox(height: 20),
          Expanded(
            child: BlocConsumer<UpgradeUserNameCubit, UpgradeUserNameState>(
                bloc: _upgradeUserNameCubit,
                listener: (context, state) {
                  if (state is GetPlanLoaded) {
                    plans = state.response.upgradeUsernamePlanList!;
                  }
                },
                builder: (context, state) {
                  if (state is GetPlanLoading) {
                    return const CenteredCircularProgressIndicator();
                  }
                  if (state is GetPlanFailure) {
                    return ErrorHandler(exception: state.exception)
                        .buildErrorWidget(
                            context: context,
                            retryCallback: () =>
                                _upgradeUserNameCubit.getPlan());
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    itemCount: plans.length,
                    itemBuilder: (context, index) => UsernameUpgradePlanWidget(
                      plan: plans[index],
                      onSelect: (plan) {
                        setState(() {
                          selectedPlanId = plan.id;
                          selectedPlan = plan;
                        });
                      },
                      index: index,
                      selectedPlanIndex: indexOfSelectedPlan(plans),
                    ),
                  );
                }),
          ),
          CustomElevatedButton(
            backgroundColor: AppColors.secondary,
            withBorderRadius: true,
            child: Text(
              S.current.getTag,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.whiteColor,
                  ),
            ),
            onPressed: () {
              if (selectedPlanId == null) {
                AppSnackBar(
                        message: S.current.selectToContinue, context: context)
                    .showErrorSnackBar();
                return;
              }
              if (user.usernamePlan != null &&
                  user.usernamePlan?.planId == selectedPlanId) {
                AppSnackBar(message: S.current.editToContinue, context: context)
                    .showErrorSnackBar();
                return;
              }
              nextPage();
            },
          ),
        ],
      ),
    );
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
