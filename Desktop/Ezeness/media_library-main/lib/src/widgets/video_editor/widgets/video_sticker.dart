import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stack_board/flutter_stack_board.dart';
import 'package:stack_board/stack_board_item.dart';
import 'package:stack_board/stack_case.dart';
import 'package:stack_board/stack_items.dart';
import 'package:video_player/video_player.dart';

class ColorContent extends StackItemContent {
  ColorContent({required this.color});

  Color color;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'color': color.value,
    };
  }
}

class ColorStackItem extends StackItem<ColorContent> {
  ColorStackItem({
    required Size size,
    String? id,
    Offset? offset,
    double? angle,
    StackItemStatus? status,
    ColorContent? content,
  }) : super(
          id: id,
          size: size,
          offset: offset,
          angle: angle,
          status: status,
          content: content,
        );

  @override
  ColorStackItem copyWith({
    Size? size,
    Offset? offset,
    double? angle,
    StackItemStatus? status,
    ColorContent? content,
    bool? lockZOrder,
  }) {
    return ColorStackItem(
      id: id, // <= must !!
      size: size ?? this.size,
      offset: offset ?? this.offset,
      angle: angle ?? this.angle,
      status: status ?? this.status,
      content: content ?? this.content,
    );
  }
}

class VideoStickerEditor extends StatefulWidget {
  final File file;
  const VideoStickerEditor({Key? key, required this.file}) : super(key: key);

  @override
  _VideoStickerEditorState createState() => _VideoStickerEditorState();
}

class _VideoStickerEditorState extends State<VideoStickerEditor> {
  late StackBoardController _boardController;
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    _boardController = StackBoardController();
    controller = VideoPlayerController.file(File(widget.file.path))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _boardController.dispose();
    controller.dispose();

    super.dispose();
  }

  /// Delete intercept
  Future<void> _onDel(StackItem<StackItemContent> item) async {
    final bool? r = await showDialog<bool>(
      context: context,
      builder: (_) {
        return Center(
          child: SizedBox(
            width: 400,
            child: Material(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 60),
                      child: Text('确认删除?'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                            onPressed: () => Navigator.pop(context, true),
                            icon: const Icon(Icons.check)),
                        IconButton(
                            onPressed: () => Navigator.pop(context, false),
                            icon: const Icon(Icons.clear)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (r == true) {
      _boardController.removeById(item.id);
    }
  }

  /// Add text item
  void _addTextItem() {
    _boardController.addItem(
      StackTextItem(
        size: const Size(200, 100),
        content: TextItemContent(data: '哈哈哈哈哈'),
      ),
    );
  }

  /// Add image item
  void _addImageItem() {
    _boardController.addItem(
      StackImageItem(
        size: const Size(300, 85),
        content: ImageItemContent(
          url:
              'https://files.flutter-io.cn/images/branding/flutterlogo/flutter-cn-logo.png',
        ),
      ),
    );
  }

  /// Add draw item
  void _addDrawItem() {
    _boardController.addItem(StackDrawItem(size: const Size.square(300)));
  }

  /// Add custom item
  void _addCustomItem() {
    final Color color =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];
    _boardController.addItem(
      ColorStackItem(
        size: const Size.square(100),
        content: ColorContent(color: color),
      ),
    );
  }

  /// Add custom item
  Future<void> _generateFromJson() async {
    final String jsonString =
        (await Clipboard.getData(Clipboard.kTextPlain))?.text ?? '';
    if (jsonString.isEmpty) {
      _showAlertDialog(
          title: 'Clipboard is empty',
          content: 'Please copy the json string to the clipboard first');
      return;
    }
    try {
      final List<dynamic> items = jsonDecode(jsonString) as List<dynamic>;

      for (final dynamic item in items) {
        if (item['type'] == 'StackTextItem') {
          _boardController.addItem(
            StackTextItem.fromJson(item),
          );
        } else if (item['type'] == 'StackImageItem') {
          _boardController.addItem(
            StackImageItem.fromJson(item),
          );
        } else if (item['type'] == 'StackDrawItem') {
          _boardController.addItem(
            StackDrawItem.fromJson(item),
          );
        }
      }
    } catch (e) {
      _showAlertDialog(title: 'Error', content: e.toString());
    }
  }

  /// get json
  Future<void> _getJson() async {
    final String json = jsonEncode(_boardController.getAllData());
    Clipboard.setData(ClipboardData(text: json));
    showDialog<void>(
      context: context,
      builder: (_) {
        return Center(
          child: SizedBox(
            width: 400,
            child: Material(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 60),
                      child: Text('Json'),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 500),
                      child: SingleChildScrollView(
                        child: Text(json),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.check)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Stack Board Demo'),
        elevation: 0,
      ),
      body: StackBoard(
        onDel: _onDel,
        controller: _boardController,
        caseStyle: const CaseStyle(
          buttonBorderColor: Colors.grey,
          buttonIconColor: Colors.grey,
        ),

        /// 背景
        background: backgroundVideo(),
        customBuilder: (StackItem<StackItemContent> item) {
          if (item is StackTextItem) {
            return StackTextCase(item: item);
          } else if (item is StackDrawItem) {
            return StackDrawCase(item: item);
          } else if (item is StackImageItem) {
            return StackImageCase(item: item);
          } else if (item is ColorStackItem) {
            return Container(
              width: item.size.width,
              height: item.size.height,
              color: item.content?.color,
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 25),
                  FloatingActionButton(
                      onPressed: _addTextItem,
                      child: const Icon(Icons.border_color)),
                  _spacer,
                  FloatingActionButton(
                      onPressed: _addImageItem, child: const Icon(Icons.image)),
                  _spacer,
                  FloatingActionButton(
                      onPressed: _addDrawItem,
                      child: const Icon(Icons.color_lens)),
                  _spacer,
                  FloatingActionButton(
                      onPressed: _addCustomItem,
                      child: const Icon(Icons.add_box)),
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              FloatingActionButton(
                onPressed: () => _boardController.clear(),
                child: const Icon(Icons.delete),
              ),
              _spacer,
              FloatingActionButton(
                onPressed: _getJson,
                child: const Icon(Icons.file_download),
              ),
              _spacer,
              FloatingActionButton(
                onPressed: _generateFromJson,
                child: const Icon(Icons.file_upload),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget get _spacer => const SizedBox(width: 5);

  void _showAlertDialog({required String title, required String content}) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget backgroundVideo() {
    return Stack(alignment: Alignment.center, children: [
      AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller),
      ),
      IconButton(
        icon: Icon(
          controller.value.isPlaying
              ? Icons.pause_circle_filled
              : Icons.play_circle_filled,
          color: Colors.white,
          size: 50,
        ),
        onPressed: () {
          setState(() {
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }
          });
        },
      ),
    ]);
  }
}
