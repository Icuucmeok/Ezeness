import 'package:ezeness/data/models/hashtag/hashtag.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/logic/cubit/comment/comment_cubit.dart';
import 'package:ezeness/logic/cubit/hashtag/hashtag_cubit.dart';
import 'package:ezeness/logic/cubit/mention/mention_cubit.dart';
import 'package:ezeness/presentation/router/app_router.dart';
import 'package:ezeness/presentation/screens/post/hashtag_post_screen.dart';
import 'package:ezeness/presentation/utils/app_toast.dart';
import 'package:ezeness/presentation/utils/future_sender.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/comment/comment.dart';
import '../../data/models/user/user.dart';
import '../../generated/l10n.dart';
import '../../logic/cubit/app_config/app_config_cubit.dart';
import '../screens/profile/profile/profile_screen.dart';
import 'circle_avatar_icon_widget.dart';
import 'common/common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({
    Key? key,
    required this.commentCubit,
    required this.comment,
  }) : super(key: key);

  final CommentModel comment;
  final CommentCubit commentCubit;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    User user = context.read<AppConfigCubit>().getUser();
    return BlocConsumer<CommentCubit, CommentState>(
        bloc: widget.commentCubit,
        listener: (context, state) {
          if (state is CommentLikeUnLike) {
            if (widget.comment.id.toString() == state.response) {
              widget.comment.isLike = !widget.comment.isLike;
              if (widget.comment.isLike) {
                widget.comment.likes++;
              } else {
                widget.comment.likes--;
              }
            }
          }
          if (state is CommentReplyDeleted) {
            widget.comment.replies.removeWhere(
                (element) => element.id.toString() == state.response);
          }
        },
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 12.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(AppRouter.mainContext)
                        .pushNamed(ProfileScreen.routName, arguments: {
                      "isOther": true,
                      "user": widget.comment.user
                    });
                  },
                  child: Row(
                    children: [
                      CircleAvatarIconWidget(
                        userProfileImage: widget.comment.user!.image.toString(),
                        size: 40,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${widget.comment.user?.name}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                        ),
                                  ),
                                ),
                                Text(
                                  "${widget.comment.createAt ?? ""}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontSize: 10.sp,
                                        color: AppColors.greyTextColor,
                                      ),
                                ),
                                SizedBox(width: 15),
                              ],
                            ),
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                child: _buildCommentText(
                                  context,
                                  widget.comment.comment.toString(),
                                )),
                          ],
                        ),
                      ),
                      IconTextVerticalButton(
                        icon: widget.comment.isLike
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 20.sp,
                        iconColor: AppColors.greyDark,
                        verticalPadding: 0,
                        number: "${widget.comment.likes}",
                        onTapIcon: () {
                          widget.commentCubit
                              .likeUnLikeComment(widget.comment.id!);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    children: [
                      if (widget.comment.user!.id == user.id) ...{
                        GestureDetector(
                            onTap: () {
                              if (widget.comment.parentCommentId == null) {
                                widget.commentCubit
                                    .deleteComment(widget.comment.id!);
                              } else {
                                widget.commentCubit
                                    .deleteReply(widget.comment.id!);
                              }
                            },
                            child: Text(S.current.delete,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: AppColors.greyDark))),
                        SizedBox(width: 20.w),
                      },
                      GestureDetector(
                          onTap: () {
                            widget.commentCubit
                                .setCommentToReply(widget.comment);
                          },
                          child: Text(S.current.reply,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppColors.greyDark))),
                    ],
                  ),
                ),
                if (widget.comment.replies.isNotEmpty)
                  Row(
                    children: [
                      SizedBox(width: 50),
                      widget.comment.showReplies
                          ? Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...widget.comment.replies
                                      .map((e) => CommentWidget(
                                          comment: e,
                                          commentCubit: widget.commentCubit))
                                      .toList(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.comment.showReplies = false;
                                      });
                                    },
                                    child: Text(S.current.hideReplies,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                color: AppColors.greyDark)),
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.comment.showReplies = true;
                                });
                              },
                              child: Text(
                                  S.current.viewReplies(
                                      widget.comment.replies.length),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: AppColors.greyDark)),
                            ),
                    ],
                  ),
              ],
            ),
          );
        });
  }

  Widget _buildCommentText(BuildContext context, String text) {
    if (text.isEmpty) return SizedBox.shrink();

    List<TextSpan> spans = [];

    final words = text.split(' ');
    for (var word in words) {
      if (word.startsWith('#')) {
        spans.add(
          TextSpan(
            text: word + ' ',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // On tap hashtag
                FutureSender.send<HashtagModel?>(
                  context,
                  future: () =>
                      context.read<HashtagCubit>().getHashtagByName(word),
                  onError: (e) {
                    AppToast(message: e.message).show();
                  },
                  onSuccess: (value) {
                    if (value == null) return;
                    Navigator.of(context)
                        .pushNamed(HashtagPostScreen.routName, arguments: {
                      "hashtag": PostHashtag(name: value.name, id: value.id),
                    });
                  },
                );
              },
          ),
        );
      } else if (word.startsWith('@')) {
        spans.add(
          TextSpan(
            text: word + ' ',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // On tap Mention
                FutureSender.send<User?>(
                  context,
                  future: () =>
                      context.read<MentionCubit>().getUserByName(word),
                  onError: (e) {
                    AppToast(message: e.message).show();
                  },
                  onSuccess: (value) {
                    if (value == null) return;
                    Navigator.of(AppRouter.mainContext).pushNamed(
                        ProfileScreen.routName,
                        arguments: {"isOther": true, "user": value});
                  },
                );
              },
          ),
        );
      } else {
        spans.add(TextSpan(
            text: word + ' ', style: Theme.of(context).textTheme.bodyMedium));
      }
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }
}
