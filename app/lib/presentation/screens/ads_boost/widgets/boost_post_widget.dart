import 'package:cached_network_image/cached_network_image.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/presentation/widgets/common/components/diagonal_cut_discount_widget.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

class BoostPostComponent extends StatelessWidget {
  const BoostPostComponent({
    Key? key,
    required this.post,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  final Post post;
  final bool Function(Post post) isSelected;
  final void Function(Post post) onSelect;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Row(
              children: [
                Spacer(),

                // ID
                Text(
                  "    Item #${post.id}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColors.darkGrey),
                ),
                Spacer(),

                // Select post button
                GestureDetector(
                  onTap: () => onSelect(post),
                  child: Container(
                    width: 25,
                    height: 25,
                    margin: EdgeInsetsDirectional.only(end: size.height * 0.02),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      boxShadow: [Helpers.boxShadow(context)],
                      color: isSelected(post)
                          ? AppColors.green
                          : AppColors.whiteColor,
                    ),
                    child: Center(
                      child: !isSelected(post)
                          ? Icon(
                              Icons.add,
                              color: AppColors.blackColor,
                              size: 20,
                            )
                          : Icon(
                              Icons.check,
                              color: AppColors.whiteColor,
                              size: 20,
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 150,
            child: Row(
              children: [
                // Post image
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        // Network image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: CachedNetworkImage(
                            width: double.infinity,
                            height: double.infinity,
                            imageUrl: post.postMediaList!.first.type == "video"
                                ? post.postMediaList!.first.thumbnail ??
                                    Constants.defaultVideoThumbnail
                                : post.postMediaList!.first.path!,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => SizedBox(
                                child: Image.asset(
                                    Assets.assetsImagesPlaceholder,
                                    fit: BoxFit.fill)),
                            placeholder: (context, url) =>
                                const ShimmerLoading(),
                          ),
                        ),

                        // views
                        Positioned(
                          bottom: 3,
                          left: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.visibility,
                                color: AppColors.whiteColor.withOpacity(0.7),
                              ),
                              SizedBox(width: 3),
                              Text(
                                intl.NumberFormat.compact(locale: "en_US")
                                    .format(post.views),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textDirection: TextDirection.ltr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                  height: 1.h,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.whiteColor.withOpacity(0.7),
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

                        // distance
                        if (post.distance != null &&
                            post.postType == Constants.postUpKey)
                          Positioned(
                            bottom: 6,
                            right: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${post.distance?.ceil()} ${S.current.km}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                    height: 1.h,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        AppColors.whiteColor.withOpacity(0.7),
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
                          )
                      ],
                    ),
                  ),
                ),

                // Complete widget
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(),
                        // description
                        Text(
                          post.description ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontSize: 15.sp),
                          maxLines: 2,
                        ),
                        Text(
                          post.category?.name ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontSize: 15.sp),
                          maxLines: 2,
                        ),
                        if(post.postType!=Constants.postUpKey)
                        Text(
                          "${S.current.price}: ${post.sellPrice?.toString() ?? ""} ${S.current.aed}",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontSize: 15.sp),
                          maxLines: 2,
                        ),
                        if (post.discount != null)
                          Row(
                            children: [
                              Spacer(),
                              DiagonalCutDiscount(
                                percentage: post.discount ?? 0,
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
