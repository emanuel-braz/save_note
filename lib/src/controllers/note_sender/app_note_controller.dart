import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_screenshot/flutter_native_screenshot.dart';
import 'package:save_note/save_note.dart';

class AppNoteController extends ChangeNotifier {
  late final DrawingController _drawing;
  DrawingController get drawing => _drawing;

  final Map<String, NoteSender> _noteSenders = {};
  Map<String, NoteSender> get noteSenders => _noteSenders;

  static final AppNoteController _instance = AppNoteController._internal();

  factory AppNoteController() {
    return _instance;
  }

  AppNoteController._internal() {
    _drawing = DrawingController();
  }

  addNoteSender(NoteSender sender) {
    if (_noteSenders.containsKey(sender.id)) {
      debugPrint('NoteSender ${sender.id} already exists');
      return;
    }

    _noteSenders[sender.id] = sender;
  }

  addNoteSenders(List<NoteSender> senders) {
    for (var sender in senders) {
      _noteSenders[sender.id] = sender;
    }
  }

  removeNoteSender(String id) {
    if (_noteSenders.containsKey(id)) {
      _noteSenders.remove(id);
    }
  }

  void createNote(BuildContext context) async {
    FlutterNativeScreenshot.takeScreenshot().then((path) {
      debugPrint('Screenshot taken: $path');

      if (path == null || path.isEmpty) {
        debugPrint('Error taking the screenshot :(');
        return;
      }

      final image = Image.memory(
        Uint8List.fromList(
          File(path).readAsBytesSync(),
        ),
        fit: BoxFit.contain,
      );

      _openFullScreenModal(context, image);
    });
  }

  void _openFullScreenModal(BuildContext context, Image image) => {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          enableDrag: false,
          builder: (BuildContext context) {
            return NoteEditor(image);
          },
        )
      };

  clearDrawing() {
    _drawing.clear();
  }

  Future<ByteData?> getImageData() => _drawing.getImageData();
}
