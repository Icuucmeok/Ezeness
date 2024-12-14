import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/data/models/post_list_view_load_more_body.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/logic/cubit/bookmark_user/bookmark_user_cubit.dart';
import 'package:ezeness/logic/cubit/follow_user/follow_user_cubit.dart';
import 'package:ezeness/logic/cubit/loadMore/load_more_cubit.dart';
import 'package:ezeness/logic/cubit/profile/profile_cubit.dart';
import 'package:ezeness/presentation/router/app_router.dart';
import 'package:ezeness/presentation/screens/profile/edit_profile_screen/edit_profile_screen.dart';
import 'package:ezeness/presentation/screens/profile/menu_screen.dart';
import 'package:ezeness/presentation/screens/profile/profile/widgets/profile_header_widget.dart';
import 'package:ezeness/presentation/utils/app_modal_bottom_sheet.dart';
import 'package:ezeness/presentation/utils/app_snackbar.dart';
import 'package:ezeness/presentation/widgets/common/components/custom_posts_grid.dart';
import 'package:ezeness/presentation/widgets/common/guest_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import '../../../../data/models/pagination_page.dart';
import '../../../../data/models/post/post_list.dart';
import '../../../../data/utils/error_handler.dart';
import '../../../../generated/l10n.dart';
import '../../../../logic/cubit/add_edit_post/add_edit_post_cubit.dart';
import '../../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../../logic/cubit/block_user/block_user_cubit.dart';
import '../../../../logic/cubit/my_post/my_post_cubit.dart';
import '../../../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../../../../logic/cubit/subscribe_user_notification/subscribe_user_notification_cubit.dart';
import '../../../../logic/cubit/user_post/user_post_cubit.dart';
import '../../../utils/app_dialog.dart';
import '../../../widgets/category_widget.dart';
import '../../../widgets/common/common.dart';
import '../../../widgets/common/share_user_button.dart';
import '../../../widgets/pull_to_refresh.dart';
import '../../category/category_screen.dart';
import '../add_edit_post/add_edit_post_screen.dart';
import '../bookmark_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;
  final bool isOther;
  const ProfileScreen({this.isOther = false, this.user, Key? key})
      : super(key: key);
  static const String routName = 'profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  late ProfileCubit _profileCubit;
  late User user;
  late MyPostCubit _myPostCubit;
  late UserPostCubit _userPostCubit;
  late FollowUserCubit _followUserCubit;
  late BookmarkUserCubit _bookmarkUserCubit;
  late SubscribeUserNotificationCubit _subscribeUserNotificationCubit;
  late BlockUserCubit _blockUserCubit;
  late LoadMoreCubit _loadMoreCubit;
  ScrollController scrollController = ScrollController();
  PaginationPage myPostPage = PaginationPage(currentPage: 2);
  PaginationPage userPostPage = PaginationPage(currentPage: 2);
  List<Post> userPostList = [];
  List<Post> myPostList = [];
  late User loggedInUser;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    loggedInUser = context.read<AppConfigCubit>().getUser();
    _loadMoreCubit = context.read<LoadMoreCubit>();
    _profileCubit = context.read<ProfileCubit>();
    _bookmarkUserCubit = context.read<BookmarkUserCubit>();
    _followUserCubit = context.read<FollowUserCubit>();
    _myPostCubit = context.read<MyPostCubit>();
    _subscribeUserNotificationCubit =
        context.read<SubscribeUserNotificationCubit>();
    _userPostCubit = context.read<UserPostCubit>();
    _blockUserCubit = context.read<BlockUserCubit>();

    if (widget.isOther) {
      _profileCubit.getUserProfile(widget.user!.id!);
      _userPostCubit.getPostByUser(widget.user!.id!);
    } else {
      _profileCubit.getMyProfile(context.read<AppConfigCubit>());
      _myPostCubit.getMyPosts();
    }
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          _loadMoreCubit.state is! LoadMoreLoading) {
        if (widget.isOther) {
          _loadMoreCubit.loadMoreUserPost(userPostPage,
              userId: widget.user!.id!);
        } else {
          _loadMoreCubit.loadMoreMyPost(myPostPage);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = context.read<SessionControllerCubit>().isLoggedIn();
    bool isKids = context.read<SessionControllerCubit>().getIsKids() == 1;
    super.build(context);
    return !widget.isOther && !isLoggedIn
        ? const Scaffold(body: GuestView())
        : Scaffold(
            appBar: AppBar(
              title: BlocBuilder<ProfileCubit, ProfileState>(
                  bloc: _profileCubit,
                  builder: (context, state) {
                    if (state is ProfileLoaded) {
                      return Row(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width / 2),
                            child: Text(
                              "@${user.proUsername ?? user.username}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .primaryColorDark
                                          .withOpacity(0.7),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16.sp),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          if (user.proUsername != null)
                            Icon(
                              Icons.verified,
                              size: 18.dg,
                              color: Colors.lightBlue,
                            ),
                        ],
                      );
                    }
                    return SizedBox();
                  }),
              actions: [
                if (widget.isOther)
                  BlocBuilder<ProfileCubit, ProfileState>(
                      bloc: _profileCubit,
                      builder: (context, state) {
                        if (state is ProfileLoaded &&
                            user.id != loggedInUser.id) {
                          return IconButton(
                            onPressed: () {
                              AppModalBottomSheet.showMainModalBottomSheet(
                                height: 130.h,
                                context: context,
                                scrollableContent: Padding(
                                  padding: EdgeInsets.all(10.0.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      BlocConsumer<BookmarkUserCubit,
                                              BookmarkUserState>(
                                          bloc: _bookmarkUserCubit,
                                          listener: (context, state) {
                                            if (state is BookmarkUserDone) {
                                              user.isFavourite =
                                                  !user.isFavourite!;
                                            }
                                          },
                                          builder: (context, state) {
                                            return MoreIconButton(
                                              icon: user.isFavourite!
                                                  ? CupertinoIcons.bookmark_fill
                                                  : CupertinoIcons.bookmark,
                                              value: user.isFavourite!
                                                  ? S.current.unSave
                                                  : S.current.save,
                                              onTapIcon: () {
                                                _bookmarkUserCubit
                                                    .bookmarkUnBookmarkUser(
                                                        user.id!);
                                              },
                                            );
                                          }),
                                      BlocConsumer<
                                              SubscribeUserNotificationCubit,
                                              SubscribeUserNotificationState>(
                                          bloc: _subscribeUserNotificationCubit,
                                          listener: (context, state) {
                                            if (state
                                                is SubscribeUserNotificationDone) {
                                              user.isSubscribeToNotification =
                                                  !user
                                                      .isSubscribeToNotification;
                                            }
                                          },
                                          builder: (context, state) {
                                            return MoreIconButton(
                                              icon:
                                                  user.isSubscribeToNotification
                                                      ? CupertinoIcons.bell_fill
                                                      : CupertinoIcons.bell,
                                              value: S.current.notifications,
                                              onTapIcon: () {
                                                _subscribeUserNotificationCubit
                                                    .subscribeUnSubscribeUserNotification(
                                                        user.id!);
                                              },
                                            );
                                          }),
                                      ShareUserButton(
                                        withBorder: true,
                                        user: widget.user!,
                                        isOtherUser: true,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      MoreIconButton(
                                        icon: CupertinoIcons.slash_circle,
                                        value: S.current.block,
                                        onTapIcon: () {
                                          Navigator.of(context).pop();
                                          AppDialog.showConfirmationDialog(
                                            context: context,
                                            onConfirm: () => _blockUserCubit
                                                .blockUnBlockUser(
                                                    widget.user!.id!),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.more_vert),
                          );
                        }
                        return SizedBox();
                      }),
                if (!widget.isOther) ...{
                  if (!isKids)
                    BlocConsumer<AddEditPostCubit, AddEditPostState>(
                        listener: (context, state) {
                      if (state is AddPostDone) {
                        _myPostCubit.getMyPosts();
                      }
                    }, builder: (context, state) {
                      return IconButton(
                          onPressed: state is AddEditPostLoading
                              ? null
                              : () {
                                  Navigator.pushNamed(AppRouter.mainContext,
                                      AddEditPostScreen.routName);
                                },
                          icon: Icon(
                            IconlyLight.camera,
                            size: 27,
                          ));
                    }),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, BookmarkScreen.routName);
                    },
                    icon: Icon(Icons.bookmark_border),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(MenuScreen.routName);
                      },
                      icon: Icon(Icons.menu)),
                },
              ],
            ),
            body: BlocConsumer<BlockUserCubit, BlockUserState>(
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
                    AppDialog.closeAppDialog();
                    AppSnackBar(
                            context: context,
                            message: S.current.blockedSuccessfully)
                        .showSuccessSnackBar();
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  return BlocBuilder<ProfileCubit, ProfileState>(
                      bloc: _profileCubit,
                      builder: (context, state) {
                        if (state is ProfileLoading) {
                          return const CenteredCircularProgressIndicator();
                        }
                        if (state is ProfileLoaded) {
                          user = state.response;
                          return PullToRefresh(
                            onRefresh: () {
                              if (widget.isOther) {
                                _profileCubit.getUserProfile(widget.user!.id!);
                                _userPostCubit.getPostByUser(widget.user!.id!);
                              } else {
                                _profileCubit.getMyProfile(
                                    context.read<AppConfigCubit>());
                                _myPostCubit.getMyPosts();
                              }
                            },
                            child: ListView(
                              controller: scrollController,
                              children: [
                                ProfileHeaderWidget(
                                  isLoggedIn: isLoggedIn,
                                  isOther: widget.isOther,
                                  followUserCubit: _followUserCubit,
                                  user: user,
                                  onEditPressed: () => Navigator.of(context)
                                      .pushNamed(EditProfileScreen.routName)
                                      .then((value) {
                                    _profileCubit.getMyProfile(
                                        context.read<AppConfigCubit>());
                                  }),
                                ),

                                const SizedBox(height: 12),
                                // Categories
                                if (user.categoryList!.isNotEmpty) ...{
                                  ViewAllIconHeader(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      leadingText: S.current.menu,
                                      onNavigate: () {
                                        Navigator.of(AppRouter.mainContext)
                                            .pushNamed(CategoryScreen.routName,
                                                arguments: {
                                              "isMine":
                                                  widget.isOther ? false : true,
                                              "user": user,
                                              "categoryList": user.categoryList,
                                            });
                                      }),

                                  // Menu Grid view
                                  GridView.builder(
                                    itemCount: user.categoryList!.length,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 0.65,
                                    ),
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return CategoryWidget(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.dg, vertical: 10.dg),
                                        onTap: () {
                                          Navigator.of(AppRouter.mainContext)
                                              .pushNamed(
                                                  CategoryScreen.routName,
                                                  arguments: {
                                                "isMine": widget.isOther
                                                    ? false
                                                    : true,
                                                "selectedCategory":
                                                    user.categoryList![index],
                                                "user": user,
                                                "categoryList":
                                                    user.categoryList,
                                              });
                                        },
                                        category: user.categoryList![index],
                                      );
                                    },
                                  ),
                                },
                                SizedBox(height: 6.h),
                                if (widget.isOther) ...{
                                  BlocConsumer<UserPostCubit, UserPostState>(
                                      bloc: _userPostCubit,
                                      listener: (context, state) {
                                        if (state is UserPostListLoaded) {
                                          userPostPage =
                                              PaginationPage(currentPage: 2);
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state is UserPostListLoading) {
                                          return const ShimmerLoading();
                                        }
                                        if (state is UserPostListFailure) {
                                          return ErrorHandler(
                                                  exception: state.exception)
                                              .buildErrorWidget(
                                            context: context,
                                            retryCallback: () =>
                                                _userPostCubit.getPostByUser(
                                                    widget.user!.id!),
                                          );
                                        }
                                        if (state is UserPostListLoaded) {
                                          userPostList =
                                              state.response.postList!;

                                          return CustomPostsGrid(
                                            title: S.current.posts,
                                            postList: userPostList,
                                            onPostTapShowInList: true,
                                            postListViewLoadMoreBody:
                                                PostListViewLoadMoreBody(
                                              loadMoreFunctionName:
                                                  LoadMoreCubit
                                                      .loadMoreUserPostFunction,
                                              userId: widget.user!.id!,
                                            ),
                                            // onMore: () {},
                                          );
                                        }
                                        return Container();
                                      }),
                                } else ...{
                                  BlocConsumer<MyPostCubit, MyPostState>(
                                      bloc: _myPostCubit,
                                      listener: (context, state) {
                                        if (state is MyPostListLoaded) {
                                          myPostPage =
                                              PaginationPage(currentPage: 2);
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state is MyPostListLoading) {
                                          return const ShimmerLoading();
                                        }
                                        if (state is MyPostListFailure) {
                                          return ErrorHandler(
                                                  exception: state.exception)
                                              .buildErrorWidget(
                                            context: context,
                                            retryCallback: () =>
                                                _myPostCubit.getMyPosts(),
                                          );
                                        }
                                        if (state is MyPostListLoaded) {
                                          myPostList = state.response.postList!;
                                          return CustomPostsGrid(
                                            title: S.current.posts,
                                            postList: myPostList,
                                            onPostTapShowInList: true,
                                            postListViewLoadMoreBody:
                                                PostListViewLoadMoreBody(
                                              loadMoreFunctionName:
                                                  LoadMoreCubit
                                                      .loadMoreMyPostFunction,
                                            ),
                                          );
                                        }
                                        return Container();
                                      }),
                                },
                                BlocConsumer<LoadMoreCubit, LoadMoreState>(
                                    bloc: _loadMoreCubit,
                                    listener: (context, state) {
                                      if (state is LoadMoreFailure) {
                                        ErrorHandler(exception: state.exception)
                                            .handleError(context);
                                      }
                                      if (state is LoadMoreUserPostLoaded) {
                                        PostList temp = state.list;
                                        if (temp.postList!.isNotEmpty) {
                                          userPostPage.currentPage++;
                                          setState(() {
                                            userPostList.addAll(temp.postList!);
                                          });
                                        }
                                      }
                                      if (state is LoadMoreMyPostLoaded) {
                                        PostList temp = state.list;
                                        if (temp.postList!.isNotEmpty) {
                                          myPostPage.currentPage++;
                                          setState(() {
                                            myPostList.addAll(temp.postList!);
                                          });
                                        }
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is LoadMoreLoading) {
                                        return const CenteredCircularProgressIndicator();
                                      }
                                      return Container();
                                    }),
                              ],
                            ),
                          );
                        }
                        if (state is ProfileFailure) {
                          return ErrorHandler(exception: state.exception)
                              .buildErrorWidget(
                                  context: context,
                                  retryCallback: () =>
                                      _profileCubit.getMyProfile(
                                          context.read<AppConfigCubit>()));
                        }
                        return Container();
                      });
                }),
          );
  }
}
