import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hsv_color_pickers/hsv_color_pickers.dart';
import 'package:media_library/src/controller/video_editor_controller.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/views/graphic_view.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/widgets/bars/filters_bar.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/widgets/video_with_color_filter_widget.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../../../../core/enums.dart';
import '../../../../../controller/media_controller.dart';
import '../constants.dart';
import '../enums/editing_mode.dart';
import '../views/basic_view.dart';
import '../views/paint_view.dart';
import '../views/text_view.dart';
import '../widgets/bars/editing_bar.dart';
import '../widgets/vertical_gest_behavior.dart';
import '../widgets/video_after_edit.dart';

class MainControllerView extends StatefulWidget {
  final File file;
  const MainControllerView({super.key, required this.file});

  @override
  State<MainControllerView> createState() => _MainControllerViewState();
}

class _MainControllerViewState extends State<MainControllerView> {
  HueController huecontroller = HueController(HSVColor.fromColor(Colors.green));

  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.file(File(widget.file.path))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //moved Material App from here to whatsappstoryeditor screen
    return PopScope(
      onPopInvoked: (val) {
        Navigator.popUntil(context, (route) => route.isFirst);
      },
      child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.black,
              // body: Center(
              //   child: Column(children: [
              //     MatrixGestureDetector(
              //       onScaleStart: (d) {
              //         EditableItem.changeSvgColor(
              //             EditableItem.circleShapeSvg(), Colors.red);
              //         print("start: " + d.toString());
              //       },
              //       onScaleEnd: (d) {
              //         print("end: " + d.toString());
              //       },
              //       clipChild: false,
              //       onMatrixUpdate: (m, tm, sm, rm) {
              //         notifier.value = m;
              //       },
              //       child: GestureDetector(
              //         onTap: () {},
              //         child: Container(
              //           width: MediaQuery.of(context).size.width,
              //           height: MediaQuery.of(context).size.height - 100,
              //           alignment: Alignment.center,
              //           child: AnimatedBuilder(
              //             animation: notifier,
              //             builder: (ctx, childw) {
              //               return Transform(
              //                   transform: notifier.value,
              //                   child: Container(
              //                     height: 200,
              //                     width: 200,
              //                     //Circle:
              //                     child: SvgPicture.string(
              //                         EditableItem.squareShapeSvg()),
              //                     //Arrow:
              //                     //child: SvgPicture.string("""<svg height="24" width="24"> <path d="M2,12 L22,12 M16,6 L22,12 L16,18" stroke="black" stroke-width="1" fill="none" /></svg>""")
              //                     //Line:
              //                     //child: SvgPicture.string("""<svg height="2" width="100"> <line x1="0" y1="1" x2="100" y2="1" stroke="black" stroke-width="2" /></svg>"""),
              //                     //doubleArrow:
              //                     //child: SvgPicture.string("""<svg height="24" width="24"><path d="M2,12 L10,12 M14,12 L22,12 M16,6 L22,12 L16,18 M2,12 L10,12 M14,12 L2,12 M8,6 L2,12 L8,18" stroke="black" stroke-width="2" fill="none" /></svg>"""),
              //                     // rectangle:
              //                     // child: SvgPicture.string("""<svg height="100" width="200"><rect x="50" y="20" width="100" height="60" stroke="black" stroke-width="2" fill="none" /></svg>""")
              //                   ));
              //             },
              //           ),
              //         ),
              //       ),
              //     )
              //   ]),
              // ),
              body: Stack(
                children: [
                  Selector<VideoEditingController, EditorMode>(
                      selector: (context, videoController) {
                    return Provider.of<VideoEditingController>(context,
                            listen: false)
                        .editingModeSelected;
                  }, builder: (context, editingModeSelected, child) {
                    if (editingModeSelected == EditorMode.FILTERS) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          editingBar(file: widget.file, context: context),
                          verticalGestureBehavior(
                            context: context,
                            child: videoPlayerController.value.isInitialized
                                ? VideoWithColorFilterWidget(
                                    videoPlayerController:
                                        videoPlayerController,
                                  )
                                : const SizedBox(),
                            //  BackgroundImage(
                            //     context: context, file: widget.file),
                          ),
                          filtersBar(
                              context: context,
                              videoPlayerController: videoPlayerController)
                        ],
                      );
                    } else {
                      return Stack(
                        // alignment: Alignment.,
                        children: [
                          editingModeSelected == EditorMode.NONE
                              ? Center(
                                  child: VideoAfterEditWidget(
                                  videoPlayerController: videoPlayerController,
                                ))
                              : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    VideoAfterEditWidget(
                                      videoPlayerController:
                                          videoPlayerController,
                                    ),
                                  ],
                                ),
                          editingModeSelected == EditorMode.DRAWING
                              ? const PaintView(shouldShowControls: true)
                              : editingModeSelected == EditorMode.TEXT
                                  ? const TextView()
                                  : BasicView(file: widget.file)
                        ],
                      );
                    }
                  }),
                  Selector<MediaController, bool>(
                      selector: (context, mediaController) {
                    return mediaController.screenView ==
                        ScreenView.videoEDitorGraphicalView;
                  }, builder: (context, videoEDitorGraphicalView, child) {
                    if (videoEDitorGraphicalView) {
                      return const GraphicView();
                    }
                    return const SizedBox();
                  }),
                ],
              ))),
    );
  }
}
