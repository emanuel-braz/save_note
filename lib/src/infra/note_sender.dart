import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

abstract class NoteSender {
  final String id;
  final String? icon;
  final String channelName;
  final void Function()? onSuccess;
  final void Function(dynamic error)? onError;

  /// Sends a note
  Future<bool> sendNote({
    required Uint8List imageData,
    required BuildContext context,
    String message = '',
  });

  NoteSender({
    required this.channelName,
    this.icon,
    this.onSuccess,
    this.onError,
  }) : id = Random().nextInt(100000).toString();
}
