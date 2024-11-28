import 'package:ezeness/data/models/explore_response.dart';
import 'package:ezeness/presentation/screens/explore/widget/explore_banners.dart';
import 'package:ezeness/presentation/screens/explore/explore_section_post_screen.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/pagination_page.dart';
import '../../../data/models/post/post.dart';
import '../../../data/models/post/post_list.dart';
import '../../../data/models/post_list_view_load_more_body.dart';
import '../../../data/utils/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../logic/cubit/explore_shop/explore_shop_cubit.dart';
import '../../../logic/cubit/explore_shop_post/explore_shop_post_cubit.dart';
import '../../../logic/cubit/loadMore/load_more_cubit.dart';
import '../../widgets/common/components/custom_posts_grid.dart';
import '../../widgets/pull_to_refresh.dart';
import 'widget/explore_categories.dart';

class ExploreShopPage extends StatefulWidget {
  const ExploreShopPage({Key? key}) : super(key: key);

  @override
  State<ExploreShopPage> createState() => _ExploreShopPageState();
}


class _ExploreShopPageState extends State<ExploreShopPage>  with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  late ExploreShopCubit _exploreShopCubit;
  late ExploreShopPostCubit _exploreShopPostCubit;
  late LoadMoreCubit _loadMoreCubit;
  ScrollController scrollController=ScrollController();
  PaginationPage shopPostPage = PaginationPage(currentPage: 2);
  List<Post> shopPostList = [];
  late ExploreResponse response;
  @override
  void initState() {
    _exploreShopCubit = context.read<ExploreShopCubit>();
    _loadMoreCubit = context.read<LoadMoreCubit>();
    _exploreShopPostCubit = context.read<ExploreShopPostCubit>();
    _exploreShopCubit.getExploreShopResponse();
    super.initState();
  }
  reSetScrollController(){
    scrollController=ScrollController();
    context.read<AppConfigCubit>().seExploreScreenGoUp((){
      if(scrollController.hasClients){
        scrollController.animateTo(0,curve: Curves.easeIn, duration: Duration(milliseconds: 500));
      }
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset &&
          _loadMoreCubit.state is! LoadMoreLoading) {
        _loadMoreCubit.getExploreTabPostList(tabType: Constants.shopTabKey,shopPostPage);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  BlocListener<ExploreShopPostCubit, ExploreShopPostState>(
      bloc: _exploreShopPostCubit,
      listener: (context, state) {
        if(state is ExploreShopPostListLoaded){
          shopPostList=state.response.postList!;
        }
      },
      child: BlocConsumer<ExploreShopCubit, ExploreShopState>(
          bloc: _exploreShopCubit,
          listener: (context, state) {
            if(state is ExploreShopLoaded){
              response=state.response;
              reSetScrollController();
              _exploreShopPostCubit.getExploreShopPostList();
            }
          },
          builder: (context, state) {
            if(state is ExploreShopLoading){
              return const CenteredCircularProgressIndicator();
            }
            if(state is ExploreShopFailure){
                return ErrorHandler(exception: state.exception).buildErrorWidget(
                  context: context,
                  retryCallback:()=> _exploreShopCubit.getExploreShopResponse(),
                );
              }
            if(state is ExploreShopLoaded){
              return PullToRefresh(
                onRefresh: () {
                  _exploreShopCubit.getExploreShopResponse();
                },
                child: ListView(
                  controller: scrollController,
                  children: [
                    ExploreCategories(
                        postType: Constants.callUpKey,
                        categoryList: response.categories),

                    if(response.forYouPostList.isNotEmpty)
                      CustomPostsGrid(
                        title: S.current.forYou.toUpperCase(),
                        postList: response.forYouPostList,
                        onPostTapShowInList: true,
                        postListViewLoadMoreBody: PostListViewLoadMoreBody(
                          loadMoreFunctionName: LoadMoreCubit.loadMoreExploreSectionFunction,
                          sectionKey: Constants.forYouSectionKey,
                          tabType: Constants.shopTabKey,
                        ),
                        onMore: (){
                          Navigator.of(context).pushNamed(ExploreSectionPostScreen.routName,
                              arguments: {
                                "sectionKey":Constants.forYouSectionKey,
                                "tabType":Constants.shopTabKey,
                              });
                        },
                      ),

                    if(response.banners.isNotEmpty)
                      ExploreBanners(response.banners),


                    if(response.liftUpPostList.isNotEmpty)
                      CustomPostsGrid(
                        title: S.current.liftup.toUpperCase(),
                        postList: response.liftUpPostList,
                        onPostTapShowInList: true,
                        postListViewLoadMoreBody: PostListViewLoadMoreBody(
                          loadMoreFunctionName: LoadMoreCubit.loadMoreExploreSectionFunction,
                          sectionKey: Constants.liftUpSectionKey,
                          tabType: Constants.shopTabKey,
                        ),
                        onMore: (){
                          Navigator.of(context).pushNamed(ExploreSectionPostScreen.routName,
                              arguments: {
                                "sectionKey":Constants.liftUpSectionKey,
                                "tabType":Constants.shopTabKey,
                              });
                        },
                      ),

                    if(response.bestSellersPostList.isNotEmpty)
                      CustomPostsGrid(
                        title: S.current.bestSeller.toUpperCase(),
                        postList: response.bestSellersPostList,
                        onPostTapShowInList: true,
                        postListViewLoadMoreBody: PostListViewLoadMoreBody(
                          loadMoreFunctionName: LoadMoreCubit.loadMoreExploreSectionFunction,
                          sectionKey: Constants.bestSellersSectionKey,
                          tabType: Constants.shopTabKey,
                        ),
                        onMore: (){
                          Navigator.of(context).pushNamed(ExploreSectionPostScreen.routName,
                              arguments: {
                                "sectionKey":Constants.bestSellersSectionKey,
                                "tabType":Constants.shopTabKey,
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
                          tabType: Constants.shopTabKey,
                        ),
                        onMore: () {
                          Navigator.of(context).pushNamed(
                              ExploreSectionPostScreen.routName,
                              arguments: {
                                "sectionKey": Constants.islamSectionKey,
                                "tabType": Constants.shopTabKey,
                              });
                        },
                      ),

                    BlocBuilder<ExploreShopPostCubit, ExploreShopPostState>(
                        bloc: _exploreShopPostCubit,
                        builder: (context, state) {
                          if(state is ExploreShopPostListLoading){
                            return const ShimmerLoading();
                          }
                          if(state is ExploreShopPostListFailure){
                            return ErrorHandler(exception: state.exception).buildErrorWidget(
                              context: context,
                              retryCallback:()=> _exploreShopPostCubit.getExploreShopPostList(),
                            );
                          }
                          if(state is ExploreShopPostListLoaded){
                            return Column(
                              children: [
                                CustomPostsGrid(
                                  title: S.current.shop.toUpperCase(),
                                  postList: shopPostList,
                                  onPostTapShowInList: false,
                                ),
                                BlocConsumer<LoadMoreCubit, LoadMoreState>(
                                    bloc: _loadMoreCubit,
                                    listener: (context, state) {
                                      if (state is LoadMoreFailure) {
                                        ErrorHandler(exception: state.exception)
                                            .handleError(context);
                                      }
                                      if (state is LoadMoreShopPostExploreLoaded) {
                                        PostList temp = state.list;
                                        if (temp.postList!.isNotEmpty) {
                                          shopPostPage.currentPage++;
                                          setState(() {
                                            shopPostList.addAll(temp.postList!);
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
                          }
                          return SizedBox();
                        }
                    ),


                  ],
                ),
              );
            }
            return SizedBox();

          }
      ),
    );
  }
}
