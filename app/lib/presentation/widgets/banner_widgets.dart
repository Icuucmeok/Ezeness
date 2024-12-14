import 'package:ezeness/data/models/banner/banner.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/presentation/screens/post/post_view_screen.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BannerWidget extends StatefulWidget {
  final PostMedia media;
  final BannerModel? banner;
  final double? width;

  const BannerWidget({
    Key? key,
    required this.media,
    this.banner,
    this.width,
  }) : super(key: key);

  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController videoPlayerController;
  bool isPlaying = true;
  double volume = 1;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.media.type == 'video') {
      videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.media.path!))
            ..initialize().then((_) {
              setState(() {});
            });
      videoPlayerController.setLooping(true);
      videoPlayerController.setVolume(volume);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  void dispose() {
    if (widget.media.type == 'video') {
      videoPlayerController.dispose();
    }
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  Widget _getMediaContent() {
    if (widget.media.type == 'image') {
      return Image.network(
        widget.media.path!,
        fit: BoxFit.cover,
      );
    } else if (widget.media.type == 'video') {
      return _buildVideoPlayer();
    }
    return Container();
  }

  Widget _buildVideoPlayer() {
    return VisibilityDetector(
      key: ObjectKey(videoPlayerController),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && mounted) {
          videoPlayerController.pause();
          KeepScreenOn.turnOff();
        }
        if (visibility.visibleFraction == 1 && mounted) {
          videoPlayerController.play();
          KeepScreenOn.turnOn();
        }
      },
      child: videoPlayerController.value.isInitialized
          ? AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
              child: VideoPlayer(videoPlayerController),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        if (widget.media.type == 'video') {
          setState(() {
            if (videoPlayerController.value.isPlaying) {
              videoPlayerController.pause();
            } else {
              videoPlayerController.play();
            }
          });
        } else if (widget.banner?.post != null) {
          Navigator.of(context).pushNamed(
            PostViewScreen.routName,
            arguments: {"post": widget.banner!.post},
          );
        }
      },
      child: Stack(
        children: [
          _getMediaContent(),
          if (widget.banner != null) _buildBannerOverlay(),
        ],
      ),
    );
  }

  Widget _buildBannerOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.banner?.post != null
            ? () {
                Navigator.of(context).pushNamed(
                  PostViewScreen.routName,
                  arguments: {"post": widget.banner?.post},
                );
              }
            : null,
        child: Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.symmetric(vertical: 10.dg, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Theme.of(context).primaryColor,
            boxShadow: [Helpers.boxShadow(context)],
          ),
          child: Stack(
            children: [
              _buildBannerImage(),
              _buildBannerContent(),
              if (_shouldShowDiscount()) _buildDiscountTag(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerImage() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
        image: widget.banner?.image != null
            ? DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.banner!.image!),
              )
            : null,
      ),
    );
  }

  Widget _buildBannerContent() {
    return Positioned(
      bottom: 10,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.dg, vertical: 2.dg),
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPrice(),
            _buildDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrice() {
    if (widget.banner?.post?.postType == Constants.postUpKey)
      return Container();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(30)),
        color: AppColors.darkGrey.withOpacity(0.5),
      ),
      child: Text(
        "${Helpers.getCurrencyName(widget.banner!.post!.priceCurrency.toString())} ${Helpers.numberFormatter(widget.banner!.post!.sellPrice!)}",
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.whiteColor,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkGrey.withOpacity(0.5),
      ),
      child: Text(
        widget.banner!.post?.description ?? "Banners will be added here",
        maxLines: 1,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.whiteColor,
              fontSize: 14.0,
              overflow: TextOverflow.ellipsis,
            ),
      ),
    );
  }

  bool _shouldShowDiscount() {
    return widget.banner?.post?.discount != null &&
        (widget.banner?.post?.discount ?? 0) >= 1 &&
        widget.banner!.post!.postType != Constants.postUpKey;
  }

  Widget _buildDiscountTag() {
    return Positioned.directional(
      textDirection: Directionality.of(context),
      end: 10,
      top: MediaQuery.of(context).size.height * 0.61,
      child: Container(
        width: 52.dg,
        height: 28.dg,
        decoration: BoxDecoration(
          boxShadow: [Helpers.boxShadow(context)],
          color: AppColors.darkPrimary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r),
            topLeft: Directionality.of(context) == TextDirection.ltr
                ? Radius.circular(20.r)
                : Radius.zero,
            topRight: Directionality.of(context) == TextDirection.rtl
                ? Radius.circular(20.r)
                : Radius.zero,
          ),
        ),
        child: Center(
          child: Text(
            "${Helpers.removeDecimalZeroFormat(widget.banner!.post?.discount ?? 0)}%",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
      ),
    );
  }
}
