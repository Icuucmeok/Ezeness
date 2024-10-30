import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/presentation/widgets/post_slider_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import '../../../data/models/pagination_page.dart';
import '../../../data/models/post/post_list.dart';
import '../../../data/utils/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/add_edit_post/add_edit_post_cubit.dart';
import '../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../logic/cubit/loadMore/load_more_cubit.dart';
import '../../../logic/cubit/post/post_cubit.dart';
import '../../widgets/common/common.dart';

class PostViewScreen extends StatefulWidget {
  final Post post;
  const PostViewScreen({required this.post, Key? key}) : super(key: key);
  static const String routName = 'post_view_screen';
  @override
  State<PostViewScreen> createState() => _PostViewScreenState();
}

class _PostViewScreenState extends State<PostViewScreen> {
  late PostCubit _postCubit;
  late LoadMoreCubit _loadMoreCubit;
  late AppConfigCubit _appConfigCubit;
  late Post post;
  List<Post> postList = [];
  PaginationPage page = PaginationPage(currentPage: 1);
  PageController pageController = PageController();
  int _currentPage = 0;
  int postRandomCode=0;
  @override
  void initState() {
    _loadMoreCubit = context.read<LoadMoreCubit>();
    _postCubit = context.read<PostCubit>();
    _appConfigCubit = context.read<AppConfigCubit>();
    _appConfigCubit.setUser(_appConfigCubit.getUser().copyWith(isDarkBottomNavigation: true));
    if (widget.post.description == null) {
      _postCubit.getPost(widget.post.id!);
    } else {
      _postCubit.emitPost(widget.post);
    }
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
      body: BlocConsumer<PostCubit, PostState>(
          bloc: _postCubit,
          listener: (context, state) {
            if (state is PostLoaded) {
              post = state.response;
              page = PaginationPage(currentPage: 1);
              postList.insert(0, post);
              postRandomCode=Helpers.getRandomNumber();
              _loadMoreCubit.loadMorePostViewScreen(page,
                  postType: post.postType!, isKids: post.isKids!,randomCode: postRandomCode);
            }
          },
          builder: (context, state) {
            if (state is PostLoading) {
              return const CenteredCircularProgressIndicator();
            }
            if (state is PostFailure) {
              return ErrorHandler(exception: state.exception).buildErrorWidget(
                textStyle: TextStyle(color: Colors.white),
                  context: context,
                  retryCallback: () => _postCubit.getPost(widget.post.id!));
            }
            if (state is PostLoaded) {
              return BlocConsumer<AddEditPostCubit, AddEditPostState>(
                  listener: (context, state) {
                if (state is EditPostDone) {
                  Post? tempPost = postList.firstWhereOrNull(
                      (element) => element.id == state.response.id);
                  if (tempPost != null) {
                    tempPost.editWith(state.response);
                  }
                }
              }, builder: (context, state) {
                return BlocConsumer<LoadMoreCubit, LoadMoreState>(
                    bloc: _loadMoreCubit,
                    listener: (context, state) {
                      if (state is LoadMoreFailure) {
                        ErrorHandler(exception: state.exception)
                            .handleError(context);
                      }
                      if (state is LoadMorePostViewScreenLoaded) {
                        PostList temp = state.list;
                        if (temp.postList!.isNotEmpty) {
                          temp.postList!
                              .removeWhere((element) => element.id == post.id);
                          page.currentPage++;
                          setState(() {
                            postList.addAll(temp.postList!);
                          });
                        }
                      }
                    },
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: PageView.builder(
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                            if (index == postList.length) {
                              _loadMoreCubit.loadMorePostViewScreen(page,
                                  postType: post.postType!, isKids: post.isKids!,randomCode: postRandomCode);
                            }
                          },
                          controller: pageController,
                          scrollDirection: Axis.vertical,
                          itemCount: postList.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index < _currentPage - 1 ||
                                index > _currentPage + 1) {
                              return Container();
                            }
                            if (index == postList.length) {
                              return Builder(builder: (context) {
                                return BlocBuilder<LoadMoreCubit, LoadMoreState>(
                                    bloc: _loadMoreCubit,
                                    builder: (context, state) {
                                      if (state is LoadMoreLoading) {
                                        return const CenteredCircularProgressIndicator();
                                      }
                                      return Center(
                                          child:
                                              Text(S.current.NoPostsToDisplay,style:TextStyle(color: Colors.white)));
                                    });
                              });
                            }
                            return PostSliderWidget(post: postList[index]);
                          },
                        ),
                      );
                    });
              });
            }
            return Container();
          }),
    );
  }
}
