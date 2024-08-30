import 'package:flutter/material.dart';

import '../../save_note.dart';

class ThreeFingerTapDetector extends StatefulWidget {
  final Widget child;
  final bool detecting;

  const ThreeFingerTapDetector(
      {super.key, required this.child, this.detecting = true});

  @override
  State<ThreeFingerTapDetector> createState() => _ThreeFingerTapDetectorState();
}

class _ThreeFingerTapDetectorState extends State<ThreeFingerTapDetector> {
  final Set<int> _activePointers = <int>{};

  @override
  Widget build(BuildContext context) {
    return widget.detecting
        ? Listener(
            onPointerDown: _handlePointerDown,
            onPointerUp: _handlePointerUp,
            onPointerCancel: _handlePointerCancel,
            child: widget.child,
          )
        : widget.child;
  }

  void _handlePointerDown(PointerDownEvent event) {
    setState(() {
      _activePointers.add(event.pointer);
      if (_activePointers.length == 3) {
        _onThreeFingerTap();
      }
    });
  }

  void _handlePointerUp(PointerUpEvent event) {
    setState(() {
      _activePointers.remove(event.pointer);
    });
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    setState(() {
      _activePointers.remove(event.pointer);
    });
  }

  void _onThreeFingerTap() {
    AppNoteController()
        .createNote(context, showQuickActionButtonOnDispose: false);
  }
}
