import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/follow_user/follow_user_cubit.dart';
import 'package:ezeness/presentation/screens/profile/followers/followers_screen.dart';
import 'package:ezeness/presentation/screens/profile/user_reviews_screen.dart';
import 'package:ezeness/presentation/utils/app_modal_bottom_sheet.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/presentation/widgets/common/components/review_star_widget.dart';
import 'package:ezeness/presentation/widgets/common/responsive_text.dart';
import 'package:ezeness/presentation/widgets/common/share_user_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../../../res/app_res.dart';
import '../../../../router/app_router.dart';
import '../../../../utils/app_toast.dart';
import '../../../panel/gold_coins_dashboard_screen/gold_coins_dashboard_screen.dart';

class ProfileHeaderWidget extends StatefulWidget {
  const ProfileHeaderWidget({
    Key? key,
    required this.isLoggedIn,
    required this.user,
    required this.onEditPressed,
    required this.isOther,
    required this.followUserCubit,
  }) : super(key: key);

  final bool isLoggedIn;
  final User user;
  final bool isOther;
  final VoidCallback onEditPressed;
  final FollowUserCubit followUserCubit;

  @override
  State<ProfileHeaderWidget> createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  late bool isKids;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    isKids = context.read<SessionControllerCubit>().getIsKids() == 1;
    return Column(
      children: [
        _buildProfileHeaderWithCover(size, context),
        _buildReviews(size, context),
        _buildProfileStats(context),
        _buildBio(context, size.height),
      ],
    );
  }

  Widget _buildProfileHeaderWithCover(Size size, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.grey.withOpacity(0.1)
            : AppColors.grey,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        children: [
          Container(
            height: size.height * .30,
            margin: EdgeInsets.only(
                left: size.width * .02, right: size.width * .02, bottom: 5),
            decoration: BoxDecoration(
                // color: Colors.blue,
                borderRadius: BorderRadius.all(
              Radius.circular(size.width * .1),
            )),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    // color: Colors.red,
                    alignment: Alignment.bottomCenter,
                    // height: size.height * .25,
                    // width: size.width * .02,
                    child: Container(
                      width: double.infinity,
                      height: size.height * .25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size.width * .1),
                        color: AppColors.greyDark,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(size.width * .1),
                        child: widget.user.coverImage != null
                            ? Image.network(
                                widget.user.coverImage!,
                                fit: BoxFit.cover,
                                // width: 375,
                              )
                            : Image.asset(Assets.assetsImagesPlaceholder,
                                fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                if (!widget.isOther && !isKids)
                  Positioned(
                    top: 50,
                    right: 15,
                    child: Container(
                      width: 35,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: AppColors.greyTextColor.withOpacity(.2),
                          shape: BoxShape.circle),
                      child: IconButton(
                        iconSize: 20,
                        color: Colors.white,
                        padding: EdgeInsets.zero,
                        onPressed: widget.onEditPressed,
                        icon: Icon(Icons.edit),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    height: size.width * .18,
                    width: size.width * .93,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.blackColor.withOpacity(0.6)
                          : AppColors.whiteColor.withOpacity(0.6),
                      borderRadius: BorderRadius.all(
                        Radius.circular(size.width * .1),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: size.width * .06,
                            end: size.width * .10,
                            top: size.width * .02,
                            bottom: size.width * .02,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(end: 30),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "${widget.user.name}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(end: 30),
                                child: Text(
                                  widget.user.address ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        PositionedDirectional(
                          bottom: 0,
                          end: -12,
                          child: Container(
                            // alignment: Alignment.centerRight,
                            padding: EdgeInsets.all(size.width * .025),
                            decoration: BoxDecoration(
                              color:
                                  widget.user.type == Constants.specialInviteKey
                                      ? AppColors.gold
                                      : (widget.user.gender != null &&
                                              widget.user.gender ==
                                                  Constants.femaleKey)
                                          ? Colors.pinkAccent
                                          : Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: ShareUserButton(
                              user: widget.user,
                              isOtherUser: false,
                              size: size.width * .13,
                              withBorder: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: Helpers.isTab(context) ? 5 : 0,
                  left: 0,
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.whiteColor,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: Helpers.isTab(context) ? 70 : size.width * .11,
                      backgroundColor: AppColors.grey,
                      backgroundImage: NetworkImage(
                        widget.user.image.toString(),
                      ),
                      child: !widget.isOther && !isKids
                          ? InkWell(
                              onTap: widget.onEditPressed,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor:
                                      AppColors.greyDark.withOpacity(0.5),
                                  child: Icon(
                                    Icons.add_circle,
                                    color: AppColors.whiteColor,
                                    size: 25,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: 10,
                  end: 10,
                  child: GestureDetector(
                      onTap: () {
                        if (isKids) {
                          context.read<SessionControllerCubit>().setIsKids(0);
                        } else {
                          context.read<SessionControllerCubit>().setIsKids(1);
                        }

                        context.read<SessionControllerCubit>().restartApp();
                      },
                      child: Row(
                        children: [
                          Text(S.current.kids,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize: 13.0.sp,
                                      fontWeight: FontWeight.bold,
                                      color: isKids
                                          ? AppColors.green
                                          : AppColors.greyDark)),
                          const SizedBox(width: 5),
                          Icon(IconlyBold.shield_fail,
                              size: 18,
                              color: isKids
                                  ? AppColors.green
                                  : AppColors.greyDark),
                        ],
                      )),
                )
              ],
            ),
          ),
          _buildLocationDetails(size),
          SizedBox(height: 5)
        ],
      ),
    );
  }

  Widget _buildLocationDetails(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * .04, vertical: size.height * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //driveUp
          if (widget.user.lat != null)
            GestureDetector(
              onTap: () {
                Helpers.launchURL(
                    'https://www.google.com/maps/dir/?api=1&destination=${widget.user.lat}'
                    ',${widget.user.lng}&mode=d',
                    context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.greyTextColor
                      : AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      S.current.driveUp.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 10.sp),
                    ),
                    SizedBox(width: 3),
                    Icon(
                      Icons.navigation,
                      size: 20,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(width: 10),
          if (widget.user.distance != null)
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                child: Text(
                  "${Helpers.handelMinuet(widget.user.time!)}",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 11.sp),
                )),
          SizedBox(width: 10),
          if (widget.user.distance != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              child: Text(
                "${widget.user.distance?.ceil()} ${S.current.km.toUpperCase()}",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 11.sp),
              ),
            ),
          const Spacer(flex: 3),

          if (widget.user.contactNumber != null)
            GestureDetector(
              onTap: () => AppModalBottomSheet.showCallNumberBottomSheet(
                  context: context,
                  number: widget.user.contactCallNumber.toString()),
              child: Container(
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                width: size.width * .2,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.greyTextColor
                      : AppColors.greyDark,
                  borderRadius: BorderRadius.circular(size.width * .01),
                ),
                child: Text(
                  S.current.contact.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 10.5),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildReviews(Size size, BuildContext context) {
    return InkWell(
      onTap: !widget.isLoggedIn
          ? Helpers.onGustTapButton
          : () {
              Navigator.of(context).pushNamed(UserReviewsScreen.routName,
                  arguments: {"user": widget.user});
            },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * .04, vertical: size.height * .01),
        child: Builder(
          builder: (context) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(' ${S.current.reviews}  ${widget.user.reviews}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 14.5.sp,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.secondary
                            : AppColors.blueText,
                        fontWeight: FontWeight.w300,
                      )),
              StarRating(value: (widget.user.rate ?? 0).toInt()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileStats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (widget.isOther) ...{
            BlocConsumer<FollowUserCubit, FollowUserState>(
                bloc: widget.followUserCubit,
                listener: (context, state) {
                  if (state is FollowUserDone) {
                    widget.user.isFollowing = !widget.user.isFollowing;
                    if (widget.user.isFollowing) {
                      widget.user.followers++;
                    } else {
                      widget.user.followers--;
                    }
                  }
                },
                builder: (context, state) {
                  return _buildStatColumn(
                      title: widget.user.getFollowingStatus(),
                      titleColor: widget.user.getFollowingStatusColor(),
                      onLongTapTitle: () {
                        if (widget.user.isFollowing) {
                          widget.followUserCubit
                              .followUnFollowUser(widget.user.id!);
                        }
                      },
                      onTapTitle: widget.isLoggedIn
                          ? () {
                              if (widget.user.isFollowing) {
                                AppToast(message: S.current.longPressUnFollow)
                                    .show();
                                return;
                              }
                              widget.followUserCubit
                                  .followUnFollowUser(widget.user.id!);
                            }
                          : Helpers.onGustTapButton,
                      number: "${widget.user.followers}",
                      onTapNumber: !widget.isLoggedIn
                          ? Helpers.onGustTapButton
                          : () => Navigator.of(context).pushNamed(
                              FollowersScreen.routName,
                              arguments: {"user": widget.user}));
                }),
          } else ...{
            _buildStatColumn(
              title: S.current.tagUp,
              onTapTitle: () {
                Navigator.of(context).pushNamed(FollowersScreen.routName,
                    arguments: {"user": widget.user});
              },
              number: "${widget.user.followers}",
            ),
          },
          _buildStatColumn(
              title: S.current.posts, number: "${widget.user.totalPosts}"),
          _buildStatColumn(
            title: S.current.gold,
            number: widget.user.coins.toString(),
            withArrow: false,
            onTapNumber: isKids
                ? null
                : () => Navigator.of(AppRouter.mainContext)
                    .pushNamed(GoldCoinsDashboardScreen.routName),
            onTapTitle: isKids
                ? null
                : () => Navigator.of(AppRouter.mainContext)
                    .pushNamed(GoldCoinsDashboardScreen.routName),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
      {required String title,
      required String number,
      VoidCallback? onTapTitle,
      VoidCallback? onLongTapTitle,
      bool withArrow = true,
      Color? titleColor,
      VoidCallback? onTapNumber}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (withArrow)
              Icon(
                IconlyLight.arrow_right,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.secondary
                    : AppColors.blueText,
                size: 17,
              ),
            SizedBox(width: 5),
            InkWell(
              onTap: onTapNumber,
              child: Text(number,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 17.sp)),
            ),
            if (withArrow) SizedBox(width: 17),
          ],
        ),
        const SizedBox(height: 15),
        InkWell(
          onTap: onTapTitle,
          onLongPress: onLongTapTitle,
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: titleColor,
                  fontSize: 13.5.sp,
                ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildBio(BuildContext context, double height) {
    return GestureDetector(
      onTap: () {
        if (widget.user.bio != null)
          AppModalBottomSheet.showMainModalBottomSheet(
            context: context,
            scrollableContent: Padding(
              padding: EdgeInsets.all(8.0.w),
              child: ListView(
                children: [
                  Text(
                    "${widget.user.bio}",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w300,
                        ),
                  )
                ],
              ),
            ),
          );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.grey.withOpacity(0.1)
                : AppColors.grey,
            borderRadius: BorderRadius.circular(30.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (widget.user.store != null
                          ? S.current.businessAccount
                          : S.current.regularAccount)
                      .toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 14.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.whiteColor.withOpacity(0.75)
                          : AppColors.darkGrey,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1),
                ),
                const Spacer(),
                if (widget.user.store != null)
                  Text(
                    "${S.current.since.toUpperCase()} ${intl.DateFormat('yyyy-MM').format(DateTime.parse(widget.user.store!.createdAt!))} ",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.whiteColor.withOpacity(0.75)
                            : AppColors.darkGrey,
                        fontSize: 11.sp),
                  ),
                if (!widget.isOther && !isKids) ...{
                  const Spacer(),
                  IconButton(
                      onPressed: widget.onEditPressed,
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.whiteColor.withOpacity(0.75)
                            : AppColors.darkGrey,
                      )),
                },
              ],
            ),
            if (widget.user.bio != null)
              Text(
                "${widget.user.bio}",
                maxLines: 3,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      overflow: TextOverflow.ellipsis,
                      height: 1.2.h,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            if (widget.user.bio != null) Helpers.constVerticalDistance(height),
            widget.user.website != null
                ? InkWell(
                    onTap: () {
                      Helpers.launchURL(
                          widget.user.website.toString(), context);
                    },
                    child: ResponsiveTextWidget(
                      text: widget.user.website!,
                      baseFontSize: 14.sp,
                      reducedFontSize: 10.sp,
                      threshold: 50,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
