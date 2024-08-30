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
        name: 'QA Team Notes',
        userName: 'App Awesome',
        defaultExtras: {
          'text': 'abc',
          'number': 1,
        },
        onSuccess: () {
          debugPrint('✨ Note sent to Slack!');
        },
        onError: (error) {
          debugPrint('🚫 Error sending note to Slack: $error');
        },
      ),
      GitlabNoteSender(
        projectId: const String.fromEnvironment('GITLAB_PROJECT_ID'),
        token: const String.fromEnvironment('GITLAB_TOKEN'),
        name: 'Gitlab Issues',
        gitlabExtras: GitlabExtras(labels: 'bug'), // initial value - Comma separated labels
        onSuccess: () {
          debugPrint('✨ Note sent to Gitlab!');
        },
        onError: (error) {
          debugPrint('🚫 Error sending note to Gitlab: $error');
        },
      ),
      CustomNoteSender(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ThreeFingerTapDetector(
        child: Scaffold(
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
                  TapCounter(
                    requiredTaps: 5,
                    onSuccess: () {
                      NoteQuickActionButton.show(context);
                    },
                    child: OutlinedButton(
                      onPressed: () async {},
                      child: const Text('Tap 5 times'),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

// Create your own NoteSender implementation if you want to send notes to a custom service
// PRs are welcome to add more NoteSender implementations to the package [eg. Discord, Telegram, Github, etc.]
class CustomNoteSender extends NoteSender {
  CustomNoteSender() : super(name: 'Custom Note Sender');

  @override
  Future<bool> sendNote(
      {required Uint8List imageData,
      required BuildContext context,
      Map<String, dynamic>? extras,
      String message = ''}) async {
    debugPrint('[CustomNoteSender]\n\nMessage: $message\nImage length:${imageData.length}\n\n');
    return true;
  }
}
