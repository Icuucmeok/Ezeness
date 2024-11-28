import 'package:ezeness/data/models/boost/plans/boost_plans_list.dart';
import 'package:ezeness/data/models/boost/plans/boost_plans_model.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/data/utils/error_handler.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/banner_plans/banner_plans_cubit.dart';
import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:ezeness/presentation/screens/ads_boost/banner/banner_boost_preview_screen.dart';
import 'package:ezeness/presentation/screens/ads_boost/widgets/boost_plan_widget.dart';
import 'package:ezeness/presentation/utils/app_snackbar.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/presentation/widgets/common/components/elevated_option_with_price.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BannerPlansScreen extends StatefulWidget {
  static const String routName = 'banner_plans';

  const BannerPlansScreen({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<BannerPlansScreen> createState() => _BannerPlansScreenState();
}

class _BannerPlansScreenState extends State<BannerPlansScreen> {
  late BannerPlansCubit _bannerPlansCubit;
  late String currency;

  @override
  void initState() {
    currency = context.read<SessionControllerCubit>().getCurrency();
    print("isKids ${widget.post.isKids}");
    _bannerPlansCubit = context.read<BannerPlansCubit>();
    _bannerPlansCubit.getBannersPlans(
      postType: widget.post.postType,
      isKids: widget.post.isKids,
    );

    super.initState();
  }

  int indexOfPlan(BoostPlansModel plan, BoostPlansList list) {
    return list.boostPlans.indexWhere((element) => element.id == plan.id);
  }

  BoostPlansModel? selectedPlan;

  int indexOfSelectedPlan(BoostPlansList list) {
    return list.boostPlans
        .indexWhere((element) => element.id == selectedPlan?.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(S.current.selectPlan),
        elevation: 0,
      ),
      body: BlocBuilder<BannerPlansCubit, BannerPlansState>(
          bloc: _bannerPlansCubit,
          builder: (context, state) {
            if (state is BannerPlansLoading) {
              return CenteredCircularProgressIndicator();
            }
            if (state is BannerPlansFailure) {
              return ErrorHandler(exception: state.exception).buildErrorWidget(
                context: context,
                retryCallback: () => _bannerPlansCubit.getBannersPlans(
                  postType: widget.post.postType,
                  isKids: widget.post.isKids,
                ),
              );
            }
            if (state is BannerPlansDone) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.grey,
                          borderRadius: BorderRadius.circular(100.r),
                          boxShadow: [Helpers.boxShadow(context)]),
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      child: Text(
                        S.current.sellingOnline,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                            ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      child: Text(
                        S.current.liftUpYourBusiness,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 22,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.whiteColor
                                  : AppColors.darkGrey,
                            ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: Helpers.paddingInContainer(context),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        ...state.bannersPlansList?.boostPlans.map(
                              (e) => BoostPlanWidget(
                                plan: e,
                                index: indexOfPlan(e, state.bannersPlansList!),
                                onSelect: (plan) {
                                  setState(() {
                                    selectedPlan = plan;
                                  });
                                },
                                selectedPlanIndex: indexOfSelectedPlan(
                                  state.bannersPlansList!,
                                ),
                                currency: currency,
                              ),
                            ) ??
                            [],
                        CustomElevatedButton(
                          backgroundColor: AppColors.primaryColor,
                          withBorderRadius: true,
                          child: Text(
                            S.current.next,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  fontSize: 15.sp,
                                  color: AppColors.whiteColor,
                                ),
                          ),
                          onPressed: selectedPlan == null
                              ? () {
                                  if (state.bannersPlansList?.boostPlans !=
                                          null &&
                                      state.bannersPlansList!.boostPlans
                                          .isEmpty) {
                                    AppSnackBar(
                                            message: 'No banner plan',
                                            context: context)
                                        .showErrorSnackBar();
                                    return;
                                  }
                                  AppSnackBar(
                                          message:
                                              'You have to select Banner plan to continue',
                                          context: context)
                                      .showErrorSnackBar();
                                }
                              : () {
                                  Navigator.of(context).pushNamed(
                                    BannerBoostPreviewScreen.routName,
                                    arguments: {
                                      "post": widget.post,
                                      "plan": selectedPlan
                                    },
                                  );
                                },
                        ),
                        // Helpers.constVerticalDistance(size.height),
                      ]),
                    ),
                  ),
                ],
              );
            }
            return Container();
          }),
    );
  }

  buildItem(
    Size size, {
    required BoostPlansModel plan,
    required int selectedPlanIndex,
    required void Function(BoostPlansModel plan) onSelect,
    required int index,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * .04),
      child: ElevatedOptionWithPriceWidget(
        title: "${plan.name} ${plan.location?.name ?? ""}",
        subTitle: "${plan.period} ${S.current.daysLive}",
        titleChild: Text(
          "${S.current.bannerAvailableOn} ${plan.availableDate}",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.green),
        ),
        trailTitle: "${currency} ${plan.cost}",
        index: index,
        selectedPlan: selectedPlanIndex,
        onChanged: (value) => onSelect(plan),
        icon: SvgPicture.asset(
          Assets.assetsIconsStoreSolid,
          colorFilter:
              ColorFilter.mode(AppColors.greyTextColor, BlendMode.srcIn),
          width: size.width * .07,
          height: size.height * .035,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
