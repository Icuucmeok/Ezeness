import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/presentation/widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'circle_avatar_icon_widget.dart';

class PostHorizontalWidget extends StatefulWidget {
  final Post post;

  const PostHorizontalWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostHorizontalWidget> createState() => _PostHorizontalWidgetState();
}

class _PostHorizontalWidgetState extends State<PostHorizontalWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: Helpers.getPostWidgetWidth(context),
              child: PostWidget(post: widget.post,withDetails: false)),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatarIconWidget(
                      userProfileImage: widget.post.user!.image.toString(),
                      size: 50,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.post.user!.name}",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13.sp,
                                    ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "@${widget.post.user!.getUserName()}",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13.sp,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Text("${widget.post.description}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        shadows: [
                          Shadow(
                              color: Colors.black87,
                              offset: Offset(0, 0),
                              blurRadius: 0.0),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
