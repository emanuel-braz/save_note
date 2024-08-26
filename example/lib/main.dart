import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:save_note/save_note.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  initState() {
    super.initState();

    // IMPORTANT: Add the NoteSender to the controller
    // This is a one-time setup for the app

    // As an example, we are adding a SlackNoteSender and a [CustomNoteSender]
    AppNoteController().addNoteSenders([
      SlackNoteSender(
        token: const String.fromEnvironment('SLACK_API_TOKEN'),
        channelId: const String.fromEnvironment('SLACK_CHANNEL_ID_QA'),
        channelName: 'QA Team Notes',
        onSuccess: () {
          debugPrint('✨ Note sent to Slack!');
        },
        onError: (error) {
          debugPrint('🚫 Error sending note to Slack: $error');
        },
      ),
      CustomNoteSender(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(builder: (context) {
          return Container(
            color: Theme.of(context).primaryColor.withAlpha(80),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    NoteQuickActionButton.show(context);
                  },
                  child: const Text('Show Quick Action Button'),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// Create your own NoteSender implementation if you want to send notes to a custom service
// PRs are welcome to add more NoteSender implementations to the package [eg. Discord, Telegram, Github, etc.]
class CustomNoteSender extends NoteSender {
  CustomNoteSender() : super(channelName: 'Custom Note Sender');

  @override
  Future<bool> sendNote(
      {required Uint8List imageData,
      required BuildContext context,
      String message = ''}) async {
    debugPrint(
        '[CustomNoteSender]\n\nMessage: $message\nImage length:${imageData.length}\n\n');
    return true;
  }
}
