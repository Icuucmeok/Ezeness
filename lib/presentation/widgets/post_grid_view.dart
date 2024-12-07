import 'package:ezeness/logic/cubit/add_edit_post/add_edit_post_cubit.dart';
import 'package:ezeness/presentation/screens/post/post_list_view_screen.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:collection/collection.dart';
import '../../data/models/post/post.dart';
import '../../data/models/post_list_view_load_more_body.dart';
import '../../generated/l10n.dart';
import '../screens/post/post_view_screen.dart';
import 'post_widget.dart';

class PostGridView extends StatelessWidget {
  final List<Post> postList;
  final bool isScroll;
  final bool onPostTapShowInList;
  final double minSpacing;
  final PostListViewLoadMoreBody? postListViewLoadMoreBody;
  const PostGridView(this.postList,
      {this.postListViewLoadMoreBody,
      required this.onPostTapShowInList,
      this.isScroll = false,
      this.minSpacing = 1,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return postList.isEmpty
        ? EmptyCard(withIcon: false, massage: S.current.NoPostsToDisplay)
        : BlocConsumer<AddEditPostCubit, AddEditPostState>(
            listener: (context, state) {
            if (state is EditPostDone) {
              Post? tempPost = postList.firstWhereOrNull(
                  (element) => element.id == state.response.id);
              if (tempPost != null) {
                tempPost.editWith(state.response);
              }
            }
          }, builder: (context, state) {
            return ResponsiveGridList(
                scroll: isScroll,
                shrinkWrap: true,
                desiredItemWidth: Helpers.isTab(context)
                    ? MediaQuery.of(context).size.width / 5.2
                    : MediaQuery.of(context).size.width / 3.2,
                minSpacing: minSpacing,
                children: postList
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: PostWidget(
                          post: e,
                          onTap: () {
                            if (onPostTapShowInList) {
                              Navigator.of(context).pushNamed(
                                  PostListViewScreen.routName,
                                  arguments: {
                                    "postList": postList,
                                    "index": postList.indexOf(e),
                                    "postListViewLoadMoreBody":
                                        postListViewLoadMoreBody
                                  });
                            } else {
                              Navigator.of(context).pushNamed(
                                  PostViewScreen.routName,
                                  arguments: {"post": e});
                            }
                          },
                        ),
                      ),
                    )
                    .toList());
          });
  }
}
