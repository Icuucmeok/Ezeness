import 'package:ezeness/data/models/explore_response.dart';
import 'package:ezeness/presentation/screens/explore/widget/explore_banners.dart';
import 'package:ezeness/presentation/screens/explore/explore_section_post_screen.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/post_list_view_load_more_body.dart';
import '../../../data/utils/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../logic/cubit/explore_kids/explore_kids_cubit.dart';
import '../../../logic/cubit/loadMore/load_more_cubit.dart';
import '../../widgets/common/components/custom_posts_grid.dart';
import '../../widgets/pull_to_refresh.dart';
import 'widget/explore_categories.dart';

class ExploreKidsPage extends StatefulWidget {
  const ExploreKidsPage({Key? key}) : super(key: key);

  @override
  State<ExploreKidsPage> createState() => _ExploreKidsPageState();
}


class _ExploreKidsPageState extends State<ExploreKidsPage>  with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  late ExploreKidsCubit _exploreKidsCubit;
  ScrollController scrollController=ScrollController();
  late  ExploreResponse response;
  @override
  void initState() {
    _exploreKidsCubit = context.read<ExploreKidsCubit>();
    _exploreKidsCubit.getExploreKidsResponse();
    super.initState();
  }
  reSetScrollController(){
    scrollController=ScrollController();
    context.read<AppConfigCubit>().seExploreScreenGoUp((){
      if(scrollController.hasClients){
        scrollController.animateTo(0,curve: Curves.easeIn, duration: Duration(milliseconds: 500));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  BlocConsumer<ExploreKidsCubit, ExploreKidsState>(
        bloc: _exploreKidsCubit,
        listener: (context, state) {
          if(state is ExploreKidsLoaded){
            response=state.response;
            reSetScrollController();
          }
        },
        builder: (context, state) {
          if(state is ExploreKidsLoading){
            return const CenteredCircularProgressIndicator();
          }
          if(state is ExploreKidsFailure){
              return ErrorHandler(exception: state.exception).buildErrorWidget(
                context: context,
                retryCallback:()=> _exploreKidsCubit.getExploreKidsResponse(),
              );
            }
          if(state is ExploreKidsLoaded){
            return PullToRefresh(
              onRefresh: () {
                _exploreKidsCubit.getExploreKidsResponse();
              },
              child: ListView(
                controller: scrollController,
                children: [
                  if(response.banners.isNotEmpty)
                    ExploreBanners(response.banners),
                  ExploreCategories(
                    postType: Constants.postUpKey,
                    categoryList: response.categories,
                    isKids: true,
                  ),

                  if(response.forYouPostList.isNotEmpty)
                    CustomPostsGrid(
                      title: S.current.forYou.toUpperCase(),
                      postList: response.forYouPostList,
                      onPostTapShowInList: true,
                      postListViewLoadMoreBody: PostListViewLoadMoreBody(
                        loadMoreFunctionName: LoadMoreCubit.loadMoreExploreSectionFunction,
                        sectionKey: Constants.forYouSectionKey,
                        tabType: Constants.kidsTabKey,
                      ),
                      onMore: (){
                        Navigator.of(context).pushNamed(ExploreSectionPostScreen.routName,
                            arguments: {
                              "sectionKey":Constants.forYouSectionKey,
                              "tabType":Constants.kidsTabKey,
                            });
                      },
                    ),

                  if(response.shopsPostList.isNotEmpty)
                    CustomPostsGrid(
                      title: S.current.shop.toUpperCase(),
                      postList: response.shopsPostList,
                      onPostTapShowInList: true,
                      postListViewLoadMoreBody: PostListViewLoadMoreBody(
                        loadMoreFunctionName: LoadMoreCubit.loadMoreExploreSectionFunction,
                        sectionKey: Constants.shopSectionKey,
                        tabType: Constants.kidsTabKey,
                      ),
                      onMore: (){
                        Navigator.of(context).pushNamed(ExploreSectionPostScreen.routName,
                            arguments: {
                              "sectionKey":Constants.shopSectionKey,
                              "tabType":Constants.kidsTabKey,
                            });
                      },
                    ),


                  if(response.socialPostList.isNotEmpty)
                    CustomPostsGrid(
                      title: S.current.social.toUpperCase(),
                      postList: response.socialPostList,
                      onPostTapShowInList: true,
                      postListViewLoadMoreBody: PostListViewLoadMoreBody(
                        loadMoreFunctionName: LoadMoreCubit.loadMoreExploreSectionFunction,
                        sectionKey: Constants.socialSectionKey,
                        tabType: Constants.kidsTabKey,
                      ),
                      onMore: (){
                        Navigator.of(context).pushNamed(ExploreSectionPostScreen.routName,
                            arguments: {
                              "sectionKey":Constants.socialSectionKey,
                              "tabType":Constants.kidsTabKey,
                            });
                      },
                    ),
                  if(response.liftUpPostList.isNotEmpty)
                    CustomPostsGrid(
                      title: S.current.liftup.toUpperCase(),
                      postList: response.liftUpPostList,
                      onPostTapShowInList: true,
                      postListViewLoadMoreBody: PostListViewLoadMoreBody(
                        loadMoreFunctionName: LoadMoreCubit.loadMoreExploreSectionFunction,
                        sectionKey: Constants.liftUpSectionKey,
                        tabType: Constants.kidsTabKey,
                      ),
                      onMore: (){
                        Navigator.of(context).pushNamed(ExploreSectionPostScreen.routName,
                            arguments: {
                              "sectionKey":Constants.liftUpSectionKey,
                              "tabType":Constants.kidsTabKey,
                            });
                      },
                    ),

                  if(response.vipPostList.isNotEmpty)
                    CustomPostsGrid(
                      title: "VIP".toUpperCase(),
                      postList: response.vipPostList,
                      onPostTapShowInList: true,
                      postListViewLoadMoreBody: PostListViewLoadMoreBody(
                        loadMoreFunctionName: LoadMoreCubit.loadMoreExploreSectionFunction,
                        sectionKey: Constants.vipSectionKey,
                        tabType: Constants.kidsTabKey,
                      ),
                      onMore: (){
                        Navigator.of(context).pushNamed(ExploreSectionPostScreen.routName,
                            arguments: {
                              "sectionKey":Constants.vipSectionKey,
                              "tabType":Constants.kidsTabKey,
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
                        tabType: Constants.kidsTabKey,
                      ),
                      onMore: () {
                        Navigator.of(context).pushNamed(
                            ExploreSectionPostScreen.routName,
                            arguments: {
                              "sectionKey": Constants.savedSectionKey,
                              "tabType": Constants.kidsTabKey,
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
                        tabType: Constants.kidsTabKey,
                      ),
                      onMore: () {
                        Navigator.of(context).pushNamed(
                            ExploreSectionPostScreen.routName,
                            arguments: {
                              "sectionKey": Constants.islamSectionKey,
                              "tabType": Constants.kidsTabKey,
                            });
                      },
                    ),

                ],
              ),
            );
          }
          return SizedBox();
        }
    );
  }
}
