import 'package:ezeness/data/models/hashtag/hashtag.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/logic/cubit/hashtag/hashtag_cubit.dart';
import 'package:ezeness/logic/cubit/mention/mention_cubit.dart';
import 'package:ezeness/presentation/screens/post/hashtag_post_screen.dart';
import 'package:ezeness/presentation/utils/app_toast.dart';
import 'package:ezeness/presentation/utils/future_sender.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/presentation/widgets/common/components/custom_posts_grid.dart';
import 'package:ezeness/presentation/widgets/post_call_button.dart';
import 'package:ezeness/presentation/widgets/profile_grid_view.dart';
import 'package:ezeness/presentation/widgets/profile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../data/models/comment/comment.dart';
import '../../../data/models/post/post.dart';
import '../../../data/utils/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../logic/cubit/bookmark_post/bookmark_post_cubit.dart';
import '../../../logic/cubit/comment/comment_cubit.dart';
import '../../../logic/cubit/follow_user/follow_user_cubit.dart';
import '../../../logic/cubit/post/post_cubit.dart';
import '../../../logic/cubit/post_comment/post_comment_cubit.dart';
import '../../../res/app_res.dart';
import '../../router/app_router.dart';
import '../../utils/app_modal_bottom_sheet.dart';
import '../../widgets/circle_avatar_icon_widget.dart';
import '../../widgets/comment_widget.dart';
import '../../widgets/common/common.dart';
import '../../widgets/common/components/review_star_widget.dart';
import '../../widgets/post_button.dart';
import '../../widgets/user_widget.dart';
import '../profile/profile/profile_screen.dart';

