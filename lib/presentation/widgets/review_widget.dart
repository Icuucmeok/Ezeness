import 'package:ezeness/data/models/review/review.dart';
import 'package:ezeness/logic/cubit/reviews/reviews_cubit.dart';
import 'package:ezeness/presentation/router/app_router.dart';
import 'package:ezeness/presentation/widgets/common/components/review_star_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user/user.dart';
import '../../generated/l10n.dart';
import '../../logic/cubit/app_config/app_config_cubit.dart';
import '../screens/profile/profile/profile_screen.dart';
import 'circle_avatar_icon_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({
    Key? key,
    required this.reviewCubit,
    required this.review,
  }) : super(key: key);

  final ReviewModel review;
  final ReviewsCubit reviewCubit;

  @override
  Widget build(BuildContext context) {
    User user = context.read<AppConfigCubit>().getUser();
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(AppRouter.mainContext).pushNamed(
                  ProfileScreen.routName,
                  arguments: {"isOther": true, "user": review.user});
            },
            child: Row(
              children: [
                CircleAvatarIconWidget(
                  userProfileImage: review.user!.image.toString(),
                  size: 30.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${review.user?.name}",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                            ),
                      ),
                      if (review.rate != null)
                        StarRating(
                          value: review.rate!.toInt(),
                          size: 15,
                          spaceBetween: 1,
                        ),
                    ],
                  ),
                ),
                if (review.user!.id == user.id)
                  PopupMenuButton(
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext bc) {
                      return [
                        PopupMenuItem(
                          child: Text(S.current.delete),
                          onTap: () {
                            reviewCubit.deleteReviews(review.id!);
                          },
                        ),
                      ];
                    },
                  ),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Text(review.review.toString())),
        ],
      ),
    );
  }
}
