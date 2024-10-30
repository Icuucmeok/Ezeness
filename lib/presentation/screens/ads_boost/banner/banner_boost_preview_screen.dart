import 'dart:math';

import 'package:ezeness/data/models/app_file.dart';
import 'package:ezeness/data/models/boost/plans/boost_plans_model.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/presentation/screens/ads_boost/banner/banner_boost_terms_screen.dart';
import 'package:ezeness/presentation/utils/app_modal_bottom_sheet.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_picker_widget/media_picker_widget.dart';

class BannerBoostPreviewScreen extends StatefulWidget {
  static const String routName = 'banner_preview';

  const BannerBoostPreviewScreen({
    Key? key,
    required this.plan,
    required this.post,
  }) : super(key: key);

  final Post post;
  final BoostPlansModel plan;

  @override
  State<BannerBoostPreviewScreen> createState() =>
      _BannerBoostPreviewScreenState();
}

class _BannerBoostPreviewScreenState extends State<BannerBoostPreviewScreen> {
  List<Media> selectedBannerImage = [];

  setBannerImage(String bannerImage) async {
    selectedBannerImage.add(
      Media(
        id: "1",
        file: await Helpers.urlToFile(bannerImage,
            path: "banner_img_${Random().nextInt(100000)}"),
      ),
    );
    setState(() {});
  }

  AppFile? get bannerImageFile {
    AppFile? bannerImageFile = selectedBannerImage.isEmpty
        ? null
        : AppFile(
            file: selectedBannerImage.first.file!,
            fileKey: "image",
          );

    return bannerImageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(S.current.bannerImage),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Headers
            Text(
              S.current.bannerPreview,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 20),
            Text(
              S.current.noteLongQueues,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.greyDark,
                    fontSize: 18.sp,
                  ),
            ),
            SizedBox(height: 35),

            // Banner
            _buildBannerWidget(context),

            Spacer(),

            // Next button
            CustomElevatedButton(
              margin: EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
              backgroundColor: selectedBannerImage.isEmpty
                  ? AppColors.grey
                  : AppColors.primaryColor,
              withBorderRadius: true,
              onPressed: selectedBannerImage.isEmpty
                  ? null
                  : () {
                      Navigator.of(context).pushNamed(
                        BannerBoostTermsScreen.routName,
                        arguments: {
                          "post": widget.post,
                          "file": bannerImageFile,
                          "plan": widget.plan,
                        },
                      );
                    },
              child: Text(
                S.current.next,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 15.sp,
                      color: AppColors.whiteColor,
                    ),
              ),
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  Widget _buildBannerWidget(BuildContext context) {
    return SizedBox(
      height: 250.0,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          AppModalBottomSheet.showMainModalBottomSheet(
            context: context,
            scrollableContent: MediaPicker(
              mediaList: selectedBannerImage,
              onPicked: (selectedList) {
                Navigator.pop(context);
                setState(() {
                  selectedBannerImage = selectedList;
                });
              },
              headerBuilder: (context, albumPicker, onDone, onCancel) {
                return SizedBox(
                  height: 50.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.clear)),
                      Expanded(child: Center(child: albumPicker)),
                      TextButton(
                        onPressed: onDone,
                        child: Text(S.current.next),
                      ),
                    ],
                  ),
                );
              },
              mediaCount: MediaCount.single,
              mediaType: MediaType.image,
              decoration: PickerDecoration(
                albumTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                albumTitleStyle:
                    Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
              ),
            ),
          );
        },
        child: LayoutBuilder(builder: (context, boxConstraints) {
          return Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: 250.0,
                margin: EdgeInsets.symmetric(vertical: 10.dg),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Theme.of(context).primaryColor,
                  boxShadow: [Helpers.boxShadow(context)],
                ),
                child: Column(
                  children: [
                    // Image
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColors.grey,
                          borderRadius: BorderRadius.circular(20.r),
                          image: selectedBannerImage.isNotEmpty
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                      selectedBannerImage.first.file!),
                                )
                              : DecorationImage(
                                  image: AssetImage(
                                      Assets.assetsImagesPlaceholder),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),

                    // details
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.dg, vertical: 2.dg),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // price
                          if (widget.post.sellPrice != null)
                            Text(
                              "${Helpers.getCurrencyName(widget.post.priceCurrency.toString())} ${Helpers.numberFormatter(widget.post.sellPrice!)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),

                          // description
                          Text(
                            widget.post.description ??
                                S.current.bannersAddedHere,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ),

              // Discount
              if (widget.post.discount != null)
                Positioned.directional(
                  textDirection: Directionality.of(context),
                  end: 0,
                  top: boxConstraints.maxHeight * .57,
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
                        "${Helpers.removeDecimalZeroFormat(widget.post.discount!)}%",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
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