class PostDetailsScreen extends StatefulWidget {
  final Post post;
  const PostDetailsScreen({required this.post, Key? key}) : super(key: key);
  static const String routName = 'post_details_screen';
  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  late CommentCubit _commentCubit;
  late BookmarkPostCubit _bookmarkPostCubit;
  late PostCommentCubit _postCommentCubit;
  late FollowUserCubit _followUserCubit;
  late PostCubit _postCubit;
  TextEditingController commentController = TextEditingController();
  late Post post;
  @override
  void initState() {
    _postCubit = context.read<PostCubit>();
    _commentCubit = context.read<CommentCubit>();
    _bookmarkPostCubit = context.read<BookmarkPostCubit>();
    _postCommentCubit = context.read<PostCommentCubit>();
    _followUserCubit = context.read<FollowUserCubit>();
    _postCubit.getPost(widget.post.id!,
        liftUpId: widget.post.liftUpResponse == null
            ? null
            : widget.post.liftUpResponse!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User loggedInUser = context.read<AppConfigCubit>().getUser();
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.postDetails.toUpperCase()),
        actions: [
          if (AppData.isShowBoostButton)
            BlocBuilder<PostCubit, PostState>(
                bloc: _postCubit,
                builder: (context, state) {
                  if (state is PostLoaded) {
                    return CustomElevatedButton(
                      width: 100,
                      height: 40,
                      backgroundColor: AppColors.primaryColor,
                      margin: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      onPressed: () {
                        AppModalBottomSheet.viewBoostBottomSheet(
                          context,
                          toSelectPost: false,
                          post: post,
                        );
                      },
                      child: Text(
                        "Boost",
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 15.sp,
                                  color: AppColors.whiteColor,
                                ),
                      ),
                    );
                  }
                  return Container();
                }),
        ],
      ),
      body: BlocBuilder<PostCubit, PostState>(
          bloc: _postCubit,
          builder: (context, state) {
            if (state is PostLoading) {
              return const CenteredCircularProgressIndicator();
            }
            if (state is PostFailure) {
              return ErrorHandler(exception: state.exception).buildErrorWidget(
                  context: context,
                  retryCallback: () => _postCubit.getPost(widget.post.id!,
                      liftUpId: widget.post.liftUpResponse == null
                          ? null
                          : widget.post.liftUpResponse!.id));
            }
            if (state is PostLoaded) {
              post = state.response;
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(0.0),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          if (post.description != null)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDescription(context,
                                      text: post.description ?? ""),
                                ],
                              ),
                            ),
                          Container(
                            margin: EdgeInsets.all(8),
                            alignment: Alignment.centerRight,
                            width: double.infinity,
                            child: Text(
                                "${timeago.format(DateTime.parse(post.liftUpResponse == null ? post.createdAt! : post.liftUpResponse!.createdAt!))}",
                                style: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.greyBright,
                                          fontWeight: FontWeight.w300,
                                        )
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w300,
                                        )),
                          ),
                          if (post.postType != Constants.postUpKey)
                            Container(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Divider(),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          ///Delivery Icon
                                          if (post.deliveryCharge != null &&
                                              post.deliveryCharge != 0)
                                            ImageIconButton(
                                              imageIcon:
                                                  'https://www.pngitem.com/pimgs/m/485-4853792_white-motorbike-icon-delivery-png-transparent-png.png',
                                              onTap: () {},
                                            ),

                                          ///24/7 Icon
                                          if (post.user != null &&
                                              post.user!.store != null &&
                                              post.user!.store?.storePlan?.id ==
                                                  Constants.plan24Key)
                                            ImageIconButton(
                                              imageIcon:
                                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfMzyqAdvu-9wpCELiQu7XAj8qz4_mrfqzknYqGZjZiaBFVu7lh1MUMx7LTMY4iE_q7bY&usqp=CAU',
                                              onTap: () {},
                                            ),

                                          if (post.isVip != null &&
                                              post.isVip == 1 &&
                                              loggedInUser.type ==
                                                  Constants.specialInviteKey)

                                            ///VIP Icon
                                            ImageIconButton(
                                              imageIcon: Constants.vipImage,
                                              onTap: () {},
                                            ),
                                        ],
                                      ),
                                      if (post.discount != null &&
                                          post.discount != 0)
                                        Container(
                                          alignment: Alignment.center,
                                          width: 52.dg,
                                          height: 30.dg,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30.r),
                                              topRight: Radius.circular(30.r),
                                              bottomLeft: Radius.circular(30.r),
                                            ),
                                            color: Colors.deepOrange
                                                .withOpacity(0.9),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${Helpers.removeDecimalZeroFormat(post.discount!)}%',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.5,
                                                letterSpacing: 1.0,
                                                color: Colors.white,
                                                shadows: [
                                                  Shadow(
                                                      color: Colors.black45,
                                                      offset: Offset(1, 1),
                                                      blurRadius: 1.0),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (post.discount != null &&
                                          post.discount != 0)
                                        Text(
                                          '${Helpers.getCurrencyName(post.priceCurrency.toString())} ${Helpers.numberFormatter(post.price!)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Theme.of(context)
                                                    .primaryColorDark
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.0,
                                              ),
                                        ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blueAccent),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: AppColors.darkColor
                                              .withOpacity(0.0),
                                        ),
                                        child: Text(
                                            '${Helpers.getCurrencyName(post.priceCurrency.toString())} ${Helpers.numberFormatter(post.sellPrice!)} ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.5,
                                                )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Divider(),
                                ],
                              ),
                            ),
                          SizedBox(height: 5.h),
                          if (post.liftUpResponse != null) ...{
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.orange,
                                borderRadius:
                                    BorderRadiusDirectional.horizontal(
                                  start: Radius.circular(1000),
                                ),
                              ),
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: 8.0.w, vertical: 8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(AppRouter.mainContext).pushNamed(
                                      ProfileScreen.routName,
                                      arguments: {
                                        "isOther": true,
                                        "user": post.user
                                      });
                                },
                                child: Row(
                                  children: [
                                    CircleAvatarIconWidget(
                                      userProfileImage:
                                          post.user!.image.toString(),
                                      size: 90,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${post.user!.name}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.sp,
                                                  color: AppColors.blackColor,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "@${post.user!.getUserName()}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.sp,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? AppColors.grey
                                                      : AppColors.greyColor,
                                                ),
                                          ),
                                          Text(
                                            (post.user?.store != null
                                                    ? S.current.businessAccount
                                                    : S.current.regularAccount)
                                                .toLowerCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: AppColors.blackColor,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${timeago.format(DateTime.parse(post.createdAt!))}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.sp,
                                                color: AppColors.blackColor,
                                              ),
                                        ),
                                        SizedBox(height: 6.h),
                                        Icon(
                                          CupertinoIcons.link_circle,
                                          color: AppColors.gold,
                                          size: 30,
                                        )
                                      ],
                                    ),
                                    SizedBox(width: 10.w),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 9.h),
                          },
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? null
                                  : AppColors.grey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ///ESTIMATED TIME CONTAINER
                                        Row(
                                          children: [
                                            ///DRIVE UP

                                            GestureDetector(
                                              onTap: () {
                                                if (post.lat != null) {
                                                  Helpers.launchURL(
                                                      'https://www.google.com/maps/dir/?api=1&destination=${post.lat}'
                                                      ',${post.lng}&mode=d',
                                                      context);
                                                } else if (post.user!.lat !=
                                                    null) {
                                                  Helpers.launchURL(
                                                      'https://www.google.com/maps/dir/?api=1&destination=${post.user!.lat}'
                                                      ',${post.user!.lng}&mode=d',
                                                      context);
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? AppColors.greyTextColor
                                                      : AppColors.whiteColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.r),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 7, vertical: 4),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      S.current.driveUp
                                                          .toUpperCase(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium
                                                          ?.copyWith(
                                                              fontSize: 12),
                                                    ),
                                                    SizedBox(width: 3),
                                                    Icon(
                                                      Icons.navigation,
                                                      size: 21,
                                                      color: Colors.blue,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            if (widget.post.time != null) ...{
                                              SizedBox(width: 10),
                                              Text(
                                                  "${Helpers.handelMinuet(post.time!)}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      )),
                                              SizedBox(width: 10),
                                            },

                                            ///DISTANCE KM CONTAINER
                                            if (widget.post.distance !=
                                                null) ...{
                                              Text(
                                                "${post.distance?.ceil()} ${S.current.km.toUpperCase()}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                              ),
                                              SizedBox(width: 4),
                                            },
                                          ],
                                        ),
                                      ],
                                    ),
                                    StarRating(
                                        value: (post.user?.rate ?? 0).toInt()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5.h),
                          if (post.additionalInfo != null &&
                              post.additionalInfo != "")
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    S.current.additionalInfo,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontSize: 14.sp,
                                          color: Theme.of(context)
                                              .primaryColorDark
                                              .withOpacity(0.7),
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    "${post.additionalInfo}",
                                    overflow: TextOverflow.clip,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                      height: 1.5,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black87,
                                            offset: Offset(0, 0),
                                            blurRadius: 0.0),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (post.postCategoryOption != null &&
                              post.postCategoryOption!.isNotEmpty) ...{
                            ViewAllIconHeader(
                                leadingText: S.current.specifications,
                                withIcon: false,
                                onNavigate: () {}),
                            ...post.postCategoryOption!
                                .map((e) => RowSection(
                                    title: e.name.toString(),
                                    body: e.value.toString()))
                                .toList(),
                          },
                          SizedBox(height: 10.h),
                          if (post.postTaggedPosts != null &&
                              post.postTaggedPosts!.isNotEmpty) ...{
                            SizedBox(height: 6.h),
                            CustomPostsGrid(
                              title: S.current.liftUpPosts.toUpperCase(),
                              postList: post.postTaggedPosts ?? [],
                              onPostTapShowInList: true,
                            ),
                            // SingleChildScrollView(
                            //   scrollDirection: Axis.horizontal,
                            //   child: Row(
                            //     children: post.postTaggedPosts!
                            //         .map((e) => Container(
                            //             margin:
                            //                 EdgeInsets.symmetric(horizontal: 4),
                            //             width:
                            //                 Helpers.getPostWidgetWidth(context),
                            //             child: PostWidget(
                            //               post: e,
                            //               withDetails: false,
                            //               onTap: () {
                            //                 Navigator.of(context).pushNamed(
                            //                     PostListViewScreen.routName,
                            //                     arguments: {
                            //                       "postList":
                            //                           post.postTaggedPosts,
                            //                       "index": post.postTaggedPosts!
                            //                           .indexOf(e),
                            //                     });
                            //               },
                            //             )))
                            //         .toList(),
                            //   ),
                            // ),
                            SizedBox(height: 10.h),
                          },
                          if (post.postTaggedProfiles != null &&
                              post.postTaggedProfiles!.isNotEmpty) ...{
                            ViewAllIconHeader(
                                leadingText: S.current.liftUpProfiles,
                                onNavigate: () {
                                  AppModalBottomSheet.showMainModalBottomSheet(
                                      context: context,
                                      scrollableContent: ProfileGridView(
                                          post.postTaggedProfiles!,
                                          withFollowButton: true,
                                          isScroll: true));
                                }),
                            SizedBox(height: 6.h),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: post.postTaggedProfiles!
                                    .map((e) => ProfileWidget(
                                        user: e, withFollowButton: true))
                                    .toList(),
                              ),
                            ),
                          },
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        BlocBuilder<CommentCubit, CommentState>(
                            bloc: _commentCubit,
                            builder: (context, state) {
                              return IconTextHorizontalButton(
                                icon: IconlyBold.chat,
                                number: "${post.commentsNumber}",
                                canGustTap: true,
                                size: 26.sp,
                                onTapIcon: () {
                                  _postCommentCubit.getComments(post.id!);
                                  AppModalBottomSheet.showMainModalBottomSheet(
                                    context: context,
                                    scrollableContent: StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return BlocBuilder<PostCommentCubit,
                                              PostCommentState>(
                                          bloc: _postCommentCubit,
                                          builder: (context, state) {
                                            if (state is PostCommentLoading) {
                                              return const CenteredCircularProgressIndicator();
                                            }
                                            if (state is PostCommentFailure) {
                                              return ErrorHandler(
                                                      exception:
                                                          state.exception)
                                                  .buildErrorWidget(
                                                      context: context,
                                                      retryCallback: () =>
                                                          _postCommentCubit
                                                              .getComments(
                                                                  post.id!));
                                            }
                                            if (state is PostCommentLoaded) {
                                              List<CommentModel> list =
                                                  state.response.commentList!;
                                              return BlocConsumer<CommentCubit,
                                                      CommentState>(
                                                  bloc: _commentCubit,
                                                  listener: (context, state) {
                                                    if (state is CommentAdded) {
                                                      post.commentsNumber++;
                                                      CommentModel c =
                                                          state.response;
                                                      c.user = context
                                                          .read<
                                                              AppConfigCubit>()
                                                          .getUser();
                                                      list.add(c);
                                                      commentController.clear();
                                                    }
                                                    if (state
                                                        is CommentDeleted) {
                                                      post.commentsNumber--;
                                                      list.removeWhere(
                                                          (element) =>
                                                              element.id
                                                                  .toString() ==
                                                              state.response);
                                                    }
                                                  },
                                                  builder: (context, state) {
                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                              child: list
                                                                      .isEmpty
                                                                  ? EmptyCard(
                                                                      withIcon:
                                                                          false,
                                                                      massage: S
                                                                          .current
                                                                          .NoCommentsToDisplay)
                                                                  : ListView(
                                                                      physics:
                                                                          const BouncingScrollPhysics(),
                                                                      children: list
                                                                          .map((e) => CommentWidget(
                                                                              comment: e,
                                                                              commentCubit: _commentCubit))
                                                                          .toList(),
                                                                    )),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                            child:
                                                                EditTextField(
                                                              controller:
                                                                  commentController,
                                                              label: "",
                                                              onChanged: () {
                                                                setState(() {});
                                                              },
                                                              hintText: S
                                                                  .current
                                                                  .writeComment,
                                                              suffixWidget:
                                                                  IconButton(
                                                                      onPressed: commentController
                                                                              .text
                                                                              .isEmpty
                                                                          ? null
                                                                          : () {
                                                                              _commentCubit.addComment(postId: post.id!, comment: commentController.text);
                                                                            },
                                                                      icon: Icon(
                                                                          Icons
                                                                              .send,
                                                                          color:
                                                                              AppColors.primaryColor)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            }
                                            return Container();
                                          });
                                    }),
                                  );
                                },
                              );
                            }),
                        BlocConsumer<BookmarkPostCubit, BookmarkPostState>(
                            bloc: _bookmarkPostCubit,
                            listener: (context, state) {
                              if (state is BookmarkPostDone) {
                                post.isBookmark = !post.isBookmark;
                                if (post.isBookmark) {
                                  post.bookmarkNumber++;
                                } else {
                                  post.bookmarkNumber--;
                                }
                              }
                            },
                            builder: (context, state) {
                              return IconTextHorizontalButton(
                                icon: post.isBookmark
                                    ? IconlyBold.bookmark
                                    : IconlyBold.bookmark,
                                iconColor: post.isBookmark
                                    ? Colors.grey.shade500
                                    : null,
                                number: "${post.bookmarkNumber}",
                                size: 30.0,
                                onTapIcon: () {
                                  _bookmarkPostCubit
                                      .bookmarkUnBookmarkPost(post.id!);
                                },
                                onTapText: () {
                                  _bookmarkPostCubit
                                      .getPostUsersBookmarkList(post.id!);
                                  AppModalBottomSheet.showMainModalBottomSheet(
                                    context: context,
                                    scrollableContent: BlocBuilder<
                                            BookmarkPostCubit,
                                            BookmarkPostState>(
                                        bloc: _bookmarkPostCubit,
                                        builder: (context, state) {
                                          if (state
                                              is BookmarkPostUserListLoading) {
                                            return const CenteredCircularProgressIndicator();
                                          }
                                          if (state
                                              is BookmarkPostUserListFailure) {
                                            return ErrorHandler(
                                                    exception: state.exception)
                                                .buildErrorWidget(
                                                    context: context,
                                                    retryCallback: () =>
                                                        _bookmarkPostCubit
                                                            .getPostUsersBookmarkList(
                                                                post.id!));
                                          }
                                          if (state
                                              is BookmarkPostUserListDone) {
                                            List<User> list = state
                                                .response.bookmarkUserList!;
                                            return ListView(
                                              children: list
                                                  .map((e) => UserWidget(
                                                      e, _followUserCubit))
                                                  .toList(),
                                            );
                                          }
                                          return Container();
                                        }),
                                  );
                                },
                              );
                            }),
                        if (post.postType == Constants.postUpKey && post.contactCallNumber!=null)
                          Padding(
                            padding: EdgeInsets.all(14.0),
                            child: PostCallButton(post: post),
                          ),
                        if (post.postType != Constants.postUpKey)
                          Padding(
                            padding: EdgeInsets.all(14.0),
                            child: PostButton(post: post),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }
            return Container();
          }),
    );
  }

  Widget _buildDescription(BuildContext context, {required String text}) {
    if (text.isEmpty) return SizedBox.shrink();

    List<TextSpan> spans = [];

    final words = text.split(' ');
    for (var word in words) {
      if (word.startsWith('#')) {
        spans.add(
          TextSpan(
            text: word + ' ',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // On tap hashtag
                FutureSender.send<HashtagModel?>(
                  context,
                  future: () =>
                      context.read<HashtagCubit>().getHashtagByName(word),
                  onError: (e) {
                    AppToast(message: e.message).show();
                  },
                  onSuccess: (value) {
                    if (value == null) return;
                    Navigator.of(context)
                        .pushNamed(HashtagPostScreen.routName, arguments: {
                      "hashtag": PostHashtag(name: value.name, id: value.id),
                    });
                  },
                );
              },
          ),
        );
      } else if (word.startsWith('@')) {
        spans.add(
          TextSpan(
            text: word + ' ',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.blue, fontSize: 15),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // On tap Mention
                FutureSender.send<User?>(
                  context,
                  future: () =>
                      context.read<MentionCubit>().getUserByName(word),
                  onError: (e) {
                    AppToast(message: e.message).show();
                  },
                  onSuccess: (value) {
                    if (value == null) return;
                    Navigator.of(AppRouter.mainContext).pushNamed(
                        ProfileScreen.routName,
                        arguments: {"isOther": true, "user": value});
                  },
                );
              },
          ),
        );
      } else {
        spans.add(TextSpan(
            text: word + ' ',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 15)));
      }
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }
}
