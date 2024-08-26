import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../save_note.dart';
import 'confirm_dialog.dart';
import 'note_sender_icon.dart';

class NoteEditor extends StatefulWidget {
  final Image image;
  const NoteEditor(this.image, {super.key});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  void _selectMenuItem(String noteSenderId) async {
    AppNoteController().getImageData().then((ByteData? imageData) {
      final noteSender = AppNoteController().noteSenders[noteSenderId];
      if (noteSender == null || imageData == null) {
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ConfirmDialog(
            noteSender,
            imageData.buffer.asUint8List(),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    EdgeInsets statusBar = MediaQuery.paddingOf(context);

    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: statusBar.top + kToolbarHeight),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Save Note'),
            leading: IconButton(
              onPressed: () {
                NoteQuickActionButton.show(context);
                AppNoteController().clearDrawing();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.clear),
            ),
            actions: [
              PopupMenuButton<String>(
                onSelected: _selectMenuItem,
                itemBuilder: (BuildContext context) {
                  return AppNoteController()
                      .noteSenders
                      .keys
                      .map((String option) {
                    final noteSender = AppNoteController().noteSenders[option];

                    return PopupMenuItem<String>(
                      value: option,
                      child: Row(
                        children: [
                          NoteSenderIcon(noteSender?.icon),
                          const SizedBox(width: 10),
                          Text(noteSender?.channelName ?? 'No name'),
                        ],
                      ),
                    );
                  }).toList();
                },
                icon: const Icon(Icons.share),
              ),
            ],
          ),
          body: DrawingBoard(
            controller: AppNoteController().drawing,
            background: Container(
              width: size.width,
              height: size.height - 200,
              decoration: BoxDecoration(
                color: Theme.of(context).highlightColor.withOpacity(0.2),
                image: DecorationImage(
                  image: widget.image.image,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            showDefaultActions: true,
            showDefaultTools: true,
            boardBoundaryMargin: const EdgeInsets.all(100),
            clipBehavior: Clip.none,
          ),
        ),
      ),
    );
  }
}
