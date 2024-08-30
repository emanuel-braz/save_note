import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

abstract class NoteSender {
  final String id;
  final String? icon;
  final String name;
  final void Function()? onSuccess;
  final void Function(dynamic error)? onError;
  final Map<String, dynamic>? defaultExtras;

  NoteSender({
    required this.name,
    this.icon,
    this.onSuccess,
    this.onError,
    this.defaultExtras,
  }) : id = Random().nextInt(100000).toString();

  /// Sends a note
  Future<bool> sendNote({
    required Uint8List imageData,
    required BuildContext context,
    String message = '',
    Map<String, dynamic>? extras,
  });
}
