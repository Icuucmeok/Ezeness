import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:media_library/core/entity/media_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../data/models/post/post.dart';
import '../../res/app_res.dart';
import '../utils/helpers.dart';

class EditPostMediaWidget extends StatefulWidget {
  final PostMedia? postMedia;
  final MediaFile? mediaFile;

  const EditPostMediaWidget({this.postMedia, this.mediaFile, Key? key})
      : super(key: key);

  @override
  _EditPostMediaWidgetState createState() => _EditPostMediaWidgetState();
}

class _EditPostMediaWidgetState extends State<EditPostMediaWidget> {
  File? selectedCoverImage;
  bool isUploading = false;
  String thumbnailImage = "";

  Future<void> _pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      int fileSizeInMB = file.lengthSync() ~/ (1024 * 1024);
      if (fileSizeInMB > 70) {
        file = await compressVideo(file);
      }

      setState(() {
        selectedCoverImage = file;
      });
      await uploadVideo(file);
    }
  }

  Future<void> uploadVideo(File videoFile) async {
    if (isUploading) return;

    setState(() {
      isUploading = true;
    });

    final uri = Uri.parse('YOUR_API_ENDPOINT');
    final request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('file', videoFile.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print("Upload successful");
      } else {
        print("Upload failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading video: $e");
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  Future<File> compressVideo(File videoFile) async {
    final MediaInfo? info = await VideoCompress.compressVideo(
      videoFile.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );

    if (info != null) {
      return File(info.path!);
    }

    return videoFile;
  }

  Future<String> getVideoThumbnail(MediaFile mediaFile) async {
    // print("video thumbnail before created ${mediaFile.path}");

    // Get the base directory for thumbnails
    final String baseDirectory =
        '${(await getApplicationDocumentsDirectory()).path}/thumbnails';

    // Create the directory if it doesn't exist
    final Directory directory = Directory(baseDirectory);
    if (!directory.existsSync()) {
      // print("directory not exists");
      directory.createSync(recursive: true);
      // print("directory already exists");
    }

    // Define the file path for the thumbnail image
    final String thumbnailPath =
        '$baseDirectory${mediaFile.thumbnailUrl ?? 'default_thumbnail.JPEG'}';
    // print("Thumbnail path: $thumbnailPath");

    // Optionally update UI state with the directory path (if required)
    setState(() {
      thumbnailImage = thumbnailPath;
      // print(thumbnailPath);
      // print(thumbnailImage);
    });

    return thumbnailPath;
  }

  // @override
  // void initState() {
  //   getVideoThumbnail(widget.mediaFile!);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(4.w),
          height: 100,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11.r),
            child: widget.postMedia != null
                ? CachedNetworkImage(
                    height: 80,
                    width: 80.w,
                    imageUrl: widget.postMedia!.type == "video"
                        ? widget.postMedia!.thumbnail ??
                            Constants.defaultVideoThumbnail
                        : widget.postMedia!.path!,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => SizedBox(
                      height: 80,
                      width: 80.w,
                      child: Image.asset(Assets.assetsImagesPlaceholder,
                          fit: BoxFit.fill),
                    ),
                    placeholder: (context, url) => const ShimmerLoading(),
                  )
                : Helpers.isVideoExtension(
                        widget.mediaFile!.path.split(".").last)
                    ? FutureBuilder(
                        future: getVideoThumbnail(widget
                            .mediaFile!), //getVideoThumbnail(widget.mediaFile!),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox(
                              height: 80,
                              width: 80.w,
                              child: Image.asset(Assets.assetsImagesPlaceholder,
                                  fit: BoxFit.fill),
                            );
                            // Text("Loading...");
                            // return const ShimmerLoading();
                          } else if (snapshot.hasData) {
                            return Image.file(
                              File(snapshot.data as String),
                              fit: BoxFit.fill,
                            );
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return Text(
                              textAlign: TextAlign.center,
                              'Error loading thumbnail',
                              style: TextStyle(color: Colors.red),
                            );
                          }
                          return const SizedBox.shrink();
                        })
                    : widget.mediaFile?.getFile() != null

                        // thumbnailImage != "" && thumbnailImage.isNotEmpty
                        ? Image.file(
                            // widget.mediaFile!.getFile()!,
                            File(thumbnailImage),
                            height: 80,
                            width: 80.w,
                            fit: BoxFit.cover,
                          )
                        : const ShimmerLoading(),
          ),
        ),
        if (widget.postMedia?.type == "video" || widget.mediaFile != null)
          GestureDetector(
            onTap: _pickCoverImage,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 10.w),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.photo, color: Colors.black, size: 20),
                  SizedBox(width: 8.w),
                  Text(
                    'Add cover image',
                    style: TextStyle(color: Colors.black, fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ),
        if (selectedCoverImage != null) coverImageWidget(),
      ],
    );
  }

  Widget coverImageWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 8.w),
      child: Stack(
        children: [
          // Image Widget
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              selectedCoverImage!,
              height: 80,
              width: 80.w,
              fit: BoxFit.cover,
            ),
          ),

          // Positioned Close Button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCoverImage = null;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Widget> videoThumbnailWidget() async {
    bool loader = false;
    String url = "";
    void getVideoThumbnail() async {
      setState(() {
        loader = true;
      });
      url = (await getTemporaryDirectory()).path;
      setState(() {
        loader = false;
      });
      // return url;
    }

    return Container(
      margin: EdgeInsets.all(4.w),
      height: 100,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11.r),
        child: widget.mediaFile != null
            ? FutureBuilder<String?>(
                future: VideoThumbnail.thumbnailFile(
                  video: widget.mediaFile!.path, // Path to the video file
                  thumbnailPath: url,
                  imageFormat: ImageFormat.JPEG,
                  maxHeight: 80, // Max height of the thumbnail
                  quality: 75, // Quality of the thumbnail
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Image.file(
                        File(snapshot.data!),
                        height: 80,
                        width: 80.w,
                        fit: BoxFit.cover,
                      );
                    } else {
                      return const Icon(
                          Icons.error); // Fallback if thumbnail creation failed
                    }
                  } else {
                    return const ShimmerLoading(); // Loading state
                  }
                },
              )
            : const ShimmerLoading(), // Fallback if thumbnailImage is empty
      ),
    );
  }
}

