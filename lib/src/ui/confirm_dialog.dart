import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../save_note.dart';

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.all(12),
      title: RichText(
        text: TextSpan(
          text: 'Send note to ',
          style: Theme.of(context).textTheme.bodyLarge,
          children: [
            TextSpan(
              text: widget.noteSender.channelName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      content: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height / 2,
                      minHeight: 100,
                    ),
                    child: Image.memory(
                      widget.imageData.buffer.asUint8List(),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: _messageController,
                autocorrect: true,
                autofocus: true,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Enter a note message',
                ),
                keyboardType: TextInputType.multiline,
                enabled: !_isLoading,
              ),
            ],
          ),
          if (_isLoading)
            Container(
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
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        if (!_isLoading)
          FilledButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });

              widget.noteSender
                  .sendNote(
                imageData: widget.imageData.buffer.asUint8List(),
                context: context,
                message: _messageController.text,
              )
                  .then((success) {
                if (!success || (success && !mounted)) return;

                Navigator.of(context).pop();
              }).whenComplete(() {
                if (!mounted) return;

                setState(() {
                  _isLoading = false;
                });
              });
            },
            child: const Text('Send Note'),
          ),
      ],
    );
  }
}
