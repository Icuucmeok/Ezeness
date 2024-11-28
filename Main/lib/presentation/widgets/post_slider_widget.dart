import 'package:ezeness/data/models/comment/comment.dart';
import 'package:ezeness/data/models/hashtag/hashtag.dart';
import 'package:ezeness/logic/cubit/bookmark_post/bookmark_post_cubit.dart';
import 'package:ezeness/logic/cubit/comment/comment_cubit.dart';
import 'package:ezeness/logic/cubit/hashtag/hashtag_cubit.dart';
import 'package:ezeness/logic/cubit/liftup_post/liftup_post_cubit.dart';
import 'package:ezeness/logic/cubit/like_post/like_post_cubit.dart';
import 'package:ezeness/logic/cubit/mention/mention_cubit.dart';
import 'package:ezeness/logic/cubit/post/post_cubit.dart';
import 'package:ezeness/logic/cubit/post_comment/post_comment_cubit.dart';
import 'package:ezeness/logic/cubit/report/report_cubit.dart';
import 'package:ezeness/presentation/screens/post/hashtag_post_screen.dart';
import 'package:ezeness/presentation/utils/app_toast.dart';
import 'package:ezeness/presentation/utils/future_sender.dart';
import 'package:ezeness/presentation/widgets/image_viewer_widget.dart';
import 'package:ezeness/presentation/widgets/post_button.dart';
import 'package:ezeness/presentation/widgets/mention_hashtag_text_field.dart';
import 'package:ezeness/presentation/widgets/post_call_button.dart';
import 'package:ezeness/presentation/widgets/user_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ezeness/presentation/screens/post/post_details_screen.dart';
import 'package:ezeness/presentation/utils/app_modal_bottom_sheet.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/presentation/widgets/common/video_widget.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertagger/fluttertagger.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart' as intl;
import '../../data/models/user/user.dart';
import '../../data/models/post/post.dart';
import '../../data/utils/error_handler.dart';
import '../../generated/l10n.dart';
import '../../logic/cubit/add_edit_post/add_edit_post_cubit.dart';
import '../../logic/cubit/app_config/app_config_cubit.dart';
import '../../logic/cubit/block_user/block_user_cubit.dart';
import '../../logic/cubit/delete_post/delete_post_cubit.dart';
import '../../logic/cubit/follow_user/follow_user_cubit.dart';
import '../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../router/app_router.dart';
import '../screens/profile/profile/profile_screen.dart';
import '../utils/app_dialog.dart';
import '../utils/app_snackbar.dart';
import 'circle_avatar_icon_widget.dart';
import 'comment_widget.dart';
import 'common/common.dart';
import 'more_post_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostSliderWidget extends StatefulWidget {
  const PostSliderWidget(
      {Key? key, required this.post, this.isFromDiscover = false})
      : super(key: key);

  final Post post;
  final bool isFromDiscover;

  @override
  State<PostSliderWidget> createState() => _PostSliderWidgetState();
}

int _currentIndex = 1;

