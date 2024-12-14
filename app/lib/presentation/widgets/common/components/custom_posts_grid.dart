import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/data/models/post_list_view_load_more_body.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/add_edit_post/add_edit_post_cubit.dart';
import 'package:ezeness/presentation/screens/post/post_list_view_screen.dart';
import 'package:ezeness/presentation/screens/post/post_view_screen.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/presentation/widgets/post_widget.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:collection/collection.dart';

class CustomPostsGrid extends StatelessWidget {
  const CustomPostsGrid({
    Key? key,
    required this.postList,
    required this.onPostTapShowInList,
    this.postListViewLoadMoreBody,
    this.title,
    this.onMore,
  }) : super(key: key);

  final List<Post> postList;
  final bool onPostTapShowInList;

  final PostListViewLoadMoreBody? postListViewLoadMoreBody;

  final String? title;
  final VoidCallback? onMore;

  int get length {
    int value = postList.length;
    if (title != null) value = value + 1;
    if (onMore != null) value = value + 1;
    return value;
  }

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
            },
            builder: (context, state) {
              return MasonryGridView.count(
                crossAxisCount: Helpers.isTab(context) ? 4 : 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 5.5, vertical: 5),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: length,
                itemBuilder: (context, index) {
                  if (title != null && index == 0) {
                    return Container(
                      margin: const EdgeInsets.all(5.0),
                      width: double.infinity,
                      height: Helpers.isTab(context) ? 80 : 90,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.blackText
                            : AppColors.greyTextColor,
                        borderRadius: BorderRadiusDirectional.horizontal(
                          start: Radius.circular(15),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          title!,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: 16.5.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    );
                  }
                  if (onMore != null && index == length - 1) {
                    return GestureDetector(
                      onTap: onMore,
                      child: Container(
                        margin: const EdgeInsets.all(5.0),
                        width: double.infinity,
                        height: Helpers.isTab(context) ? 80 : 90,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.blackText
                              : AppColors.grey,
                          borderRadius: BorderRadiusDirectional.horizontal(
                            end: Radius.circular(15),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            S.current.seeMore,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? AppColors.whiteColor
                                          : AppColors.darkGrey,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(7),
                    child: PostWidget(
                      isBigCard: true,
                      post:
                          title != null ? postList[index - 1] : postList[index],
                      onTap: () {
                        if (onPostTapShowInList) {
                          Navigator.of(context).pushNamed(
                              PostListViewScreen.routName,
                              arguments: {
                                "postList": postList,
                                "index": title != null
                                    ? index - 1
                                    : index, //  postList.indexOf(e),
                                "postListViewLoadMoreBody":
                                    postListViewLoadMoreBody
                              });
                        } else {
                          Navigator.of(context).pushNamed(
                            PostViewScreen.routName,
                            arguments: {
                              "post": title != null
                                  ? postList[index - 1]
                                  : postList[index],
                            },
                          );
                        }
                      },
                    ),
                  );
                },
              );
            },
          );
  }
}
