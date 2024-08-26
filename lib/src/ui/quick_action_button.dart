import 'dart:async';

import 'package:flutter/material.dart';

import '../../save_note.dart';

class NoteQuickActionButton extends StatefulWidget {
  static OverlayEntry? overlayEntry;

  const NoteQuickActionButton({super.key});

  @override
  State<NoteQuickActionButton> createState() => _NoteQuickActionButtonState();

  static void show(BuildContext context) {
    overlayEntry?.remove();
    overlayEntry = null;

    OverlayState overlayState = Overlay.of(context);

    overlayEntry = OverlayEntry(
      builder: (context) => const NoteQuickActionButton(),
    );

    overlayState.insert(NoteQuickActionButton.overlayEntry!);
  }
}

class _NoteQuickActionButtonState extends State<NoteQuickActionButton> {
  bool _isVisible = true;
  late Offset position = const Offset(16, kToolbarHeight);
  Timer? _timer;
  final _mixOpacity = 0.4;
  final _maxOpacity = 1.0;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startInactivityTimer();
  }

  void _startInactivityTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _opacity = _mixOpacity;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position += details.delta;
            _opacity = _maxOpacity;
          });
          _startInactivityTimer();
        },
        onLongPress: () {
          remove();
        },
        onTap: () {
          setState(() {
            _opacity = _maxOpacity;
          });
          _startInactivityTimer();
          removeAndOpenEditor(context);
        },
        child: Visibility(
          visible: _isVisible,
          child: Opacity(
            opacity: _opacity,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt_rounded, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void remove() {
    NoteQuickActionButton.overlayEntry?.remove();
    NoteQuickActionButton.overlayEntry = null;
  }

  void removeAndOpenEditor(BuildContext context) {
    setState(() {
      _isVisible = false;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      AppNoteController().createNote(context);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
