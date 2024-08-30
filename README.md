# Save Note
[![Pub Version](https://img.shields.io/pub/v/save_note?color=%2302569B&label=pub&logo=flutter)](https://pub.dev/packages/save_note) ![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)
## Getting Started

### Features
* In the screenshot editor, you can add notes, draw on the screenshot, and send it to Slack and to other services (**see CustomNoteSender example**).
* Activate a quick action button that allows you to save the screenshot of the current screen and send it to a Slack channel with a note.
* Long press the quick action button to dismiss it.
* Tap the quick action button to take a screenshot and open the screenshot editor.
* Drag the quick action button to move it around the screen.

```dart
NoteQuickActionButton.show(context);
```

<p align="center">
  <img src="https://github.com/user-attachments/assets/cc3b93ff-0e64-43e5-8300-909e0669caf2" alt="First Image" width="200"/>
  <img src="https://github.com/user-attachments/assets/957b9a5f-4df6-47a2-ac31-9cfd2aaefffb" alt="Second Image" width="200"/>
  <img src="https://github.com/user-attachments/assets/099bdfab-d274-479d-8c2c-ad6bab506117" alt="Third Image" width="200"/>
</p>

### Configuration
```dart
@override
  initState() {
    super.initState();

    // IMPORTANT: Add the NoteSender to the controller
    // This is a one-time setup for the app, and they will be available on Screenshot Editor.

    // As an example, we are adding a SlackNoteSender and a [CustomNoteSender] that I created for this example.
    AppNoteController().addNoteSenders([
      SlackNoteSender(
        token: const String.fromEnvironment('SLACK_API_TOKEN'), // Slack API token (xoxb-...) - You can get it from https://api.slack.com/apps
        channelId: const String.fromEnvironment('SLACK_CHANNEL_ID_QA'), // Slack channel ID (public or private)
        name: 'QA Team Notes',
        // Optional
        onSuccess: () {
          debugPrint('✨ Note sent to Slack!');
        },
        // Optional
        onError: (error) {
          debugPrint('🚫 Error sending note to Slack: $error');
        },
      ),
      GitlabNoteSender(
        projectId: const String.fromEnvironment('GITLAB_PROJECT_ID'),
        token: const String.fromEnvironment('GITLAB_TOKEN'),
        name: 'Gitlab Issues',
        gitlabExtras: GitlabExtras(labels: 'my_notes'), // Initial value - Comma separated labels
        onSuccess: () {
          debugPrint('✨ Note sent to Gitlab!');
        },
        onError: (error) {
          debugPrint('🚫 Error sending note to Gitlab: $error');
        },
      ),
      CustomNoteSender(), // CustomNoteSender is a custom implementation of NoteSender that I created for this example (see example project)
    ]);
  }
```

#### Configure a VSCode Launcher with --dart-define
> **Note:** You can also use the `.env` file to store the environment variables in development mode, remote config, or any other aproach that you prefer. For this example, I'm using the `launch.json` file and dart-define.
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": [
        "--dart-define=SLACK_API_TOKEN=xoxb-...",
        "--dart-define=SLACK_CHANNEL_QA_TEAM=..."
        "--dart-define=SLACK_CHANNEL_DEV_TEAM=..."
        "--dart-define=SLACK_CHANNEL_STAKEHOLDERS=..."
      ]
    }
  ]
}
```


### Android

For Android platform, you need to add the following permissions into the **AndroidManifest.xml** file.

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

And don't forget to add the following property to the `application` tag in the **AndroidManifest.xml** file.

```
android:requestLegacyExternalStorage="true"
```

### iOS

For iOS platform, you need to add the following permissions into the **Info.plist** file.

```
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Take screenshots and save it</string>
```

### Usage Example

For usage examples, please see the **example** project.

### Built-in Widgets
#### `ThreeFingerTapDetector`
```dart
MaterialApp(
  home: ThreeFingerTapDetector(
    child: Center(
      child: Text(
        'Tap with three fingers to show the screenshot editor.',
        style: TextStyle(color: Colors.white),
      ),
    ),
  ),
),
```

#### `TapCounter`
```dart
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
```

### Important Notes

Please note that this plugin does not handle the runtime permission checking process.
Therefore, make sure you check the runtime permission first using the `permission_handler` plugin.

<a href="https://www.buymeacoffee.com/emanuelbraz" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 50px !important;width: 217px !important;" ></a>
