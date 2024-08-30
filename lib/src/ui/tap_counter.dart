import 'dart:async';

import 'package:flutter/material.dart';

class TapCounter extends StatefulWidget {
  final int requiredTaps;
  final Duration interval;
  final VoidCallback onSuccess;
  final VoidCallback? onTap;
  final Widget child;

  const TapCounter({
    super.key,
    required this.requiredTaps,
    required this.onSuccess,
    required this.child,
    this.onTap,
    this.interval = const Duration(seconds: 1),
  });

  @override
  State<TapCounter> createState() => _TapCounterState();
}

class _TapCounterState extends State<TapCounter> {
  int _tapCount = 0;
  Timer? _timer;

  void _handleTap() {
    setState(() {
      _tapCount++;

      if (_tapCount >= widget.requiredTaps) {
        widget.onSuccess();
        _resetCounter();
      } else {
        _timer?.cancel();
        _timer = Timer(widget.interval, _resetCounter);
        widget.onTap?.call();
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _tapCount = 0;
      _timer?.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      child: IgnorePointer(
        ignoring: true,
        child: widget.child,
      ),
    );
  }
}
