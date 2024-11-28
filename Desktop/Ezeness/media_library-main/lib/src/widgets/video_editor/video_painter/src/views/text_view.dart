import 'package:flutter/material.dart';
import 'package:media_library/src/widgets/video_editor/video_painter/src/enums/editing_mode.dart';
import 'package:provider/provider.dart';
import '../../../../../controller/video_editor_controller.dart';
import '../constants.dart';
import '../enums/editable_item_type.dart';
import '../models/graphic_info.dart';
import '../models/text_info.dart';
import '../widgets/color_picker_slider.dart';
import '../widgets/circle_widget.dart';
import '../widgets/done_btn.dart';
import '../widgets/text_dialog.dart';
import '../widgets/undo.dart';

///Allows to add Text over the Image
class TextView extends StatefulWidget {
  const TextView({Key? key}) : super(key: key);

  @override
  State<TextView> createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  Offset? lastTappedOffset;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showTextEditDialog());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        _textBar(),

        /// to add text on clicking anywhere on screen
        Positioned(
            top: size.height * Constants.editingBarHeightRatio,
            bottom: size.height *
                (Constants.captionBarHeightRatio +
                    Constants.bottomBarHeightRatio),
            child: _drawTextPainter()),
        const Positioned(top: 80, right: 16, child: ColorPickerSlider())
      ],
    );
  }

  _showTextEditDialog() {
    final videoController =
        Provider.of<VideoEditingController>(context, listen: false);

    TextDialog.show(context, TextEditingController(), 36,
        videoController.hueController.toColor(),
        onFinished: (context) => Navigator.of(context).pop(),
        onSubmitted: (text) {
          videoController.addToEditableItemList(VideoEditableItem(
            editableItemType: EditableItemType.text,
            matrixInfo: Matrix4.identity(),
            text: TextInfo(
              text: text,
              offset: lastTappedOffset,
              color: videoController.hueController.toColor(),
            ),
          ));
          videoController.editingModeSelected = EditorMode.NONE;
        });
  }

  _textBar() {
    final videoController = Provider.of<VideoEditingController>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Row(
        children: [
          doneBtn(onTap: () async {
            Provider.of<VideoEditingController>(context, listen: false)
                .editingModeSelected = EditorMode.NONE;
          }),
          const Spacer(),
          videoController.getEditableTextType().isNotEmpty
              ? undo(
                  onTap: () => setState(() {
                        Provider.of<VideoEditingController>(context,
                                listen: false)
                            .undoLastEditableTextItem();
                      }))
              : const SizedBox(),
          const SizedBox(width: 10.0),
          circleWidget(
              radius: 45,
              bgColor: videoController.hueController.toColor(),
              onTap: () => TextDialog.show(context, TextEditingController(), 16,
                  videoController.hueController.toColor(),
                  onFinished: (context) => Navigator.of(context).pop(),
                  onSubmitted: (text) => Provider.of<VideoEditingController>(
                          context,
                          listen: false)
                      .addToEditableItemList(VideoEditableItem(
                          editableItemType: EditableItemType.text,
                          matrixInfo: Matrix4.identity(),
                          text: TextInfo(
                              text: text,
                              offset: null,
                              color:
                                  videoController.hueController.toColor())))),
              child: const Icon(
                Icons.title,
                color: Colors.white,
              )),
        ],
      ),
    );
  }

  /// TO PAINT TEXT INSTEAD OF WRITING THROUGH TEXTFIELD
  /// Not being used Currently
  _drawTextPainter() {
    return GestureDetector(
      // onTapDown: (TapDownDetails details) => setState(() {
      //   // lastTappedOffset = details.localPosition;
      // }),
      onTap: () {
        _showTextEditDialog();
      },
      child: Container(
        color: Colors.red,
        // width: Get.width,
        // height: Get.height * Constants.contentHeightRatio,
      ),
      // child: CustomPaint(
      //   size: Size(sWidth, sHeight * Constants.contentHeightRatio),
      //   painter: Sketcher(editingmode: EDITINGMODE.TEXT),
      // ),
    );
  }
}
