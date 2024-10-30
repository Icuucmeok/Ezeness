import 'dart:async';

import 'package:flutter/material.dart';

class ImageViewerWidget extends StatefulWidget {
  final Widget child;
  final double maxScale;
  final bool zoomEnabled;
  final Function? onZoomStart, onZoomEnd;

  ImageViewerWidget(
      {required this.child,
      // This default maxScale value is eyeballed as reasonable limit for common
      // use cases.
      this.maxScale = 3.0,
      this.zoomEnabled = true,
      this.onZoomStart,
      this.onZoomEnd});

  @override
  _ImageViewerWidgetState createState() => _ImageViewerWidgetState();
}

class _ImageViewerWidgetState extends State<ImageViewerWidget>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  OverlayEntry? _overlayEntry;
  final widgetKey = GlobalKey();
  Timer? _endScrollTimer;
  bool? endHandled;
  final Matrix4 identity = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      key: widgetKey,
      child: widget.child,
      scaleEnabled: widget.zoomEnabled,
      panEnabled: widget.zoomEnabled,
      maxScale: widget.maxScale,
      onInteractionStart: (details) {
        endHandled = null;
        if (details.pointerCount == 0) {
          endHandled = false;
          _transformationController.value = identity;
        } else {
          _endScrollTimer?.cancel();
        }
      },
      onInteractionUpdate: (details) {
        if (details.pointerCount == 0) {
          endHandled = false;
          _transformationController.value = identity;
        } else {
          _endScrollTimer?.cancel();
        }
      },
      onInteractionEnd: (details) {
        if (details.pointerCount == 0) {
          endHandled = false;
          _transformationController.value = identity;
        } else {
          _endScrollTimer = Timer(Duration(milliseconds: 100), () {
            endHandled = false;
            _transformationController.value = identity;
          });
        }
      },
      transformationController: _transformationController,
    );
  }

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(
      () {
        bool isIdentity = _transformationController.value.isIdentity();
        OverlayEntry? entry = _overlayEntry;

        if (endHandled == true) {
          _transformationController.value = identity;
        } else if (endHandled == false) {
          endHandled = true;
          if (widget.onZoomEnd != null) {
            widget.onZoomEnd!();
          }
          if (entry != null) {
            entry.remove();
            _overlayEntry = null;
          }
        } else if (!isIdentity && entry == null) {
          RenderBox? box =
              widgetKey.currentContext?.findRenderObject() as RenderBox?;
          if (box == null) return;
          Offset position = box.localToGlobal(Offset.zero);
          entry = OverlayEntry(
            builder: (context) => ValueListenableBuilder(
              valueListenable: _transformationController,
              builder: (BuildContext context, Matrix4 value, Widget? child) {
                return Positioned(
                  left: position.dx,
                  top: position.dy,
                  width: box.size.width,
                  height: box.size.height,
                  child: IgnorePointer(
                    child: Transform(
                      transform: value,
                      child: widget.child,
                    ),
                  ),
                );
              },
            ),
          );
          _overlayEntry = entry;
          Overlay.of(context).insert(entry);
          if (widget.onZoomStart != null) {
            widget.onZoomStart!();
          }
        }
      },
    );
  }
}
