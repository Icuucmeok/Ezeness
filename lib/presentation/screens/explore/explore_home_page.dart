import 'package:ezeness/data/models/explore_response.dart';
import 'package:ezeness/presentation/screens/explore/widget/explore_banners.dart';
import 'package:ezeness/presentation/screens/explore/explore_section_post_screen.dart';
import 'package:ezeness/presentation/screens/explore/widget/explore_users.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/post_list_view_load_more_body.dart';
import '../../../data/utils/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../logic/cubit/explore_home/explore_home_cubit.dart';
import '../../../logic/cubit/loadMore/load_more_cubit.dart';
import '../../widgets/common/components/custom_posts_grid.dart';
import '../../widgets/pull_to_refresh.dart';
import 'widget/explore_categories.dart';

class ExploreHomePage extends StatefulWidget {
  const ExploreHomePage({Key? key}) : super(key: key);

  @override
  State<ExploreHomePage> createState() => _ExploreHomePageState();
}

class _ExploreHomePageState extends State<ExploreHomePage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  late ExploreHomeCubit _exploreHomeCubit;
  ScrollController scrollController = ScrollController();
  late ExploreResponse response;
  @override
  void initState() {
    _exploreHomeCubit = context.read<ExploreHomeCubit>();
    _exploreHomeCubit.getExploreHomeResponse();
    super.initState();
  }

  reSetScrollController() {
    scrollController = ScrollController();
    context.read<AppConfigCubit>().seExploreScreenGoUp(() {
      if (scrollController.hasClients) {
        scrollController.animateTo(0,
            curve: Curves.easeIn, duration: Duration(milliseconds: 500));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<ExploreHomeCubit, ExploreHomeState>(
        bloc: _exploreHomeCubit,
        listener: (context, state) {
          if (state is ExploreHomeLoaded) {
            response = state.response;
            reSetScrollController();
          }
        },
        builder: (context, state) {
          if (state is ExploreHomeLoading) {
            return const CenteredCircularProgressIndicator();
          }
          if (state is ExploreHomeFailure) {
            return ErrorHandler(exception: state.exception).buildErrorWidget(
              context: context,
              retryCallback: () => _exploreHomeCubit.getExploreHomeResponse(),
            );
          }
          if(state is ExploreHomeLoaded){
            return PullToRefresh(
              onRefresh: () {
                _exploreHomeCubit.getExploreHomeResponse();
              },
              child: ListView(
                controller: scrollController,
                children: [
                  if (response.banners.isNotEmpty)
                    ExploreBanners(response.banners),
                  ExploreCategories(
                      postType: Constants.postUpKey,
                      categoryList: response.categories),
                  if (response.forYouPostList.isNotEmpty)
                    CustomPostsGrid(
                      title: S.current.forYou.toUpperCase(),
                      postList: response.forYouPostList,
                      onPostTapShowInList: true,
                      postListViewLoadMoreBody: PostListViewLoadMoreBody(
                          loadMoreFunctionName: LoadMoreCubit.loadMoreExploreSectionFunction,
                          sectionKey: Constants.forYouSectionKey,
                        tabType: Constants.homeTabKey,
                      ),
                      onMore: () {
                        Navigator.of(context).pushNamed(
                            ExploreSectionPostScreen.routName,
                            arguments: {
                              "sectionKey": Constants.forYouSectionKey,
                              "tabType": Constants.homeTabKey,
                            });
                      },
                    ),
                  if (response.connectsList.isNotEmpty) ...{
                    SizedBox(height: 20),
                    ExploreUsers(usersList: response.connectsList),
                    SizedBox(height: 20),
                  },
                  if (response.shopsPostList.isNotEmpty)
                    CustomPostsGrid(
                      title: S.current.shop.toUpperCase(),
                      postList: response.shopsPostList,
                      onPostTapShowInList: true,
                      postListViewLoadMoreBody: PostListViewLoadMoreBody(
                        loadMoreFunctionName: LoadMoreCubit.loadMoreExploreSectionFunction,
                        sectionKey: Constants.shopSectionKey,
                        tabType: Constants.homeTabKey,
                      ),
                      onMore: () {
                        Navigator.of(context).pushNamed(
                            ExploreSectionPostScreen.routName,
                            arguments: {
                              "sectionKey": Constants.shopSectionKey,
                              "tabType": Constants.homeTabKey,
                            });
                      },
                    ),
                  if (response.socialPostList.isNotEmpty)
                    CustomPostsGrid(
                      title: S.current.social.toUpperCase(),
                      postList: response.socialPostList,
                      onPostTapShowInList: true,
                      postListViewLoadMoreBody: PostListViewLoadMoreBody(
                        loadMoreFunctionName: LoadMoreCubit.loadMoreExploreSectionFunction,
                        sectionKey: Constants.socialSectionKey,
                        tabType: Constants.homeTabKey,
                      ),
                      onMore: () {
                        Navigator.of(context).pushNamed(
                            ExploreSectionPostScreen.routName,
                            arguments: {
                              "sectionKey": Constants.socialSectionKey,
                              "tabType": Constants.homeTabKey,
                            });
                      },
                    ),
                  if (response.liftUpPostList.isNotEmpty)
                    CustomPostsGrid(
                      title: S.current.liftup.toUpperCase(),
                      postList: response.liftUpPostList,
                      onPostTapShowInList: true,
                      postListViewLoadMoreBody: PostListViewLoadMoreBody(
                        loadMoreFunctionName: LoadMoreCubit.loadMoreExploreSectionFunction,
                        sectionKey: Constants.liftUpSectionKey,
                        tabType: Constants.homeTabKey,
                      ),
                      onMore: () {
                        Navigator.of(context).pushNamed(
                            ExploreSectionPostScreen.routName,
                            arguments: {
                              "sectionKey": Constants.liftUpSectionKey,
                              "tabType": Constants.homeTabKey,
                            });
                      },
                    ),
                  if (response.vipPostList.isNotEmpty)
                    CustomPostsGrid(
                      title: "VIP".toUpperCase(),
                      postList: response.vipPostList,
                      onPostTapShowInList: true,
                      postListViewLoadMoreBody: PostListViewLoadMoreBody(
                        loadMoreFunctionName: LoadMoreCubit.loadMoreExploreSectionFunction,
                        sectionKey: Constants.vipSectionKey,
                        tabType: Constants.homeTabKey,
                      ),
                      onMore: () {
                        Navigator.of(context).pushNamed(
                            ExploreSectionPostScreen.routName,
                            arguments: {
                              "sectionKey": Constants.vipSectionKey,
                              "tabType": Constants.homeTabKey,
                            });
                      },
                    ),
                  if (response.savedPostList.isNotEmpty)
                    CustomPostsGrid(
                      title: S.current.saved.toUpperCase(),
                      postList: response.savedPostList,
                      onPostTapShowInList: true,
                      postListViewLoadMoreBody: PostListViewLoadMoreBody(
                        loadMoreFunctionName: LoadMoreCubit.loadMoreExploreSectionFunction,
                        sectionKey: Constants.savedSectionKey,
                        tabType: Constants.homeTabKey,
                      ),
                      onMore: () {
                        Navigator.of(context).pushNamed(
                            ExploreSectionPostScreen.routName,
                            arguments: {
                              "sectionKey": Constants.savedSectionKey,
                              "tabType": Constants.homeTabKey,
                            });
                      },
                    ),
                  if (response.islamPostList.isNotEmpty)
                    CustomPostsGrid(
                      title: S.current.inspire.toUpperCase(),
                      postList: response.islamPostList,
                      onPostTapShowInList: true,
                      postListViewLoadMoreBody: PostListViewLoadMoreBody(
                        loadMoreFunctionName: LoadMoreCubit.loadMoreExploreSectionFunction,
                        sectionKey: Constants.islamSectionKey,
                        tabType: Constants.homeTabKey,
                      ),
                      onMore: () {
                        Navigator.of(context).pushNamed(
                            ExploreSectionPostScreen.routName,
                            arguments: {
                              "sectionKey": Constants.islamSectionKey,
                              "tabType": Constants.homeTabKey,
                            });
                      },
                    ),
                ],
              ),
            );
          }
          return SizedBox();

        });
  }
}
