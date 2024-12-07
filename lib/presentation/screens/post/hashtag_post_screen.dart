import 'package:ezeness/presentation/widgets/common/components/custom_posts_grid.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/pagination_page.dart';
import '../../../data/models/post/post_list.dart';
import '../../../data/models/post_list_view_load_more_body.dart';
import '../../../data/utils/error_handler.dart';
import '../../../logic/cubit/loadMore/load_more_cubit.dart';
import '../../../logic/cubit/post/post_cubit.dart';
import '../../widgets/common/common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HashtagPostScreen extends StatefulWidget {
  final PostHashtag hashtag;
  const HashtagPostScreen({required this.hashtag, Key? key}) : super(key: key);
  static const String routName = 'hashtag_post_screen';
  @override
  State<HashtagPostScreen> createState() => _HashtagPostScreenState();
}

class _HashtagPostScreenState extends State<HashtagPostScreen> {
  late PostCubit _postCubit;
  late LoadMoreCubit _loadMoreCubit;
  PaginationPage page = PaginationPage(currentPage: 2);
  late List<Post> list;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    _postCubit = context.read<PostCubit>();
    _loadMoreCubit = context.read<LoadMoreCubit>();
    _postCubit.getPosts(hashtagId: widget.hashtag.id);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        _loadMoreCubit.loadMoreHashTagsPost(page, hashtagId: widget.hashtag.id);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<PostCubit, PostState>(
          bloc: _postCubit,
          listener: (context, state) {
            if (state is PostListLoaded) {
              list = state.response.postList!;
              page = PaginationPage(currentPage: 2);
            }
          },
          builder: (context, state) {
            if (state is PostListLoading) {
              return const CenteredCircularProgressIndicator();
            }
            if (state is PostListFailure) {
              return ErrorHandler(exception: state.exception).buildErrorWidget(
                  context: context,
                  retryCallback: () =>
                      _postCubit.getPosts(hashtagId: widget.hashtag.id));
            }
            if (state is PostListLoaded) {
              return Column(
                children: [
                  Container(
                    child: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkColor
                              : AppColors.whiteColor,
                      radius: 50,
                      child: Text("#",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 50,
                                    color: AppColors.primaryColor,
                                  )),
                    ),
                  ),
                  Text("#${widget.hashtag.name}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 20.sp.sp,
                            color: AppColors.primaryColor,
                          )),
                  SizedBox(height: 5.h),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        CustomPostsGrid(
                            postList: list,
                            onPostTapShowInList: true,
                            postListViewLoadMoreBody: PostListViewLoadMoreBody(
                                loadMoreFunctionName:
                                    LoadMoreCubit.loadMoreHashTagsPostFunction,
                                hashtagId: widget.hashtag.id)),
                        BlocConsumer<LoadMoreCubit, LoadMoreState>(
                            bloc: _loadMoreCubit,
                            listener: (context, state) {
                              if (state is LoadMoreFailure) {
                                ErrorHandler(exception: state.exception)
                                    .handleError(context);
                              }
                              if (state is LoadMorePostByHashTagsLoaded) {
                                PostList temp = state.list;
                                if (temp.postList!.isNotEmpty) {
                                  page.currentPage++;
                                  setState(() {
                                    list.addAll(temp.postList!);
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
                  ),
                ],
              );
            }
            return Container();
          }),
    );
  }
}
