import 'dart:io';
import 'package:flutter/material.dart';

import '../widgets/video_editor/video_painter/src/enums/editable_item_type.dart';
import '../widgets/video_editor/video_painter/src/enums/editing_mode.dart';
import '../widgets/video_editor/video_painter/src/models/graphic_info.dart';

class VideoEditingController extends ChangeNotifier {
  /// The color selected from the color vertical slider
  HSVColor _hueController = HSVColor.fromColor(Colors.green);
  HSVColor get hueController => _hueController;
  set hueController(HSVColor hueController) {
    _hueController = hueController;
    notifyListeners();
  }

  /// Main Background Image; usually updates after cropped and after final Editing
  /// try to minimize the memory image saving
  File _video = File("");
  File get video => _video;
  set video(File newvideo) {
    _video = newvideo;
    notifyListeners();
  }

  /// Selected paint-brush index (size) one of four different sizes
  /// Be-default the selected is first one
  int _paintBrush = 1;
  int get paintBrush => _paintBrush;
  set paintBrush(int newPaintBrush) {
    _paintBrush = newPaintBrush;
    notifyListeners();
  }

  /// The selected editing mode from the top bar
  /// Choose from EditorMode enumerator
  EditorMode _editingModeSelected = EditorMode.NONE;
  EditorMode get editingModeSelected => _editingModeSelected;
  set editingModeSelected(EditorMode newEditingModeSelected) {
    _editingModeSelected = newEditingModeSelected;
    notifyListeners();
  }

  /// Index of the filter that is selected
  /// Be-default it is 0 which means none/no filter applied
  int _selectedFilter = 0;
  int get selectedFilter => _selectedFilter;
  set selectedFilter(int newSelectedFilter) {
    _selectedFilter = newSelectedFilter;
    notifyListeners();
  }

  /// Selected Editable Information from EditorMode.GRAPHIC || EditorMode.TEXT
  List<VideoEditableItem?> _editableItemInfo = <VideoEditableItem?>[];
  List<VideoEditableItem?> get editableItemInfo => _editableItemInfo;
  set editableItemInfo(List<VideoEditableItem?> editableItemInfo) {
    _editableItemInfo = editableItemInfo;
    notifyListeners();
  }

  void addToEditableItemList(VideoEditableItem editableItem) {
    _editableItemInfo.add(editableItem);
    notifyListeners();
  }

  List<VideoEditableItem> getEditableTextType() {
    return _editableItemInfo
        .where((item) => item!.editableItemType == EditableItemType.text)
        .toList()
        .cast<VideoEditableItem>();
  }

  void undoLastEditableTextItem() {
    try {
      _editableItemInfo.remove(_editableItemInfo
          .lastWhere((e) => e!.editableItemType == EditableItemType.text));
      notifyListeners();
    } catch (e) {
      if (e is StateError) {
        debugPrint("No Text element to Undo");
      }
    }
  }

  /// Caption of the image
  String _caption = "";
  String get caption => _caption;
  set caption(String newCaption) {
    _caption = newCaption;
    notifyListeners();
  }

  /// Status if the VideoEditableItem is in Deletion Zone
  bool _isDeletionEligible = false;
  bool get isDeletionEligible => _isDeletionEligible;
  set isDeletionEligible(bool status) {
    _isDeletionEligible = status;
    notifyListeners();
  }

  /// The rotation Angle of the Image if it was rotated
  double _rotationAngle = 0.0;
  double get rotationAngle => _rotationAngle;
  set rotationAngle(double angle) {
    _rotationAngle = angle;
    notifyListeners();
  }

  /// The rotation Phase of the Image if it was rotated
  /// Includes from 0,1,2,3
  int _rotation = 0;
  int get rotation => _rotation;
  set rotation(int rotation) {
    _rotation = rotation;
    notifyListeners();
  }

  toggleFilter() {
    if (editingModeSelected == EditorMode.FILTERS) {
      editingModeSelected = EditorMode.NONE;
    } else {
      editingModeSelected = EditorMode.FILTERS;
    }
    notifyListeners();
  }
}
