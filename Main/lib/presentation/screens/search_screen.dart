import 'package:ezeness/presentation/widgets/common/components/custom_posts_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/pagination_page.dart';
import '../../data/models/search_response.dart';
import '../../data/utils/error_handler.dart';
import '../../generated/l10n.dart';
import '../../logic/cubit/loadMore/load_more_cubit.dart';
import '../../logic/cubit/search/search_cubit.dart';
import '../widgets/common/common.dart';
import '../widgets/profile_grid_view.dart';

class SearchScreen extends StatefulWidget {
  static const String routName = 'search_screen';

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final searchDeBouncer = DeBouncer();
  late SearchCubit _searchCubit;
  late LoadMoreCubit _loadMoreCubit;
  late SearchResponse searchResponse;
  PaginationPage page = PaginationPage(currentPage: 2);
  ScrollController postsScrollController = ScrollController();
  ScrollController usersScrollController = ScrollController();
  ScrollController productsScrollController = ScrollController();
  TextEditingController searchText = TextEditingController();
  late final TabController _tabController;

  @override
  void initState() {
    _loadMoreCubit = context.read<LoadMoreCubit>();
    _tabController = TabController(length: 3, vsync: this);
    _searchCubit = context.read<SearchCubit>();

    postsScrollController.addListener(() {
      if (postsScrollController.position.maxScrollExtent ==
              postsScrollController.offset &&
          _loadMoreCubit.state is! LoadMoreLoading) {
        _loadMoreCubit.loadMoreSearchResponse(page, search: searchText.text);
      }
    });

    usersScrollController.addListener(() {
      if (usersScrollController.position.maxScrollExtent ==
              usersScrollController.offset &&
          _loadMoreCubit.state is! LoadMoreLoading) {
        _loadMoreCubit.loadMoreSearchResponse(page, search: searchText.text);
      }
    });

    productsScrollController.addListener(() {
      if (productsScrollController.position.maxScrollExtent ==
              productsScrollController.offset &&
          _loadMoreCubit.state is! LoadMoreLoading) {
        _loadMoreCubit.loadMoreSearchResponse(page, search: searchText.text);
      }
    });

    super.initState();
  }

  void performSearch({int sec = 1}) {
    if (searchText.text.length >= 2) {
      searchDeBouncer.run(sec, () {
        if (searchText.text.length >= 2) _searchCubit.search(searchText.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchEditTextField(
            controller: searchText,
            onChange: (t) {
              performSearch();
            }),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: TabBar(
              controller: _tabController,
              splashBorderRadius: BorderRadius.circular(20),
              isScrollable: false,
              tabs: [
                Tab(
                  text: S.current.products.toUpperCase(),
                ),
                Tab(
                  text: S.current.social.toUpperCase(),
                ),
                Tab(
                  text: S.current.profiles.toUpperCase(),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocConsumer<SearchCubit, SearchState>(
          bloc: _searchCubit,
          listener: (context, state) {
            if (state is SearchResponseLoaded) {
              searchResponse = state.response;
              page = PaginationPage(currentPage: 2);
            }
          },
          builder: (context, state) {
            if (state is SearchLoading) {
              return const CenteredCircularProgressIndicator();
            }
            if (state is SearchFailure) {
              return ErrorHandler(exception: state.exception).buildErrorWidget(
                context: context,
                retryCallback: () => _searchCubit.search(searchText.text),
              );
            }
            if (state is SearchResponseLoaded) {
              return TabBarView(controller: _tabController, children: [
                searchResponse.productsList.isEmpty
                    ? const EmptyCard(withIcon: false)
                    : ListView(
                        controller: productsScrollController,
                        children: [
                          CustomPostsGrid(
                              postList: searchResponse.productsList,
                              onPostTapShowInList: true),
                          BlocConsumer<LoadMoreCubit, LoadMoreState>(
                              bloc: _loadMoreCubit,
                              listener: (context, state) {
                                if (state is LoadMoreFailure) {
                                  ErrorHandler(exception: state.exception)
                                      .handleError(context);
                                }
                                if (state is LoadMoreSearchResponseLoaded) {
                                  SearchResponse temp = state.response;
                                  if (temp.postList.isNotEmpty ||
                                      temp.userList.isNotEmpty ||
                                      temp.productsList.isNotEmpty) {
                                    page.currentPage++;
                                    setState(() {
                                      searchResponse.postList
                                          .addAll(temp.postList);
                                      searchResponse.userList
                                          .addAll(temp.userList);
                                      searchResponse.productsList
                                          .addAll(temp.productsList);
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
                searchResponse.postList.isEmpty
                    ? const EmptyCard(withIcon: false)
                    : ListView(
                        controller: postsScrollController,
                        children: [
                          CustomPostsGrid(
                              postList: searchResponse.postList,
                              onPostTapShowInList: true),
                          BlocConsumer<LoadMoreCubit, LoadMoreState>(
                              bloc: _loadMoreCubit,
                              listener: (context, state) {
                                if (state is LoadMoreFailure) {
                                  ErrorHandler(exception: state.exception)
                                      .handleError(context);
                                }
                                if (state is LoadMoreSearchResponseLoaded) {
                                  SearchResponse temp = state.response;
                                  if (temp.postList.isNotEmpty ||
                                      temp.userList.isNotEmpty ||
                                      temp.productsList.isNotEmpty) {
                                    page.currentPage++;
                                    setState(() {
                                      searchResponse.postList
                                          .addAll(temp.postList);
                                      searchResponse.userList
                                          .addAll(temp.userList);
                                      searchResponse.productsList
                                          .addAll(temp.productsList);
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
                searchResponse.userList.isEmpty
                    ? const EmptyCard(withIcon: false)
                    : ListView(
                        controller: usersScrollController,
                        children: [
                          ProfileGridView(searchResponse.userList,
                              withFollowButton: true),
                          BlocConsumer<LoadMoreCubit, LoadMoreState>(
                              bloc: _loadMoreCubit,
                              listener: (context, state) {
                                if (state is LoadMoreFailure) {
                                  ErrorHandler(exception: state.exception)
                                      .handleError(context);
                                }
                                if (state is LoadMoreSearchResponseLoaded) {
                                  SearchResponse temp = state.response;
                                  if (temp.postList.isNotEmpty ||
                                      temp.userList.isNotEmpty ||
                                      temp.productsList.isNotEmpty) {
                                    page.currentPage++;
                                    setState(() {
                                      searchResponse.postList
                                          .addAll(temp.postList);
                                      searchResponse.userList
                                          .addAll(temp.userList);
                                      searchResponse.productsList
                                          .addAll(temp.productsList);
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
              ]);
            }
            return Container();
          }),
    );
  }
}
