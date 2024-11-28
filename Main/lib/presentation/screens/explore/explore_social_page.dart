import 'package:ezeness/data/models/explore_response.dart';
import 'package:ezeness/presentation/screens/explore/explore_section_post_screen.dart';
import 'package:ezeness/presentation/screens/explore/widget/explore_users.dart';
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
import '../../../logic/cubit/explore_social/explore_social_cubit.dart';
import '../../../logic/cubit/explore_social_post/explore_social_post_cubit.dart';
import '../../../logic/cubit/loadMore/load_more_cubit.dart';
import '../../widgets/common/components/custom_posts_grid.dart';
import '../../widgets/pull_to_refresh.dart';

class ExploreSocialPage extends StatefulWidget {
  const ExploreSocialPage({Key? key}) : super(key: key);

  @override
  State<ExploreSocialPage> createState() => _ExploreSocialPageState();
}


class _ExploreSocialPageState extends State<ExploreSocialPage>  with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  late ExploreSocialCubit _exploreSocialCubit;
  late ExploreSocialPostCubit _exploreSocialPostCubit;
  late LoadMoreCubit _loadMoreCubit;
  ScrollController scrollController=ScrollController();
  PaginationPage socialPostPage = PaginationPage(currentPage: 2);
  List<Post> socialPostList = [];
  late  ExploreResponse response;
  @override
  void initState() {
    _exploreSocialCubit = context.read<ExploreSocialCubit>();
    _loadMoreCubit = context.read<LoadMoreCubit>();
    _exploreSocialPostCubit = context.read<ExploreSocialPostCubit>();
    _exploreSocialCubit.getExploreSocialResponse();
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
        _loadMoreCubit.getExploreTabPostList(tabType: Constants.socialTabKey,socialPostPage);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  BlocListener<ExploreSocialPostCubit, ExploreSocialPostState>(
      bloc: _exploreSocialPostCubit,
      listener: (context, state) {
        if(state is ExploreSocialPostListLoaded){
          socialPostList=state.response.postList!;
        }
      },
      child: BlocConsumer<ExploreSocialCubit, ExploreSocialState>(
          bloc: _exploreSocialCubit,
          listener: (context, state) {
            if(state is ExploreSocialLoaded){
              response=state.response;
              reSetScrollController();
              _exploreSocialPostCubit.getExploreSocialPostList();
            }
          },
          builder: (context, state) {
            if(state is ExploreSocialLoading){
              return const CenteredCircularProgressIndicator();
            }
            if(state is ExploreSocialFailure){
                return ErrorHandler(exception: state.exception).buildErrorWidget(
                  context: context,
                  retryCallback:()=> _exploreSocialCubit.getExploreSocialResponse(),
                );
              }
            if(state is ExploreSocialLoaded){
              return PullToRefresh(
                onRefresh: () {
                  _exploreSocialCubit.getExploreSocialResponse();
                },
                child: ListView(
                  controller: scrollController,
                  children: [

                    if(response.connectsList.isNotEmpty)
                      ExploreUsers(usersList: response.connectsList),

                    if(response.trendingPostList.isNotEmpty)
                      CustomPostsGrid(
                        title: S.current.trending.toUpperCase(),
                        postList: response.trendingPostList,
                        onPostTapShowInList: true,
                        postListViewLoadMoreBody: PostListViewLoadMoreBody(
                          loadMoreFunctionName: LoadMoreCubit.loadMoreExploreSectionFunction,
                          sectionKey: Constants.trendingSectionKey,
                          tabType: Constants.socialTabKey,
                        ),
                        onMore: (){
                          Navigator.of(context).pushNamed(ExploreSectionPostScreen.routName,
                              arguments: {
                                "sectionKey":Constants.trendingSectionKey,
                                "tabType":Constants.socialTabKey,
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
                          tabType: Constants.socialTabKey,
                        ),
                        onMore: (){
                          Navigator.of(context).pushNamed(ExploreSectionPostScreen.routName,
                              arguments: {
                                "sectionKey":Constants.liftUpSectionKey,
                                "tabType":Constants.socialTabKey,
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
                          tabType: Constants.socialTabKey,
                        ),
                        onMore: () {
                          Navigator.of(context).pushNamed(
                              ExploreSectionPostScreen.routName,
                              arguments: {
                                "sectionKey": Constants.islamSectionKey,
                                "tabType": Constants.socialTabKey,
                              });
                        },
                      ),

                    BlocBuilder<ExploreSocialPostCubit, ExploreSocialPostState>(
                        bloc: _exploreSocialPostCubit,
                        builder: (context, state) {
                          if(state is ExploreSocialPostListLoading){
                            return const ShimmerLoading();
                          }
                          if(state is ExploreSocialPostListFailure){
                            return ErrorHandler(exception: state.exception).buildErrorWidget(
                              context: context,
                              retryCallback:()=> _exploreSocialPostCubit.getExploreSocialPostList(),
                            );
                          }
                          if(state is ExploreSocialPostListLoaded){
                            return Column(
                              children: [
                                CustomPostsGrid(
                                  title: S.current.social.toUpperCase(),
                                  postList: socialPostList,
                                  onPostTapShowInList: false,
                                ),
                                BlocConsumer<LoadMoreCubit, LoadMoreState>(
                                    bloc: _loadMoreCubit,
                                    listener: (context, state) {
                                      if (state is LoadMoreFailure) {
                                        ErrorHandler(exception: state.exception)
                                            .handleError(context);
                                      }
                                      if (state is LoadMoreSocialPostExploreLoaded) {
                                        PostList temp = state.list;
                                        if (temp.postList!.isNotEmpty) {
                                          socialPostPage.currentPage++;
                                          setState(() {
                                            socialPostList.addAll(temp.postList!);
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
