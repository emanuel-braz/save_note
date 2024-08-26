import 'package:flutter/material.dart';

class NoteSenderIcon extends StatelessWidget {
  final String? icon;
  const NoteSenderIcon(this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    final icon = this.icon ?? 'assets/default_icon.png';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 24,
        height: 24,
        child: icon.startsWith('assets/')
            ? Image.asset(
                icon,
                width: 24,
                height: 24,
                package: 'save_note',
              )
            : Image.network(
                icon,
                width: 24,
                height: 24,
              ),
      ),
    );
  }
}