// add this in clip react child widget above
// widget.postMedia != null
// ? CachedNetworkImage(
//     height: 80,
//     width: 80.w,
//     imageUrl: widget.postMedia!.type == "video"
//         ? widget.postMedia!.thumbnail ??
//             Constants.defaultVideoThumbnail
//         : widget.postMedia!.path!,
//     fit: BoxFit.cover,
//     errorWidget: (context, url, error) => SizedBox(
//       height: 80,
//       width: 80.w,
//       child: Image.asset(Assets.assetsImagesPlaceholder,
//           fit: BoxFit.fill),
//     ),
//     placeholder: (context, url) => const ShimmerLoading(),
//   )
// :
// Helpers.isVideoExtension(widget.mediaFile!.path.split(".").last)
//     ? FutureBuilder(
//         future: getVideoThumbnail(widget
//             .mediaFile!), //getVideoThumbnail(widget.mediaFile!),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return SizedBox(
//               height: 80,
//               width: 80.w,
//               child: Image.asset(Assets.assetsImagesPlaceholder,
//                   fit: BoxFit.fill),
//             );
//             // Text("Loading...");
//             // return const ShimmerLoading();
//           } else if (snapshot.hasData) {
//             return Image.file(
//               File(snapshot.data as String),
//               fit: BoxFit.fill,
//             );
//           } else if (snapshot.hasError) {
//             print(snapshot.error);
//             return Text(
//               textAlign: TextAlign.center,
//               'Error loading thumbnail',
//               style: TextStyle(color: Colors.red),
//             );
//           }
//           return const SizedBox.shrink();
//         })
//     : widget.mediaFile?.getFile() != null