class _PostSliderWidgetState extends State<PostSliderWidget> {
  late CommentCubit _commentCubit;
  late LikePostCubit _likePostCubit;
  late BookmarkPostCubit _bookmarkPostCubit;
  late LiftUpPostCubit _liftUpPostCubit;
  late PostCommentCubit _postCommentCubit;
  late DeletePostCubit _deletePostCubit;
  late BlockUserCubit _blockUserCubit;
  late ReportCubit _reportCubit;
  late PostCubit _postCubit;
  late FollowUserCubit _followUserCubit;
  CommentModel? commentToRely;
  final FlutterTaggerController commentController = FlutterTaggerController();
  @override
  void initState() {
    _postCubit = context.read<PostCubit>();
    _commentCubit = context.read<CommentCubit>();
    _likePostCubit = context.read<LikePostCubit>();
    _liftUpPostCubit = context.read<LiftUpPostCubit>();
    _bookmarkPostCubit = context.read<BookmarkPostCubit>();
    _postCommentCubit = context.read<PostCommentCubit>();
    _deletePostCubit = context.read<DeletePostCubit>();
    _blockUserCubit = context.read<BlockUserCubit>();
    _reportCubit = context.read<ReportCubit>();
    _followUserCubit = context.read<FollowUserCubit>();
    _postCubit.increaseViews(widget.post.id!,
        isFromDiscover: widget.isFromDiscover);
    _currentIndex = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.select<AppConfigCubit, User>((bloc) => bloc.state.user);
    bool isLoggedIn = context.read<SessionControllerCubit>().isLoggedIn();
    User loggedInUser = context.read<AppConfigCubit>().getUser();
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<AddEditPostCubit, AddEditPostState>(
        builder: (context, state) {
          return BlocConsumer<ReportCubit, ReportState>(
            bloc: _reportCubit,
            listener: (context, state) {
              if (state is ReportPostDone) {
                widget.post.isPostAvailable = false;
              }
            },
            builder: (context, state) {
              return BlocConsumer<DeletePostCubit, DeletePostState>(
                bloc: _deletePostCubit,
                listener: (context, state) {
                  if (state is DeletePostLoading) {
                    AppDialog.showLoadingDialog(context: context);
                  }
                  if (state is DeletePostFailure) {
                    AppDialog.closeAppDialog();
                    ErrorHandler(exception: state.exception)
                        .showErrorSnackBar(context: context);
                  }
                  if (state is DeletePostDone) {
                    widget.post.isPostAvailable = false;
                    AppDialog.closeAppDialog();
                    AppSnackBar(
                            context: context,
                            message: S.current.deletedSuccessfully)
                        .showSuccessSnackBar();
                  }
                },
                builder: (context, state) {
                  return BlocConsumer<BlockUserCubit, BlockUserState>(
                    bloc: _blockUserCubit,
                    listener: (context, state) {
                      if (state is BlockUserLoading) {
                        AppDialog.showLoadingDialog(context: context);
                      }
                      if (state is BlockUserFailure) {
                        AppDialog.closeAppDialog();
                        ErrorHandler(exception: state.exception)
                            .showErrorSnackBar(context: context);
                      }
                      if (state is BlockUserDone) {
                        widget.post.isPostAvailable = false;
                        AppDialog.closeAppDialog();
                        AppSnackBar(
                                context: context,
                                message: S.current.blockedSuccessfully)
                            .showSuccessSnackBar();
                      }
                    },
                    builder: (context, state) {
                      return BlocConsumer<LikePostCubit, LikePostState>(
                        bloc: _likePostCubit,
                        listener: (context, state) {
                          if (state is LikePostDone) {
                            widget.post.isLike = !widget.post.isLike;
                            if (widget.post.isLike) {
                              widget.post.likeNumber++;
                            } else {
                              widget.post.likeNumber--;
                            }
                          }
                        },
                        builder: (context, state) {
                          return !widget.post.isPostAvailable
                              ? EmptyCard(
                                  withIcon: false,
                                  massage: S.current.postNotAvailable)
                              : Stack(
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.none,
                                  children: [
                                    PageView(
                                      scrollDirection: Axis.horizontal,
                                      onPageChanged: (index) {
                                        setState(() {
                                          _currentIndex = index + 1;
                                        });
                                      },
                                      children:
                                          widget.post.postMediaList!.map((e) {
                                        return Container(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            color: Colors.black,
                                            alignment: AlignmentDirectional
                                                .centerStart,
                                            child: Helpers.isTab(context)
                                                ? AspectRatio(
                                                    aspectRatio: 9 / 16,
                                                    child: _buildContent(e),
                                                  )
                                                : _buildContent(e));
                                      }).toList(),
                                    ),
                                    widget.post.postMediaList!.length > 1
                                        ? Positioned(
                                            right: 15.0,
                                            top: 80.0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  colors: [
                                                    Colors.blue,
                                                    Colors.red,
                                                  ],
                                                ),
                                              ),
                                              width: 40.0,
                                              height: 25.0,
                                              child: Container(
                                                width: 30.0,
                                                height: 25.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.black87,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                margin: EdgeInsets.all(1.0),
                                                child: Center(
                                                  child: Text(
                                                    "$_currentIndex/${widget.post.postMediaList!.length}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    Positioned(
                                      left: 15,
                                      right: 15,
                                      bottom: 10,
                                      child: _buildPostActions(
                                          context, isLoggedIn, loggedInUser),
                                    ),
                                    // Build Tablet price + discount
                                    if (widget.post.postType! !=
                                            Constants.postUpKey &&
                                        Helpers.isTab(context))
                                      PositionedDirectional(
                                        end: MediaQuery.of(context).size.width *
                                            0.22,
                                        bottom: 35,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            if (widget.post.postType! !=
                                                    Constants.postUpKey &&
                                                widget.post.discount != null &&
                                                widget.post.discount != 0 &&
                                                Helpers.isTab(context))
                                              _buildDiscount(),
                                            SizedBox(height: 10),

                                            ///PRICE AND CURRENCY CONTAINER
                                            _buildPriceAndCurrency(context),
                                            SizedBox(height: 10)
                                          ],
                                        ),
                                      ),

                                    // Build Tablet call button
                                    if (widget.post.postType ==
                                            Constants.postUpKey &&
                                        Helpers.isTab(context) && widget.post.contactCallNumber!=null)
                                        PositionedDirectional(
                                          end: MediaQuery
                                              .of(context)
                                              .size
                                              .width *
                                              0.08,
                                          bottom: 45,
                                          child: PostCallButton(
                                            post: widget.post,
                                            isLarge: true,
                                          ),
                                        ),

                                    if (widget.post.postType !=
                                        Constants.postUpKey &&
                                        Helpers.isTab(context))
                                        PositionedDirectional(
                                          end: MediaQuery
                                              .of(context)
                                              .size
                                              .width *
                                              0.08,
                                          bottom: 45,
                                          child: PostButton(
                                            post: widget.post,
                                            isLarge: true,
                                          ),
                                        ),

                                  ],
                                );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Builder _buildContent(PostMedia e) {
    return Builder(
      builder: (context) {
        if (e.type != "video") {
          return ImageViewerWidget(
              child: Image.network(
            e.path.toString(),
            fit: BoxFit.fitWidth,
          ));
        } else {
          return VideoWidget(media: e);
        }
      },
    );
  }

  Widget _buildPostActions(
      BuildContext context, bool isLoggedIn, User loggedInUser) {
    User? userInfo = widget.post.liftUpResponse == null
        ? widget.post.user
        : widget.post.liftUpResponse!.user;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(AppRouter.mainContext).pushNamed(
                    ProfileScreen.routName,
                    arguments: {"isOther": true, "user": userInfo});
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatarIconWidget(
                    userProfileImage: userInfo!.image.toString(),
                    size: 45,
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width / 2.3),
                            child: Text(
                              "${userInfo.name}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                                shadows: [
                                  Shadow(
                                      color: Colors.black87,
                                      offset: Offset(1, 1),
                                      blurRadius: 1.0),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          if (userInfo.proUsername != null)
                            Icon(Icons.verified,
                                size: 25, color: Colors.lightBlue),
                        ],
                      ),
                      if (widget.post.childCategory != null)
                        Text(
                          "${widget.post.childCategory?.name}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                            shadows: [
                              Shadow(
                                  color: Colors.black38,
                                  offset: Offset(1, 1),
                                  blurRadius: 0.1),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: Helpers.isTab(context)
                  ? MediaQuery.of(context).size.width * 0.19
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconTextVerticalButton(
                    size: 35,
                    iconColor:
                        widget.post.isLike ? Colors.red.withOpacity(0.9) : null,
                    icon: widget.post.isLike
                        ? IconlyBold.heart
                        : IconlyBold.heart,
                    number: "${widget.post.likeNumber}",
                    onLongPressIcon: () {
                      if (widget.post.isLike)
                        _likePostCubit.likeUnLikePost(widget.post.id!);
                    },
                    onTapIcon: () {
                      if (widget.post.isLike) {
                        AppToast(message: S.current.unlikeText).show();
                      } else {
                        _likePostCubit.likeUnLikePost(widget.post.id!);
                      }
                    },
                    onTapText: () {
                      _likePostCubit.getPostUsersLikeList(widget.post.id!);
                      AppModalBottomSheet.showMainModalBottomSheet(
                        context: context,
                        scrollableContent: BlocBuilder<LikePostCubit,
                                LikePostState>(
                            bloc: _likePostCubit,
                            builder: (context, state) {
                              if (state is LikePostUserListLoading) {
                                return const CenteredCircularProgressIndicator();
                              }
                              if (state is LikePostUserListFailure) {
                                return ErrorHandler(exception: state.exception)
                                    .buildErrorWidget(
                                        context: context,
                                        retryCallback: () =>
                                            _likePostCubit.getPostUsersLikeList(
                                                widget.post.id!));
                              }
                              if (state is LikePostUserListDone) {
                                List<User> list = state.response.likeUserList!;
                                return ListView(
                                  children: list
                                      .map((e) =>
                                          UserWidget(e, _followUserCubit))
                                      .toList(),
                                );
                              }
                              return Container();
                            }),
                      );
                    },
                  ),
                  BlocBuilder<CommentCubit, CommentState>(
                      bloc: _commentCubit,
                      builder: (context, state) {
                        return IconTextVerticalButton(
                          icon: IconlyBold.chat,
                          canGustTap: true,
                          size: 35,
                          number: "${widget.post.commentsNumber}",
                          onTapIcon: () {
                            commentController.clear();
                            commentToRely = null;
                            _postCommentCubit.getComments(widget.post.id!);
                            _showCommentsBottomSheet(context, isLoggedIn);
                          },
                        );
                      }),
                  BlocConsumer<BookmarkPostCubit, BookmarkPostState>(
                      bloc: _bookmarkPostCubit,
                      listener: (context, state) {
                        if (state is BookmarkPostDone) {
                          widget.post.isBookmark = !widget.post.isBookmark;
                          if (widget.post.isBookmark) {
                            widget.post.bookmarkNumber++;
                          } else {
                            widget.post.bookmarkNumber--;
                          }
                        }
                      },
                      builder: (context, state) {
                        return IconTextVerticalButton(
                          iconColor: widget.post.isBookmark
                              ? Colors.grey.shade500
                              : null,
                          icon: widget.post.isBookmark
                              ? IconlyBold.bookmark
                              : IconlyBold.bookmark,
                          size: 35,
                          number: "${widget.post.bookmarkNumber}",
                          onTapIcon: () {
                            _bookmarkPostCubit
                                .bookmarkUnBookmarkPost(widget.post.id!);
                          },
                          onTapText: () {
                            _bookmarkPostCubit
                                .getPostUsersBookmarkList(widget.post.id!);
                            AppModalBottomSheet.showMainModalBottomSheet(
                              context: context,
                              scrollableContent: BlocBuilder<BookmarkPostCubit,
                                      BookmarkPostState>(
                                  bloc: _bookmarkPostCubit,
                                  builder: (context, state) {
                                    if (state is BookmarkPostUserListLoading) {
                                      return const CenteredCircularProgressIndicator();
                                    }
                                    if (state is BookmarkPostUserListFailure) {
                                      return ErrorHandler(
                                              exception: state.exception)
                                          .buildErrorWidget(
                                              context: context,
                                              retryCallback: () =>
                                                  _bookmarkPostCubit
                                                      .getPostUsersBookmarkList(
                                                          widget.post.id!));
                                    }
                                    if (state is BookmarkPostUserListDone) {
                                      List<User> list =
                                          state.response.bookmarkUserList!;
                                      return ListView(
                                        children: list
                                            .map((e) =>
                                                UserWidget(e, _followUserCubit))
                                            .toList(),
                                      );
                                    }
                                    return Container();
                                  }),
                            );
                          },
                        );
                      }),
                  BlocConsumer<LiftUpPostCubit, LiftUpPostState>(
                      bloc: _liftUpPostCubit,
                      listener: (context, state) {
                        if (state is LiftUpPostDone) {
                          widget.post.isLiftUp = !widget.post.isLiftUp;
                          if (widget.post.isLiftUp) {
                            widget.post.liftUps++;
                            AppSnackBar(
                                    context: context,
                                    message: S.current.postLifttedUp)
                                .showSuccessSnackBar();
                          } else {
                            widget.post.liftUps--;
                          }
                        }
                      },
                      builder: (context, state) {
                        return IconTextVerticalButton(
                          icon: CupertinoIcons.link_circle,
                          onTapIcon: () {
                            if (widget.post.user!.id == loggedInUser.id) return;

                            _liftUpPostCubit
                                .liftUpUnLiftUpPost(widget.post.id!);
                          },
                          iconColor:
                              widget.post.isLiftUp ? AppColors.gold : null,
                          number: "${widget.post.liftUps}",
                          canGustTap: false,
                          onTapText: () {
                            _liftUpPostCubit
                                .getPostUsersLiftUpList(widget.post.id!);
                            AppModalBottomSheet.showMainModalBottomSheet(
                              context: context,
                              scrollableContent: BlocBuilder<LiftUpPostCubit,
                                      LiftUpPostState>(
                                  bloc: _liftUpPostCubit,
                                  builder: (context, state) {
                                    if (state is LiftUpPostUserListLoading) {
                                      return const CenteredCircularProgressIndicator();
                                    }
                                    if (state is LiftUpPostUserListFailure) {
                                      return ErrorHandler(
                                              exception: state.exception)
                                          .buildErrorWidget(
                                              context: context,
                                              retryCallback: () =>
                                                  _liftUpPostCubit
                                                      .getPostUsersLiftUpList(
                                                          widget.post.id!));
                                    }
                                    if (state is LiftUpPostUserListDone) {
                                      List<User> list =
                                          state.response.liftUpUserList!;
                                      return ListView(
                                        children: list
                                            .map((e) =>
                                                UserWidget(e, _followUserCubit))
                                            .toList(),
                                      );
                                    }
                                    return Container();
                                  }),
                            );
                          },
                        );
                      }),
                  MorePostButton(post: widget.post),
                  SizedBox(height: Helpers.isTab(context) ? 12 : 30)
                ],
              ),
            ),
          ],
        ),
        _buildDistance(context),

        ///CAPTION & PRICE MAIN CONTAINER
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.0),
                      ]
                    : [
                        Colors.red.withOpacity(0.0),
                        Colors.black.withOpacity(0.0),
                        Colors.red.withOpacity(0.0),
                      ]),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(5.0),
            ),
          ),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                color: Colors.transparent,
                child: Row(
                  children: [
                    widget.post.description == null
                        ? Expanded(child: SizedBox())
                        : Expanded(
                            child: _buildDescription(context,
                                text: widget.post.description ?? ""),
                            // child: Text(widget.post.description!,
                            //     overflow: TextOverflow.ellipsis,
                            //     maxLines: 2,
                            //     style: const TextStyle(
                            //       height: 1.7,
                            //       fontSize: 15,
                            //       fontWeight: FontWeight.w400,
                            //       color: Colors.white,
                            //       shadows: [
                            //         Shadow(
                            //             color: Colors.black45,
                            //             offset: Offset(1, 1),
                            //             blurRadius: 1.1),
                            //       ],
                            //     )),
                          ),
                    if (Helpers.isTab(context))
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                      ),
                    SizedBox(width: 45.0.w),
                    if (widget.post.postType! != Constants.postUpKey &&
                        widget.post.discount != null &&
                        widget.post.discount != 0 &&
                        !Helpers.isTab(context))
                      _buildDiscount(),
                  ],
                ),
              ),
              SizedBox(height: 1.0.w),
              if (!Helpers.isTab(context)) ...{
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ///PRICE AND CURRENCY CONTAINER
                    if(widget.post.postType != Constants.postUpKey)...{
                      _buildPriceAndCurrency(context),
                      ///POST TYPE BUTTON
                      PostButton(post: widget.post),
                    },

                    if(widget.post.postType == Constants.postUpKey && widget.post.contactCallNumber!=null)...{
                      SizedBox(),
                      PostCallButton(post: widget.post),
                    },


                  ],
                ),
              }
            ],
          ),
        ),
        SizedBox(height: 10),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Icon(IconlyBold.show, size: 18, color: Colors.white70),
                const SizedBox(width: 3),
                Text(
                    intl.NumberFormat.compact(locale: "en_US")
                        .format(widget.post.views),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.2,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                            color: Colors.black87,
                            offset: Offset(1, 1),
                            blurRadius: 1.0),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context, {required String text}) {
    // if (text.isEmpty) return SizedBox.shrink();

    List<TextSpan> spans = [];
    final words = text.split(' ');
    for (var word in words) {
      if (word.startsWith('#')) {
        spans.add(
          TextSpan(
            text: word + ' ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(1, 1),
                  blurRadius: 1.1,
                ),
              ],
            ),
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor,
              fontSize: 15,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(1, 1),
                  blurRadius: 1.1,
                ),
              ],
            ),
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
                      arguments: {"isOther": true, "user": value},
                    );
                  },
                );
              },
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: word + ' ',
            // recognizer: TapGestureRecognizer()
            //   ..onTap = () {
            //     // Post Detail
            //     Navigator.of(AppRouter.mainContext).pushNamed(
            //       PostDetailsScreen.routName,
            //       arguments: {"post": widget.post},
            //     );
            //   },
            style: const TextStyle(
              height: 1.7,
              overflow: TextOverflow.ellipsis,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.whiteColor,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(1, 1),
                  blurRadius: 1.1,
                ),
              ],
            ),
          ),
        );
      }
    }

    // Add "See more" at the end
    final seeMoreSpan = TextSpan(
      text: " " + S.current.seeMoreI,
      style: const TextStyle(
        height: 1.7,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.primaryColor,
        shadows: [
          Shadow(
            color: Colors.black45,
            offset: Offset(1, 1),
            blurRadius: 1.1,
          ),
        ],
      ),
      // recognizer: TapGestureRecognizer()
      //   ..onTap = () {
      //     // Post Detail
      //   },
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(AppRouter.mainContext).pushNamed(
          PostDetailsScreen.routName,
          arguments: {"post": widget.post},
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Measure the space available for text
          final textPainter = TextPainter(
            text: TextSpan(children: spans),
            maxLines: 2,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: constraints.maxWidth);

          if (textPainter.didExceedMaxLines) {
            // If the text exceeds two lines, truncate and append "See more"
            return RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: textPainter.text!.toPlainText().substring(
                          0,
                          textPainter
                              .getPositionForOffset(
                                  Offset(constraints.maxWidth, 0))
                              .offset,
                        ),
                  ),
                  seeMoreSpan, // Always append "See more"
                ],
              ),
            );
          } else {
            // If the text fits within two lines, display it normally
            return RichText(
              text: TextSpan(
                children: [...spans, seeMoreSpan],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDistance(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final post = widget.post;
        if (post.lat != null) {
          Helpers.launchURL(
              'https://www.google.com/maps/dir/?api=1&destination=${post.lat}'
              ',${post.lng}&mode=d',
              context);
        } else if (post.user!.lat != null) {
          Helpers.launchURL(
              'https://www.google.com/maps/dir/?api=1&destination=${post.user!.lat}'
              ',${post.user!.lng}&mode=d',
              context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.blackText.withOpacity(0.4),
          borderRadius: BorderRadius.circular(7.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.current.driveUp,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 12,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w300,
                  ),
            ),
            SizedBox(width: 8),

            Icon(
              Icons.navigation,
              size: 20,
              color: Colors.blue,
            ),

            if (widget.post.time != null) ...{
              SizedBox(width: 8),
              Text(
                "${Helpers.handelMinuet(widget.post.time!)}",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 12,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w300,
                    ),
              ),
              SizedBox(width: 8),
            },

            ///DISTANCE KM CONTAINER
            if (widget.post.distance != null)
              Text(
                "${widget.post.distance?.ceil()} ${S.current.km.toUpperCase()}",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 12,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w300,
                    ),
              ),
          ],
        ),
      ),
    );
  }

  Container _buildPriceAndCurrency(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(5),
        color: AppColors.darkColor.withOpacity(0.0),
      ),
      child: Text(
          '${Helpers.getCurrencyName(widget.post.priceCurrency.toString())} ${Helpers.numberFormatter(widget.post.sellPrice!)} ',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
            shadows: const [
              Shadow(
                  color: Colors.black87, offset: Offset(1, 1), blurRadius: 1.0),
            ],
          )),
    );
  }

  Widget _buildDiscount() {
    return Container(
      alignment: Alignment.center,
      width: 70,
      height: 45,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
          bottomLeft: Radius.circular(30.r),
        ),
        color: Colors.deepOrange.withOpacity(0.9),
      ),
      child: Center(
        child: Text(
          // '${Helpers.removeDecimalZeroFormat(widget.post.discount!)}%',
          "${widget.post.discount?.round() ?? ""}%",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: 1.0,
            color: Colors.white,
            shadows: [
              Shadow(
                  color: Colors.black45, offset: Offset(1, 1), blurRadius: 1.0),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, bool isLoggedIn) {
    AppModalBottomSheet.showMainModalBottomSheet(
      context: context,
      scrollableContent: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return BlocBuilder<PostCommentCubit, PostCommentState>(
            bloc: _postCommentCubit,
            builder: (context, state) {
              if (state is PostCommentLoading) {
                return const CenteredCircularProgressIndicator();
              }
              if (state is PostCommentFailure) {
                return ErrorHandler(exception: state.exception)
                    .buildErrorWidget(
                        context: context,
                        retryCallback: () =>
                            _postCommentCubit.getComments(widget.post.id!));
              }
              if (state is PostCommentLoaded) {
                List<CommentModel> list = state.response.commentList!;
                return BlocConsumer<CommentCubit, CommentState>(
                    bloc: _commentCubit,
                    listener: (context, state) {
                      if (state is CommentAdded) {
                        widget.post.commentsNumber++;
                        CommentModel c = state.response;
                        c.user = context.read<AppConfigCubit>().getUser();
                        list.add(c);
                        commentController.clear();
                      }
                      if (state is CommentReplyAdded) {
                        CommentModel c = state.response;
                        CommentModel parentComment = list.firstWhere(
                            (element) =>
                                element.id.toString() ==
                                c.parentCommentId.toString());
                        c.user = context.read<AppConfigCubit>().getUser();
                        parentComment.replies.add(c);
                        _commentCubit.setCommentToReply(null);
                        commentController.clear();
                      }
                      if (state is CommentDeleted) {
                        widget.post.commentsNumber--;
                        list.removeWhere((element) =>
                            element.id.toString() == state.response);
                      }
                      if (state is CommentReplyToCommentSet) {
                        commentToRely = state.response;
                        if (commentToRely == null) {
                          commentController.clear();
                        } else {
                          commentController.text =
                              "@${commentToRely!.user!.getUserName()} ";
                        }
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
                                        massage: S.current.NoCommentsToDisplay)
                                    : ListView(
                                        physics: const BouncingScrollPhysics(),
                                        children: list
                                            .map((e) => CommentWidget(
                                                comment: e,
                                                commentCubit: _commentCubit))
                                            .toList(),
                                      )),
                            if (isLoggedIn) ...{
                              if (commentToRely != null)
                                Container(
                                  height: 40.h,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppColors.whiteTransparent,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(S.current.replyTo(commentToRely!
                                          .user!
                                          .getUserName()
                                          .toString())),
                                      IconButton(
                                          onPressed: () {
                                            _commentCubit
                                                .setCommentToReply(null);
                                          },
                                          icon: Icon(Icons.clear)),
                                    ],
                                  ),
                                ),
                              // Text Filed
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: MentionHashtagTextField(
                                  label: "",
                                  minLine: 1,
                                  maxLine: 4,
                                  hintText: commentToRely == null
                                      ? S.current.writeComment
                                      : S.current.replyTo(commentToRely!.user!
                                          .getUserName()
                                          .toString()),
                                  controller: commentController,
                                  onChanged: () {
                                    setState(() {});
                                  },
                                  suffixWidget: IconButton(
                                      onPressed: commentController.text.isEmpty
                                          ? null
                                          : () {
                                              if (commentToRely == null) {
                                                _commentCubit.addComment(
                                                    postId: widget.post.id!,
                                                    comment:
                                                        commentController.text);
                                              } else {
                                                _commentCubit.addReply(
                                                    postId: widget.post.id!,
                                                    comment:
                                                        commentController.text,
                                                    commentId: commentToRely!
                                                                .parentCommentId ==
                                                            null
                                                        ? commentToRely!.id!
                                                        : commentToRely!
                                                            .parentCommentId!);
                                              }
                                            },
                                      icon: Icon(Icons.send,
                                          color: AppColors.primaryColor)),
                                ),
                              ),
                            },
                          ],
                        ),
                      );
                    });
              }
              return Container();
            });
      }),
    );
  }
}
