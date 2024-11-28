import 'package:cached_network_image/cached_network_image.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/presentation/widgets/post_widget_button.dart';
import 'package:flutter/material.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/presentation/screens/post/post_view_screen.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../../data/models/user/user.dart';
import '../../logic/cubit/app_config/app_config_cubit.dart';
import '../router/app_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common/components/diagonal_cut_discount_widget.dart';

class PostWidget extends StatefulWidget {
  final bool withDetails;
  final Post post;
  final VoidCallback? onTapRemove;
  final VoidCallback? onTap;
  final isBigCard;

  const PostWidget({
    Key? key,
    required this.post,
    this.onTap,
    this.onTapRemove,
    this.withDetails = true,
    this.isBigCard = false,
  }) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late double postWidth;
  late double postHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User loggedInUser = context.read<AppConfigCubit>().getUser();
    if (widget.isBigCard) {
      postWidth = MediaQuery.of(context).size.width / 2.1;
      postHeight = 190.h;
    } else {
      postWidth = Helpers.getPostWidgetWidth(context);
      postHeight = 120.h;
    }
    return GestureDetector(
      onTap: widget.onTap ??
          () => Navigator.of(AppRouter.mainContext).pushNamed(
              PostViewScreen.routName,
              arguments: {"post": widget.post}),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).scaffoldBackgroundColor
                : AppColors.greyCard,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: postHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CachedNetworkImage(
                        height: postHeight,
                        width: postWidth,
                        imageUrl:
                            widget.post.postMediaList!.first.type == "video"
                                ? widget.post.postMediaList!.first.thumbnail ??
                                    Constants.defaultVideoThumbnail
                                : widget.post.postMediaList!.first.path!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => SizedBox(
                            height: postHeight,
                            child: Image.asset(Assets.assetsImagesPlaceholder,
                                fit: BoxFit.fill)),
                        placeholder: (context, url) => const ShimmerLoading(),
                      ),
                      if (widget.withDetails &&
                          widget.post.discount != null &&
                          widget.post.discount != 0)
                        Positioned(
                          bottom: -5,
                          right: 0,
                          child: DiagonalCutDiscount(
                              percentage: widget.post.discount!),
                        ),
                      Positioned(
                          bottom: 0,
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Container(
                              width: postWidth - 8,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(4.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          IconlyBold.show,
                                          size: 16,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black87,
                                              offset: Offset(1, 1),
                                              blurRadius: 1.0,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          intl.NumberFormat.compact(
                                                  locale: "en_US")
                                              .format(widget.post.views),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textDirection: TextDirection.ltr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                            height: 1.h,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 11.sp,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black87,
                                                offset: Offset(1, 1),
                                                blurRadius: 1.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (widget.post.distance != null &&
                                      widget.post.postType ==
                                          Constants.postUpKey)
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                end: 10),
                                        child: Text(
                                          "${widget.post.distance?.ceil()} km",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                            height: 1.h,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 11.sp,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black87,
                                                offset: Offset(1, 1),
                                                blurRadius: 1.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )),
                      if (widget.post.postMediaList!.first.type == "video")
                        Positioned(
                            left: 5.w,
                            top: 5.h,
                            child: Icon(Icons.play_arrow,
                                size: 20.sp, color: Colors.white)),
                      if (widget.post.isVip != null &&
                          widget.post.isVip == 1 &&
                          loggedInUser.type == Constants.specialInviteKey)
                        Positioned(
                            right: 5,
                            top: 5,
                            child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(Constants.vipImage),
                                radius: 10.w)),
                    ],
                  ),
                ),
              ),
              if (widget.post.postType != Constants.postUpKey &&
                  widget.withDetails)
                Container(
                  width: postWidth,
                  padding:
                      EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        // height: 45,
                        child: Text(widget.post.description.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textDirection: Helpers.isRtlText(
                                    widget.post.description.toString())
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      height: 1.2,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                    )),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                                '${Helpers.getCurrencyName(widget.post.priceCurrency.toString())} ${Helpers.numberFormatter(widget.post.sellPrice!)} ',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontSize: 12.sp,
                                    )),
                          ),
                          const SizedBox(width: 4),
                          PostWidgetButton(post: widget.post),
                        ],
                      ),
                      if (widget.post.distance != null) ...{
                        const SizedBox(height: 6),
                        Text(
                          "${widget.post.distance?.ceil()} km",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.7),
                                    fontSize: 10.sp,
                                  ),
                        ),
                      },
                    ],
                  ),
                ),
              if (widget.onTapRemove != null)
                IconButton(
                    onPressed: widget.onTapRemove,
                    icon: Icon(Icons.delete, color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
