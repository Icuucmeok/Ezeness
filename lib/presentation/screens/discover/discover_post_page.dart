import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/pagination_page.dart';
import '../../../data/models/post/post_list.dart';
import '../../../data/utils/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/discover_post/discover_post_cubit.dart';
import '../../../logic/cubit/loadMore/load_more_cubit.dart';
import '../../widgets/post_slider_widget.dart';
import '../../widgets/pull_to_refresh.dart';

class DiscoverPostPage extends StatefulWidget {
  final String tabType;
  final PageController pageController;
  const DiscoverPostPage(this.tabType, this.pageController, {Key? key})
      : super(key: key);

  @override
  State<DiscoverPostPage> createState() => _DiscoverPostPageState();
}

class _DiscoverPostPageState extends State<DiscoverPostPage>
    with AutomaticKeepAliveClientMixin {
  late DiscoverPostCubit _discoverPostCubit;
  late LoadMoreCubit _loadMoreCubit;
  List<Post> homeList = [];
  List<Post> shopList = [];
  List<Post> socialList = [];
  List<Post> kidsList = [];

  PaginationPage homePage = PaginationPage(currentPage: 2);
  PaginationPage shopPage = PaginationPage(currentPage: 2);
  PaginationPage socialPage = PaginationPage(currentPage: 2);
  PaginationPage kidsPage = PaginationPage(currentPage: 2);
  int _currentPage = 0;
  @override
  void initState() {
    _discoverPostCubit = context.read<DiscoverPostCubit>();
    _loadMoreCubit = context.read<LoadMoreCubit>();
    if (widget.tabType == Constants.homeTabKey) {
      _discoverPostCubit.getDiscoverHomeList();
    }
    if (widget.tabType == Constants.shopTabKey) {
      _discoverPostCubit.getDiscoverShopList();
    }
    if (widget.tabType == Constants.socialTabKey) {
      _discoverPostCubit.getDiscoverSocialList();
    }
    if (widget.tabType == Constants.kidsTabKey) {
      _discoverPostCubit.getDiscoverKidsList();
    }
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<DiscoverPostCubit, DiscoverPostState>(
          bloc: _discoverPostCubit,
          listener: (context, state) {
            if (state is DiscoverHomeListLoaded) {
              homeList = state.response.postList!;
              homePage = PaginationPage(currentPage: 2);
            }
            if (state is DiscoverShopListLoaded) {
              shopList = state.response.postList!;
              shopPage = PaginationPage(currentPage: 2);
            }
            if (state is DiscoverSocialListLoaded) {
              socialList = state.response.postList!;
              socialPage = PaginationPage(currentPage: 2);
            }
            if (state is DiscoverKidsListLoaded) {
              kidsList = state.response.postList!;
              kidsPage = PaginationPage(currentPage: 2);
            }
          },
          builder: (context, state) {
            if (widget.tabType == Constants.homeTabKey) {
              if (state is DiscoverHomeListLoading) {
                return const CenteredCircularProgressIndicator();
              }
              if (state is DiscoverHomeListFailure) {
                return ErrorHandler(exception: state.exception)
                    .buildErrorWidget(
                  textStyle: TextStyle(color: Colors.white),
                  context: context,
                  retryCallback: () =>
                      _discoverPostCubit.getDiscoverHomeList(),
                );
              }
              return PullToRefresh(
                onRefresh: () {
                  _discoverPostCubit.getDiscoverHomeList();
                },
                child: homeList.isEmpty
                    ? EmptyCard(
                        withIcon: false, massage: S.current.NoPostsToDisplay)
                    : RefreshIndicator(
                        onRefresh: () async {
                          _discoverPostCubit.getDiscoverHomeList();
                        },
                        child: PageView.builder(
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                            if (index == homeList.length) {
                              _loadMoreCubit.loadMoreDiscoverPost(homePage,
                                  tabType: Constants.homeTabKey);
                            }
                          },
                          controller: widget.pageController,
                          scrollDirection: Axis.vertical,
                          itemCount: homeList.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index < _currentPage - 1 ||
                                index > _currentPage + 1) {
                              return Container();
                            }
                            if (index == homeList.length) {
                              return BlocConsumer<LoadMoreCubit, LoadMoreState>(
                                  bloc: _loadMoreCubit,
                                  listener: (context, state) {
                                    if (state is LoadMoreFailure) {
                                      ErrorHandler(exception: state.exception)
                                          .handleError(context);
                                    }
                                    if (state is LoadMoreHomeDiscoverLoaded) {
                                      PostList temp = state.list;
                                      if (temp.postList!.isNotEmpty) {
                                        if (widget.tabType ==
                                            Constants.homeTabKey) {
                                          homePage.currentPage++;
                                          setState(() {
                                            homeList.addAll(temp.postList!);
                                          });
                                        }
                                      }
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is LoadMoreLoading) {
                                      return const CenteredCircularProgressIndicator();
                                    }
                                    return Center(
                                        child:
                                            Text(S.current.NoPostsToDisplay));
                                  });
                            }
                            return PostSliderWidget(post: homeList[index],isFromDiscover: true);
                          },
                        ),
                      ),
              );
            } else if (widget.tabType == Constants.shopTabKey) {
              if (state is DiscoverShopListLoading) {
                return const CenteredCircularProgressIndicator();
              }
              if (state is DiscoverShopListFailure) {
                return ErrorHandler(exception: state.exception)
                    .buildErrorWidget(
                  textStyle: TextStyle(color: Colors.white),
                  context: context,
                  retryCallback: () =>
                      _discoverPostCubit.getDiscoverShopList(),
                );
              }
              return PullToRefresh(
                onRefresh: () {
                  _discoverPostCubit.getDiscoverShopList();
                },
                child: shopList.isEmpty
                    ? EmptyCard(
                        withIcon: false, massage: S.current.NoPostsToDisplay)
                    : RefreshIndicator(
                        onRefresh: () async {
                          _discoverPostCubit.getDiscoverShopList();
                        },
                        child: PageView.builder(
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                            if (index == shopList.length) {
                              _loadMoreCubit.loadMoreDiscoverPost(shopPage,
                                  tabType: Constants.shopTabKey);
                            }
                          },
                          controller: widget.pageController,
                          scrollDirection: Axis.vertical,
                          itemCount: shopList.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index < _currentPage - 1 ||
                                index > _currentPage + 1) {
                              return Container();
                            }
                            if (index == shopList.length) {
                              return BlocConsumer<LoadMoreCubit, LoadMoreState>(
                                  bloc: _loadMoreCubit,
                                  listener: (context, state) {
                                    if (state is LoadMoreFailure) {
                                      ErrorHandler(exception: state.exception)
                                          .handleError(context);
                                    }
                                    if (state is LoadMoreShopDiscoverLoaded) {
                                      PostList temp = state.list;
                                      if (temp.postList!.isNotEmpty) {
                                        if (widget.tabType ==
                                            Constants.shopTabKey) {
                                          shopPage.currentPage++;
                                          setState(() {
                                            shopList.addAll(temp.postList!);
                                          });
                                        }
                                      }
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is LoadMoreLoading) {
                                      return const CenteredCircularProgressIndicator();
                                    }
                                    return Center(
                                        child:
                                            Text(S.current.NoPostsToDisplay));
                                  });
                            }
                            return PostSliderWidget(post: shopList[index],isFromDiscover: true);
                          },
                        ),
                      ),
              );
            } else if (widget.tabType == Constants.socialTabKey) {
              if (state is DiscoverSocialListLoading) {
                return const CenteredCircularProgressIndicator();
              }
              if (state is DiscoverSocialListFailure) {
                return ErrorHandler(exception: state.exception)
                    .buildErrorWidget(
                  textStyle: TextStyle(color: Colors.white),
                  context: context,
                  retryCallback: () =>
                      _discoverPostCubit.getDiscoverSocialList(),
                );
              }
              return PullToRefresh(
                onRefresh: () {
                  _discoverPostCubit.getDiscoverSocialList();
                },
                child: socialList.isEmpty
                    ? EmptyCard(
                        withIcon: false, massage: S.current.NoPostsToDisplay)
                    : RefreshIndicator(
                        onRefresh: () async {
                          _discoverPostCubit.getDiscoverSocialList();
                        },
                        child: PageView.builder(
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                            if (index == socialList.length) {
                              _loadMoreCubit.loadMoreDiscoverPost(socialPage,
                                  tabType: Constants.socialTabKey);
                            }
                          },
                          controller: widget.pageController,
                          scrollDirection: Axis.vertical,
                          itemCount: socialList.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index < _currentPage - 1 ||
                                index > _currentPage + 1) {
                              return Container();
                            }
                            if (index == socialList.length) {
                              return BlocConsumer<LoadMoreCubit, LoadMoreState>(
                                  bloc: _loadMoreCubit,
                                  listener: (context, state) {
                                    if (state is LoadMoreFailure) {
                                      ErrorHandler(exception: state.exception)
                                          .handleError(context);
                                    }
                                    if (state is LoadMoreSocialDiscoverLoaded) {
                                      PostList temp = state.list;
                                      if (temp.postList!.isNotEmpty) {
                                        if (widget.tabType ==
                                            Constants.socialTabKey) {
                                          socialPage.currentPage++;
                                          setState(() {
                                            socialList.addAll(temp.postList!);
                                          });
                                        }
                                      }
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is LoadMoreLoading) {
                                      return const CenteredCircularProgressIndicator();
                                    }
                                    return Center(
                                        child:
                                            Text(S.current.NoPostsToDisplay));
                                  });
                            }
                            return PostSliderWidget(post: socialList[index],isFromDiscover: true);
                          },
                        ),
                      ),
              );
            } else {
              if (state is DiscoverKidsListLoading) {
                return const CenteredCircularProgressIndicator();
              }
              if (state is DiscoverKidsListFailure) {
                return ErrorHandler(exception: state.exception)
                    .buildErrorWidget(
                  textStyle: TextStyle(color: Colors.white),
                  context: context,
                  retryCallback: () =>
                      _discoverPostCubit.getDiscoverKidsList(),
                );
              }
              return PullToRefresh(
                onRefresh: () {
                  _discoverPostCubit.getDiscoverKidsList();
                },
                child: kidsList.isEmpty
                    ? EmptyCard(
                        withIcon: false, massage: S.current.NoPostsToDisplay)
                    : RefreshIndicator(
                        onRefresh: () async {
                          _discoverPostCubit.getDiscoverKidsList();
                        },
                        child: PageView.builder(
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                            if (index == kidsList.length) {
                              _loadMoreCubit.loadMoreDiscoverPost(kidsPage,
                                  tabType: Constants.kidsTabKey);
                            }
                          },
                          controller: widget.pageController,
                          scrollDirection: Axis.vertical,
                          itemCount: kidsList.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index < _currentPage - 1 ||
                                index > _currentPage + 1) {
                              return Container();
                            }
                            if (index == kidsList.length) {
                              return BlocConsumer<LoadMoreCubit, LoadMoreState>(
                                  bloc: _loadMoreCubit,
                                  listener: (context, state) {
                                    if (state is LoadMoreFailure) {
                                      ErrorHandler(exception: state.exception)
                                          .handleError(context);
                                    }
                                    if (state is LoadMoreKidsDiscoverLoaded) {
                                      PostList temp = state.list;
                                      if (temp.postList!.isNotEmpty) {
                                        if (widget.tabType ==
                                            Constants.kidsTabKey) {
                                          kidsPage.currentPage++;
                                          setState(() {
                                            kidsList.addAll(temp.postList!);
                                          });
                                        }
                                      }
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is LoadMoreLoading) {
                                      return const CenteredCircularProgressIndicator();
                                    }
                                    return Center(
                                        child:
                                            Text(S.current.NoPostsToDisplay));
                                  });
                            }
                            return PostSliderWidget(post: kidsList[index],isFromDiscover: true);
                          },
                        ),
                      ),
              );
            }
          }),
    );
  }
}
