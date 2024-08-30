import 'package:flutter/material.dart';

class NoteFormField {
  final String name;
  final Type type;
  final TextEditingController controller;
  final String? hint;
  final Widget Function(BuildContext context, TextEditingController controller)? customBuilder;

  NoteFormField({
    required this.name,
    required this.type,
    required this.controller,
    this.hint,
    this.customBuilder,
  });

  Widget builder(BuildContext context) {
    if (customBuilder != null) return customBuilder!(context, controller);

    return TextFormField(
      controller: controller,
      keyboardType: type == int ? TextInputType.number : TextInputType.multiline,
      maxLines: name == 'description' ? 5 : 2,
      minLines: name == 'description' ? 2 : 1,
      decoration: InputDecoration(
        labelText: name,
        suffixIcon: hint == null
            ? null
            : IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(name),
                        content: Text(hint!),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
