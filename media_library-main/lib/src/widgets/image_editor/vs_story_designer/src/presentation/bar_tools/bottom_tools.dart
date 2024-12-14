// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:media_library/src/widgets/image_editor/done_button_image_editor.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../../../custom_camera/gallery_picker_button.dart';
import '../../domain/providers/notifiers/control_provider.dart';
import '../../domain/providers/notifiers/draggable_widget_notifier.dart';
import '../../domain/providers/notifiers/painting_notifier.dart';
import '../../domain/providers/notifiers/scroll_notifier.dart';
import '../../domain/sevices/save_as_image.dart';
import '../utils/constants/item_type.dart';
import '../utils/constants/text_animation_type.dart';
import '../widgets/animated_onTap_button.dart';

// import 'package:vs_story_designer/src/presentation/widgets/tool_button.dart';

class BottomTools extends StatelessWidget {
  final GlobalKey contentKey;
  final Function(String imageUri) onDone;
  final Widget? onDoneButtonStyle;
  final Function? renderWidget;

  /// editor background color
  final Color? editorBackgroundColor;
  const BottomTools(
      {super.key,
      required this.contentKey,
      required this.onDone,
      this.renderWidget,
      this.onDoneButtonStyle,
      this.editorBackgroundColor});

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    bool _createVideo = false;
    return Consumer4<ControlNotifier, ScrollNotifier, DraggableWidgetNotifier,
        PaintingNotifier>(
      builder: (_, controlNotifier, scrollNotifier, itemNotifier,
          paintingNotifier, __) {
        return Container(
          height: 95,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// preview gallery
              Container(
                // width: _size.width / 3,
                // height: _size.width / 3,
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  child: _preViewContainer(
                    /// if [model.imagePath] is null/empty return preview image
                    child: controlNotifier.mediaPath.isEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: GestureDetector(
                              onTap: () {
                                /// scroll to gridView page
                                if (controlNotifier.mediaPath.isEmpty) {
                                  scrollNotifier.pageController.animateToPage(1,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease);
                                }
                              },
                              child: const GalleryPickerButton(
                                requestType: RequestType.image,
                              ),
                            ))

                        /// return clear [imagePath] provider
                        : GestureDetector(
                            onTap: () {
                              /// clear image url variable
                              controlNotifier.mediaPath = '';
                              itemNotifier.draggableWidget.removeAt(0);
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              color: Colors.transparent,
                              child: Transform.scale(
                                scale: 0.7,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              // if (controlNotifier.mediaPath.isEmpty)
              //   _selectColor(
              //       controlProvider: controlNotifier,
              //       onTap: () {
              //         if (controlNotifier.gradientIndex >=
              //             controlNotifier.gradientColors!.length - 1) {
              //           setState() {
              //             controlNotifier.gradientIndex = 0;
              //           }
              //         } else {
              //           setState() {
              //             controlNotifier.gradientIndex += 1;
              //           }
              //         }
              //       }),

              /// center logo
              controlNotifier.middleBottomWidget != null
                  ? Center(
                      child: Container(
                          width: _size.width / 3,
                          height: 80,
                          alignment: Alignment.bottomCenter,
                          child: controlNotifier.middleBottomWidget),
                    )
                  : const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Story Designer',
                            style: TextStyle(
                                color: Colors.white38,
                                letterSpacing: 1.5,
                                fontSize: 9.2,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

              /// save final image to gallery

              AnimatedOnTapButton(
                onTap: () async {
                  String pngUri;
                  if (paintingNotifier.lines.isNotEmpty ||
                      itemNotifier.draggableWidget.isNotEmpty) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                  color: Colors.white,
                                  child: Container(
                                      padding: const EdgeInsets.all(50),
                                      child:
                                          const CircularProgressIndicator())),
                            ],
                          );
                        });

                    for (var element in itemNotifier.draggableWidget) {
                      if (element.type == ItemType.gif ||
                          element.animationType != TextAnimationType.none) {
                        // setState(() {
                        _createVideo = true;
                        // });
                      }
                    }
                    if (_createVideo) {
                      debugPrint('creating video');
                      await renderWidget!();
                    } else {
                      debugPrint('creating image');
                      await takePicture(
                              contentKey: contentKey,
                              context: context,
                              saveToGallery: false,
                              fileName: controlNotifier.folderName)
                          .then((bytes) {
                        Navigator.of(context, rootNavigator: true).pop();
                        if (bytes != null) {
                          pngUri = bytes;
                          onDone(pngUri);
                        } else {
                          // ignore: avoid_print
                          print("error");
                        }
                      });
                    }
                  } else {
                    showToast('Design something to save image');
                  }
                  // setState(() {
                  _createVideo = false;
                  // });
                },
                child: onDoneButtonStyle ?? const DoneButtonImageEditor(),
              )

              // Padding(
              //   padding: const EdgeInsets.only(right: 10),
              //   child: Container(
              //     width: _size.width / 4,
              //     alignment: Alignment.centerRight,
              //     padding: const EdgeInsets.only(right: 0),
              //     child: Transform.scale(
              //       scale: 0.9,
              //       child: StatefulBuilder(
              //         builder: (_, setState) {
              //         },
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget _preViewContainer({child}) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.4, color: Colors.white)),
      child: child,
    );
  }

  // /bagr  colors

  // Widget _selectColor({onTap, controlProvider}) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 5, right: 0, top: 0),
  //     child: AnimatedOnTapButton(
  //       onTap: onTap,
  //       child: Container(
  //         padding: const EdgeInsets.all(2),
  //         decoration: BoxDecoration(
  //             // border: Border.all(
  //             //   color: Colors.white,
  //             // ),
  //             // borderRadius: BorderRadius.circular(8)
  //             // // shape: BoxShape.circle,
  //             ),
  //         child: Container(
  //           width: 45,
  //           height: 45,
  //           decoration: BoxDecoration(
  //             border: Border.all(
  //               color: Colors.white,
  //             ),
  //             borderRadius: BorderRadius.circular(8),

  //             gradient: LinearGradient(
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //                 colors: controlProvider
  //                     .gradientColors![controlProvider.gradientIndex]),
  //             // border: Border.all(
  //             //     // color: Colors.white,
  //             //     ),
  //             //  shape: BoxShape.circle,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
