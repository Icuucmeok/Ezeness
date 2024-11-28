import 'dart:io';
import 'package:flutter/material.dart';

import 'package:media_library/src/widgets/video_editor/video_painter/src/enums/editing_mode.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../../../../controller/video_editor_controller.dart';
import '../../constants.dart';
import '../video_with_color_filter_widget.dart';

/// the filters bar allows to add filters to image
filtersBar(
    {required VideoPlayerController videoPlayerController,
    required BuildContext context}) {
  final videoController = Provider.of<VideoEditingController>(context);
  return Container(
      height: MediaQuery.of(context).size.height *
          (Constants.bottomBarHeightRatio + Constants.captionBarHeightRatio),
      color: Constants.mattBlack,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: Constants.filterTitle.length,
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: (() {
              final cont =
                  Provider.of<VideoEditingController>(context, listen: false);
              cont.editingModeSelected = EditorMode.FILTERS;
              cont.selectedFilter = index;
            }),
            child: Container(
              width: 65,
              margin: EdgeInsets.only(
                  bottom: 10.0,
                  top: videoController.selectedFilter == index ? 10 : 18.0),
              child: Stack(children: [
                index == 0
                    ? SizedBox(
                        height: double.infinity,
                        width:
                            videoController.selectedFilter == index ? 60 : 58,
                        child: VideoWithColorFilterWidget(
                          showPlayButton: false,
                          videoPlayerController: videoPlayerController,
                        ))
                    : SizedBox(
                        height: double.infinity,
                        width:
                            videoController.selectedFilter == index ? 60 : 58,
                        child: ColorFiltered(
                            colorFilter:
                                ColorFilter.matrix(Constants.filters[index]),
                            child: VideoWithColorFilterWidget(
                              showPlayButton: false,
                              videoPlayerController: videoPlayerController,
                            )),
                      ),
                Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      width: videoController.selectedFilter == index ? 60 : 58,
                      height: 25,
                    )),
                Positioned(
                  bottom: 5.0,
                  left: 6.0,
                  right: 4.0,
                  child: Text(
                    Constants.filterTitle[index],
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        color: Constants.grey2,
                        fontSize: 14,
                        letterSpacing: -0.5),
                  ),
                ),
                videoController.editingModeSelected == EditorMode.FILTERS &&
                        videoController.selectedFilter == index
                    ? Positioned(
                        right: 10.0,
                        top: 4.0,
                        child: Container(
                          alignment: Alignment.center,
                          height: 22,
                          width: 22,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                              color: Colors.teal.shade600,
                              shape: BoxShape.circle),
                          child: const Icon(Icons.done, size: 15),
                        ),
                      )
                    : const SizedBox(),
              ]),
            ),
          );
        }),
      ));
}
