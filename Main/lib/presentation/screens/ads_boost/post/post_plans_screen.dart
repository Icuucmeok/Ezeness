import 'package:ezeness/data/models/boost/plans/boost_plans_list.dart';
import 'package:ezeness/data/models/boost/plans/boost_plans_model.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/data/utils/error_handler.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/post_plans/post_plans_cubit.dart';
import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:ezeness/presentation/screens/ads_boost/post/post_boost_terms_screen.dart';
import 'package:ezeness/presentation/screens/ads_boost/widgets/boost_plan_widget.dart';
import 'package:ezeness/presentation/utils/app_snackbar.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostPlansScreen extends StatefulWidget {
  static const String routName = 'post_plans';

  const PostPlansScreen({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<PostPlansScreen> createState() => _PostPlansScreenState();
}

class _PostPlansScreenState extends State<PostPlansScreen> {
  late PostPlansCubit _PostPlansCubit;
  late String currency;

  @override
  void initState() {
    currency = context.read<SessionControllerCubit>().getCurrency();
    print("isKids ${widget.post.isKids}");
    _PostPlansCubit = context.read<PostPlansCubit>();
    _PostPlansCubit.getPostsPlans(
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
      body: BlocBuilder<PostPlansCubit, PostPlansState>(
          bloc: _PostPlansCubit,
          builder: (context, state) {
            if (state is PostPlansLoading) {
              return CenteredCircularProgressIndicator();
            }
            if (state is PostPlansFailure) {
              return ErrorHandler(exception: state.exception).buildErrorWidget(
                context: context,
                retryCallback: () => _PostPlansCubit.getPostsPlans(
                  postType: widget.post.postType,
                  isKids: widget.post.isKids,
                ),
              );
            }
            if (state is PostPlansDone) {
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
                        ...state.PostsPlansList?.boostPlans.map(
                              (e) => BoostPlanWidget(
                                plan: e,
                                index: indexOfPlan(e, state.PostsPlansList!),
                                onSelect: (plan) {
                                  setState(() {
                                    selectedPlan = plan;
                                  });
                                },
                                selectedPlanIndex: indexOfSelectedPlan(
                                  state.PostsPlansList!,
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
                                  if (state.PostsPlansList?.boostPlans !=
                                          null &&
                                      state
                                          .PostsPlansList!.boostPlans.isEmpty) {
                                    AppSnackBar(
                                            message: 'No Post plan',
                                            context: context)
                                        .showErrorSnackBar();
                                    return;
                                  }
                                  AppSnackBar(
                                          message:
                                              'You have to select Post plan to continue',
                                          context: context)
                                      .showErrorSnackBar();
                                }
                              : () {
                                  Navigator.of(context).pushNamed(
                                    PostBoostTermsScreen.routName,
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
}
