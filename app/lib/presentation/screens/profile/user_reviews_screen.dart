import 'package:ezeness/data/models/review/review.dart';
import 'package:ezeness/logic/cubit/reviews/reviews_cubit.dart';
import 'package:ezeness/logic/cubit/user_reviews/user_reviews_cubit.dart';
import 'package:ezeness/presentation/widgets/common/components/review_star_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user/user.dart';
import '../../../data/utils/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../res/app_res.dart';
import '../../widgets/common/common.dart';
import '../../widgets/review_widget.dart';

class UserReviewsScreen extends StatefulWidget {
  final User user;
  const UserReviewsScreen({required this.user, Key? key}) : super(key: key);
  static const String routName = 'user_reviews_screen';

  @override
  State<UserReviewsScreen> createState() => _UserReviewsScreenState();
}

class _UserReviewsScreenState extends State<UserReviewsScreen> {
  late ReviewsCubit _reviewsCubit;
  late UserReviewsCubit _userReviewsCubit;
  TextEditingController reviewController = TextEditingController();
  late User loggedInUser;
  @override
  void initState() {
    loggedInUser = context.read<AppConfigCubit>().getUser();
    _reviewsCubit = context.read<ReviewsCubit>();
    _userReviewsCubit = context.read<UserReviewsCubit>();
    _userReviewsCubit.getReviews(widget.user.id!);
    super.initState();
  }

  int rate = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.reviews)),
      body: BlocBuilder<UserReviewsCubit, UserReviewsState>(
          bloc: _userReviewsCubit,
          builder: (context, state) {
            if (state is UserReviewsLoading) {
              return const CenteredCircularProgressIndicator();
            }
            if (state is UserReviewsFailure) {
              return ErrorHandler(exception: state.exception).buildErrorWidget(
                  context: context,
                  retryCallback: () =>
                      _userReviewsCubit.getReviews(widget.user.id!));
            }
            if (state is UserReviewsLoaded) {
              List<ReviewModel> list = state.response.reviewList!;
              return BlocConsumer<ReviewsCubit, ReviewsState>(
                  bloc: _reviewsCubit,
                  listener: (context, state) {
                    if (state is ReviewsAdded) {
                      widget.user.reviews++;
                      ReviewModel c = state.response;
                      c.user = loggedInUser;
                      list.add(c);
                      reviewController.clear();
                    }
                    if (state is ReviewsDeleted) {
                      widget.user.reviews--;
                      list.removeWhere(
                          (element) => element.id.toString() == state.response);
                    }
                  },
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                              child: list.isEmpty
                                  ? EmptyCard(
                                      withIcon: false,
                                      massage: S.current.noReviewsToShow)
                                  : ListView(
                                      physics: const BouncingScrollPhysics(),
                                      children: list
                                          .map((e) => ReviewWidget(
                                              review: e,
                                              reviewCubit: _reviewsCubit))
                                          .toList(),
                                    )),
                          if (loggedInUser.id != widget.user.id)
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Column(
                                children: [
                                  StarRating(
                                    value: rate,
                                    onChanged: (index) =>
                                        setState(() => rate = index),
                                  ),
                                  SizedBox(height: 20),
                                  EditTextField(
                                    controller: reviewController,
                                    label: "",
                                    onChanged: () {
                                      setState(() {});
                                    },
                                    hintText: S.current.writeReview,
                                    suffixWidget: IconButton(
                                        onPressed: reviewController.text.isEmpty
                                            ? null
                                            : () {
                                                _reviewsCubit.addReviews(
                                                  reviewedUserId:
                                                      widget.user.id!,
                                                  reviews:
                                                      reviewController.text,
                                                  rate: rate,
                                                );
                                              },
                                        icon: Icon(
                                          Icons.send,
                                          color: AppColors.primaryColor,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  });
            }
            return Container();
          }),
    );
  }
}
