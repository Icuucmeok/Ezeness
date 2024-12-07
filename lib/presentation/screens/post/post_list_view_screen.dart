import 'package:flutter/material.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/presentation/widgets/post_slider_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/pagination_page.dart';
import '../../../data/models/post/post_list.dart';
import '../../../data/models/post_list_view_load_more_body.dart';
import '../../../data/utils/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../logic/cubit/loadMore/load_more_cubit.dart';
import '../../widgets/common/common.dart';

class PostListViewScreen extends StatefulWidget {
  final List<Post> postList;
  final int index;
  final PostListViewLoadMoreBody? postListViewLoadMoreBody;
  const PostListViewScreen(
      {required this.postList,
      required this.index,
      this.postListViewLoadMoreBody,
      Key? key})
      : super(key: key);
  static const String routName = 'post_list_view_screen';
  @override
  State<PostListViewScreen> createState() => _PostListViewScreenState();
}

class _PostListViewScreenState extends State<PostListViewScreen> {
  late PageController pageController;
  late LoadMoreCubit _loadMoreCubit;
  late AppConfigCubit _appConfigCubit;
  PaginationPage page = PaginationPage(currentPage: 2);
  late List<Post> postList;
  int _currentPage = 0;
  @override
  void initState() {
    _appConfigCubit = context.read<AppConfigCubit>();
    _appConfigCubit.setUser(_appConfigCubit.getUser().copyWith(isDarkBottomNavigation: true));
    _currentPage = widget.index;
    postList = widget.postList;
    pageController = PageController(initialPage: widget.index);
    _loadMoreCubit = context.read<LoadMoreCubit>();
    super.initState();
  }
  @override
  void dispose() {
    _appConfigCubit.setUser(_appConfigCubit.getUser().copyWith(isDarkBottomNavigation: false));
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("POSTS",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.2), Colors.transparent],
              stops: [0.2, 1],
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: PageView.builder(
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
            if (index == postList.length) {
              if (widget.postListViewLoadMoreBody != null) {
                _loadMoreCubit.loadMorePostListViewScreen(
                    page, widget.postListViewLoadMoreBody!);
              }
            }
          },
          controller: pageController,
          scrollDirection: Axis.vertical,
          itemCount: postList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index < _currentPage - 1 || index > _currentPage + 1) {
              return Container();
            }
            if (index == postList.length) {
              return BlocConsumer<LoadMoreCubit, LoadMoreState>(
                  bloc: _loadMoreCubit,
                  listener: (context, state) {
                    if (state is LoadMoreFailure) {
                      ErrorHandler(exception: state.exception)
                          .handleError(context);
                    }
                    if (state is LoadMorePostListViewScreenLoaded) {
                      PostList temp = state.list;
                      if (temp.postList!.isNotEmpty) {
                        page.currentPage++;
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
                    return Center(child: Text(S.current.NoPostsToDisplay,style: TextStyle(color: Colors.white)));
                  });
            }
            return PostSliderWidget(post: postList[index]);
          },
        ),
      ),
    );
  }
}
