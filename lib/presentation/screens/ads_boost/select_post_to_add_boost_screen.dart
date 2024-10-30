import 'package:ezeness/data/models/pagination_page.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/data/models/post/post_list.dart';
import 'package:ezeness/data/utils/error_handler.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/loadMore/load_more_cubit.dart';
import 'package:ezeness/logic/cubit/my_post/my_post_cubit.dart';
import 'package:ezeness/presentation/router/app_router.dart';
import 'package:ezeness/presentation/screens/ads_boost/banner/banner_plans_screen.dart';
import 'package:ezeness/presentation/screens/ads_boost/post/post_plans_screen.dart';
import 'package:ezeness/presentation/screens/ads_boost/widgets/boost_post_widget.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectPostToAddBoostScreen extends StatefulWidget {
  static const String routName = 'select_post_to_add_post';

  const SelectPostToAddBoostScreen({
    Key? key,
    required this.isBanner,
  }) : super(key: key);
  final bool isBanner;

  @override
  State<SelectPostToAddBoostScreen> createState() =>
      _SelectPostToAddBoostScreenState();
}

class _SelectPostToAddBoostScreenState
    extends State<SelectPostToAddBoostScreen> {
  final TextEditingController controller = TextEditingController();
  late MyPostCubit _myPostCubit;
  late LoadMoreCubit _loadMoreCubit;

  ScrollController scrollController = ScrollController();
  PaginationPage myPostPage = PaginationPage(currentPage: 2);
  List<Post> myPostList = [];

  Post? selectedPost;

  @override
  void initState() {
    _myPostCubit = context.read<MyPostCubit>();
    _loadMoreCubit = context.read<LoadMoreCubit>();

    _myPostCubit.getMyPosts(
        withLiftUp: 0,
        search: controller.text.isEmpty ? null : controller.text);

    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent ==
                scrollController.offset &&
            _loadMoreCubit.state is! LoadMoreLoading) {
          _loadMoreCubit.loadMoreMyPost(
            myPostPage,
            search: controller.text.isEmpty ? null : controller.text,
          );
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: SearchEditTextField(
          onChange: (_) {
            _myPostCubit.getMyPosts(
              withLiftUp: 0,
              search: controller.text.isEmpty ? null : controller.text,
            );
          },
          controller: controller,
          label: S.current.searchPost,
        ),
      ),
      body: Column(
        children: [
          // View My Post
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              S.current.searchAndSelectProduct,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.darkGrey,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
              child: ListView(
            controller: scrollController,
            children: [
              // Main screen Cubit
              BlocConsumer<MyPostCubit, MyPostState>(
                  bloc: _myPostCubit,
                  listener: (context, state) {
                    if (state is MyPostListLoaded) {
                      myPostPage = PaginationPage(currentPage: 2);
                    }
                  },
                  builder: (context, state) {
                    if (state is MyPostListLoading) {
                      return SizedBox(
                          height: size.height * 0.5,
                          child: const CenteredCircularProgressIndicator());
                    }
                    if (state is MyPostListFailure) {
                      return SizedBox(
                        height: size.height * 0.5,
                        child: ErrorHandler(exception: state.exception)
                            .buildErrorWidget(
                          context: context,
                          retryCallback: () => _myPostCubit.getMyPosts(
                            withLiftUp: 0,
                            search: controller.text.isEmpty
                                ? null
                                : controller.text,
                          ),
                        ),
                      );
                    }
                    if (state is MyPostListLoaded) {
                      myPostList = state.response.postList!;
                      if (myPostList.isEmpty) {
                        return SizedBox(
                          height: 300,
                          child: Center(
                            child: Text(
                              S.current.noBusinessPost,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontSize: 17.sp),
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 15),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => BoostPostComponent(
                          post: myPostList[index],
                          onSelect: (post) {
                            setState(() {
                              if (selectedPost?.id == post.id) {
                                selectedPost = null;
                                return;
                              }
                              selectedPost = post;
                            });
                          },
                          isSelected: (post) => selectedPost?.id == post.id,
                        ),
                        itemCount: myPostList.length,
                      );
                    }
                    return Container();
                  }),

              // Pagination Cubit
              BlocConsumer<LoadMoreCubit, LoadMoreState>(
                  bloc: _loadMoreCubit,
                  listener: (context, state) {
                    if (state is LoadMoreFailure) {
                      ErrorHandler(exception: state.exception)
                          .handleError(context);
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
          )),

          // Next button
          CustomElevatedButton(
            backgroundColor:
                selectedPost == null ? AppColors.grey : AppColors.primaryColor,
            withBorderRadius: true,
            onPressed: selectedPost == null
                ? null
                : () {
                    if (widget.isBanner) {
                      Navigator.of(AppRouter.mainContext).pushNamed(
                        BannerPlansScreen.routName,
                        arguments: {"post": selectedPost},
                      );
                    } else {
                      Navigator.of(AppRouter.mainContext).pushNamed(
                        PostPlansScreen.routName,
                        arguments: {"post": selectedPost},
                      );
                    }
                  },
            child: Text(
              S.current.next,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.whiteColor,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
