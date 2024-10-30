import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/pagination_page.dart';
import '../../../data/models/post/post.dart';
import '../../../data/models/post/post_list.dart';
import '../../../data/utils/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/explore_post/explore_post_cubit.dart';
import '../../../logic/cubit/loadMore/load_more_cubit.dart';
import '../../../res/app_res.dart';
import '../../widgets/common/common.dart';
import '../../widgets/common/components/custom_posts_grid.dart';

class ExploreSectionPostScreen extends StatefulWidget {
  static const String routName = 'explore_section_post_screen';

  final String sectionKey;
  final String tabType;
  const ExploreSectionPostScreen({required this.sectionKey,required this.tabType,Key? key})
      : super(key: key);

  @override
  State<ExploreSectionPostScreen> createState() => _ExploreSectionPostScreenState();
}

class _ExploreSectionPostScreenState extends State<ExploreSectionPostScreen> {
  late ExplorePostCubit _explorePostCubit;
  late LoadMoreCubit _loadMoreCubit;
  List<Post> postList = [];
  ScrollController scrollController=ScrollController();
  PaginationPage postPage = PaginationPage(currentPage: 2);
  @override
  void initState() {
    _explorePostCubit = context.read<ExplorePostCubit>();
    _loadMoreCubit = context.read<LoadMoreCubit>();
    _explorePostCubit.getExploreSectionPostList(sectionKey:widget.sectionKey,tabType: widget.tabType);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset &&
          _loadMoreCubit.state is! LoadMoreLoading) {
        _loadMoreCubit.loadMoreExploreSectionPost(sectionKey:widget.sectionKey,tabType: widget.tabType,postPage);
      }
    });
    super.initState();
  }
  String getTitle() {
    switch (widget.sectionKey) {
      case Constants.forYouSectionKey:
        return S.current.forYou.toUpperCase();

      case Constants.trendingSectionKey:
        return S.current.trending.toUpperCase();

      case Constants.shopSectionKey:
        return S.current.shop.toUpperCase();

      case Constants.socialSectionKey:
        return S.current.social.toUpperCase();

      case Constants.liftUpSectionKey:
        return S.current.liftup.toUpperCase();

      case Constants.savedSectionKey:
        return S.current.saved.toUpperCase();

      case Constants.islamSectionKey:
        return S.current.inspire.toUpperCase();

      case Constants.bestSellersSectionKey:
        return S.current.bestSeller.toUpperCase();

      case Constants.vipSectionKey:
        return "VIP".toUpperCase();

      default:
        return S.current.posts;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.posts.toUpperCase())),
      body: BlocConsumer<ExplorePostCubit, ExplorePostState>(
          bloc: _explorePostCubit,
          listener: (context, state) {
            if (state is ExploreSectionPostListLoaded) {
              postList=state.response.postList!;
            }
          },
          builder: (context, state) {
            if (state is ExploreSectionPostListLoading) {
              return const CenteredCircularProgressIndicator();
            }
            if (state is ExploreSectionPostListFailure) {
              return ErrorHandler(exception: state.exception)
                  .buildErrorWidget(
                context: context,
                retryCallback: () => _explorePostCubit.getExploreSectionPostList(sectionKey:widget.sectionKey,tabType: widget.tabType),
              );
            }
            return ListView(
              controller: scrollController,
              children: [
                CustomPostsGrid(
                  title: getTitle(),
                    postList:postList,
                    onPostTapShowInList: false,
                ),
                BlocConsumer<LoadMoreCubit, LoadMoreState>(
                    bloc: _loadMoreCubit,
                    listener: (context, state) {
                      if (state is LoadMoreFailure) {
                        ErrorHandler(exception: state.exception)
                            .handleError(context);
                      }
                      if (state is LoadMoreSectionPostExploreLoaded) {
                        PostList temp = state.list;
                        if (temp.postList!.isNotEmpty) {
                          postPage.currentPage++;
                          setState(() {
                            postList.addAll(temp.postList!);
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
            );
          }),
    );
  }
}
