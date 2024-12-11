import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:media_library/core/entity/media_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../data/models/post/post.dart';
import '../../pkg/media_library-main/lib/core/entity/media_file.dart';
import '../../res/app_res.dart';
import '../utils/helpers.dart';
import 'common/common.dart';

class EditPostMediaWidget extends StatelessWidget {
  final PostMedia? postMedia;
  final MediaFile? mediaFile;
  const EditPostMediaWidget({this.postMedia, this.mediaFile, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(4.w),
        height: 100,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11.r),
          child: postMedia != null
              ? CachedNetworkImage(
                  height: 80,
                  width: 80.w,
                  imageUrl: postMedia!.type == "video"
                      ? postMedia!.thumbnail ?? Constants.defaultVideoThumbnail
                      : postMedia!.path!,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => SizedBox(
                      height: 80,
                      width: 80.w,
                      child: Image.asset(Assets.assetsImagesPlaceholder,
                          fit: BoxFit.fill)),
                  placeholder: (context, url) => const ShimmerLoading(),
                )
              : Helpers.isVideoExtension(mediaFile!.path.split(".").last)
                  ? FutureBuilder(
                      future: getVideo(mediaFile!),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const ShimmerLoading();
                        }
                        return Image.file(
                          File(snapshot.data as String),
                          fit: BoxFit.fill,
                        );
                      })
                  : mediaFile?.getFile() != null
                      ? Image.file(
                          mediaFile!.getFile()!,
                          height: 80,
                          width: 80.w,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox.shrink(),
        ));
  }
}

Future<String> getVideo(MediaFile mediaFile) async {
  final String? fileName = await VideoThumbnail.thumbnailFile(
    video: mediaFile.path,
    thumbnailPath:
        mediaFile.thumbnailUrl ?? (await getTemporaryDirectory()).path,
    imageFormat: ImageFormat.PNG,
    quality: 10,
  );
  return fileName!;
}
