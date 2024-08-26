# Save Note
[![Pub Version](https://img.shields.io/pub/v/save_note?color=%2302569B&label=pub&logo=flutter)](https://pub.dev/packages/save_note) ![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)
## Getting Started

### Features
* In the screenshot editor, you can add notes, draw on the screenshot, and send it to Slack and to other services (**see CustomNoteSender example**).
* Activate a quick action button that allows you to save the screenshot of the current screen and send it to a Slack channel with a note.
```dart
NoteQuickActionButton.show(context);
```

* Long press the quick action button to dismiss it.
* Tap the quick action button to take a screenshot and open the screenshot editor.
* Drag the quick action button to move it around the screen.

<p align="center">
  <img src="https://github.com/user-attachments/assets/b838e388-0277-44e0-b5e1-8ec7a5a8bc68" alt="First Image" width="200"/>
  <img src="https://github.com/user-attachments/assets/21794009-ed13-4e51-bd07-d07381c2e2a0" alt="Second Image" width="200"/>
  <img src="https://github.com/user-attachments/assets/6c1de0b5-9f28-4d24-95f3-e4611e95c2b3" alt="Third Image" width="200"/>
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
        channelName: 'QA Team Notes', // Slack channel name, it can be anything, it's just for display purposes
        // Optional
        onSuccess: () {
          debugPrint('✨ Note sent to Slack!');
        },
        // Optional
        onError: (error) {
          debugPrint('🚫 Error sending note to Slack: $error');
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

### Important Notes

Please note that this plugin does not handle the runtime permission checking process.
Therefore, make sure you check the runtime permission first using the `permission_handler` plugin.

<a href="https://www.buymeacoffee.com/emanuelbraz" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 50px !important;width: 217px !important;" ></a>
