import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_screenshot/flutter_native_screenshot.dart';
import 'package:save_note/save_note.dart';

class AppNoteController extends ChangeNotifier {
  late final DrawingController _drawing;
  DrawingController get drawing => _drawing;

  final Map<String, NoteSender> _noteSenders = {};

  /// Returns a map of note senders
  Map<String, NoteSender> get noteSenders => _noteSenders;

  static final AppNoteController _instance = AppNoteController._internal();

  factory AppNoteController() {
    return _instance;
  }

  AppNoteController._internal() {
    _drawing = DrawingController();
  }

  /// Adds a note sender to the list of note senders
  addNoteSender(NoteSender sender) {
    if (_noteSenders.containsKey(sender.id)) {
      debugPrint('NoteSender ${sender.id} already exists');
      return;
    }

    _noteSenders[sender.id] = sender;
  }

  /// Adds a list of note senders to the list of note senders
  addNoteSenders(List<NoteSender> senders) {
    for (var sender in senders) {
      _noteSenders[sender.id] = sender;
    }
  }

  /// Removes a note sender from the list of note senders
  removeNoteSender(String id) {
    if (_noteSenders.containsKey(id)) {
      _noteSenders.remove(id);
    }
  }

  /// Creates a note
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

  /// Clears the drawing
  clearDrawing() {
    _drawing.clear();
  }

  Future<ByteData?> getImageData() => _drawing.getImageData();
}
