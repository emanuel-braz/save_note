# Save Note

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