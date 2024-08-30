import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../save_note.dart';
import 'factories/gitlab_form_field_factory.dart';
import 'factories/note_form_input.dart';

class ConfirmDialog extends StatefulWidget {
  final NoteSender noteSender;
  final Uint8List imageData;
  const ConfirmDialog(this.noteSender, this.imageData, {super.key});

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  late List<NoteFormField> extraFormFields;
  late List<Widget> extraInputs;

  @override
  initState() {
    super.initState();
    extraFormFields = _buildNoteFormFields();
    extraInputs =
        extraFormFields.map((field) => field.builder(context)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  if (_isLoading)
                    AbsorbPointer(
                      absorbing: true,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                      ),
                    ),
                  Positioned.fill(
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                            pinned: true,
                            expandedHeight: size.height * 0.4,
                            flexibleSpace: FlexibleSpaceBar(
                              centerTitle: true,
                              title: Text(widget.noteSender.name),
                              background: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.memory(
                                  widget.imageData.buffer.asUint8List(),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            automaticallyImplyLeading: false,
                            leading: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 16, bottom: 8),
                            child: TextField(
                              controller: _messageController,
                              autocorrect: true,
                              minLines: 1,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: _getTitleText(),
                              ),
                              keyboardType: TextInputType.multiline,
                              enabled: !_isLoading,
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                child: extraInputs[index],
                              );
                            },
                            childCount: extraInputs.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Action buttons
            Column(
              children: [
                const Divider(height: 1, thickness: 1, color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ListenableBuilder(
                          listenable: _messageController,
                          builder: (BuildContext context, _) {
                            return FilledButton(
                              onPressed: (_isLoading ||
                                      _messageController.text.isEmpty)
                                  ? null
                                  : () async {
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      widget.noteSender
                                          .sendNote(
                                        imageData: widget.imageData.buffer
                                            .asUint8List(),
                                        context: context,
                                        message: _messageController.text,
                                        extras: _getExtraValues(),
                                      )
                                          .then((success) {
                                        if (!success || (success && !mounted)) {
                                          return;
                                        }

                                        Navigator.of(context).pop();
                                      }).whenComplete(() {
                                        if (!mounted) return;

                                        setState(() {
                                          _isLoading = false;
                                        });
                                      });
                                    },
                              child: const Text('Send Note'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _getTitleText() {
    switch (widget.noteSender.runtimeType) {
      case const (SlackNoteSender):
        return 'Enter a message';
      case const (GitlabNoteSender):
        return 'Enter the issue title';
      default:
        return 'Send note';
    }
  }

  List<NoteFormField> _buildNoteFormFields() {
    switch (widget.noteSender.runtimeType) {
      case const (GitlabNoteSender):
        return GitlabFormFieldFactory.getNoteFormFieldFromGilabExtras(
            (widget.noteSender as GitlabNoteSender).gitlabExtras);
      default:
        return <NoteFormField>[];
    }
  }

  Map<String, dynamic> _getExtraValues() {
    return Map.fromEntries(extraFormFields
        .where((extra) => extra.controller.text.isNotEmpty)
        .map((extra) {
      return MapEntry(
          extra.name,
          extra.type == int
              ? int.tryParse(extra.controller.text)
              : extra.controller.text);
    }));
  }
}
