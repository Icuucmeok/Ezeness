import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/banner/banner.dart';
import '../screens/post/post_view_screen.dart';

class BannerWidget extends StatelessWidget {
  final BannerModel banner;
  final double? width;

  const BannerWidget({Key? key, required this.banner, this.width})
      : super(key: key);

  // We have two case , first case that banner.post != null , second case that banner.post == null

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: width ?? MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: banner.post == null
            ? null
            : () {
                Navigator.of(context).pushNamed(PostViewScreen.routName,
                    arguments: {"post": banner.post});
              },
        child: LayoutBuilder(builder: (context, boxConstraints) {
          return Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: 250,
                margin: EdgeInsets.symmetric(vertical: 10.dg, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Theme.of(context).primaryColor,
                  boxShadow: [Helpers.boxShadow(context)],
                ),
                // Image
                child: Container(
                  width: width ?? MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10.r)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(banner.image!),
                    ),
                  ),
                ),
              ),
              // details
              Positioned(
                  bottom: 10,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.dg, vertical: 2.dg),
                    width: width ?? MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // price
                        if (banner.post != null &&
                            banner.post!.postType != Constants.postUpKey)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.only(
                                    topEnd: Radius.circular(30)),
                                color: AppColors.darkGrey.withOpacity(0.5)),
                            child: Text(
                              "${Helpers.getCurrencyName(banner.post!.priceCurrency.toString())} ${Helpers.numberFormatter(banner.post!.sellPrice!)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),

                        // description
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: AppColors.darkGrey.withOpacity(0.5)),
                          child: Text(
                            banner.post?.description ??
                                "Banners will added here",
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.whiteColor,
                                      fontSize: 14.0,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  )),
              // Discount
              if (banner.post?.discount != null &&
                  (banner.post?.discount ?? 0) >= 1 &&
                  banner.post!.postType != Constants.postUpKey)
                Positioned.directional(
                  textDirection: Directionality.of(context),
                  end: 10,
                  top: boxConstraints.maxHeight * .61,
                  child: Container(
                    width: 52.dg,
                    height: 28.dg,
                    decoration: BoxDecoration(
                        boxShadow: [Helpers.boxShadow(context)],
                        color: AppColors.darkPrimary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                          topLeft:
                              Directionality.of(context) == TextDirection.ltr
                                  ? Radius.circular(20.r)
                                  : Radius.zero,
                          topRight:
                              Directionality.of(context) == TextDirection.rtl
                                  ? Radius.circular(20.r)
                                  : Radius.zero,
                        )),
                    child: Center(
                      child: Text(
                        "${Helpers.removeDecimalZeroFormat(banner.post?.discount ?? 0)}%",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                  ),
                )
            ],
          );
        }),
      ),
    );
  }
}
