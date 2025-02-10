# Remote Config Feature Manager for Flutter

[![License: MIT](https://img.shields.io/badge/Licence-MIT-success.svg)]

Feature manager allows you to hide some unfinished/secret feature from your users, or experiments, that can be managed
from remote data source or local settings.

If you need only local feature toggles or preferences use [Feature Manager](https://pub.dev/packages/feature_manager)

![Example 01](doc/feature-manager-1.png) ![Example 02](doc/feature-manager-2.png)

## Getting Started

- [Installation](#installation)
- [Basic Usage](#basic-usage)
- If you want to use A/B testing or feature toggling with Firebase Remote Config use [Remote Config Feature Manager](https://google.com)

## Installation

Add

```yaml
dependencies:
  remote_config_feature_manager: ^latest_version

dev_dependencies:
  build_runner:
  feature_manager_generator: ^latest_version
```

to your `pubspec.yaml`, and run

```bash
flutter packages get
```

in your project's root directory.

### Setup Firebase Remote Config in your project.

To get started with Firebase Remote Config for Flutter, please [see the documentation](https://firebase.flutter.dev/docs/remote-config/overview) available at https://firebase.flutter.dev

### Basic Usage

#### Creating Features with Code Generation

Starting from version 3.0.0, `feature_manager` supports code generation to simplify feature creation and management.

#### Steps to Use Code Generation:

1. **Add Annotations to Your Features**

Create a Dart file (e.g., app_features.dart) and define your features using the provided annotations:

```dart
import 'package:feature_manager/annotations.dart';
import 'package:feature_manager/feature.dart';
import 'package:feature_manager/feature_manager.dart';

part 'features.g.dart';

@FeatureManagerInit()
class AppFeatures {
  AppFeatures({
    required this.textFeature,
    required this.booleanFeature,
    required this.doubleFeature,
    required this.integerFeature,
    required this.jsonFeature,
  });

  factory AppFeatures.instance() => _$AppFeatures();

  @FeatureOptions(
    key: 'dev-prefs-text-pref',
    remoteSourceKey: 'REMOTE-KEY-dev-prefs-text-pref',
    title: 'Text pref',
    description: 'This is text preference',
    defaultValue: 'Some default text',
  )
  final TextFeature textFeature;

  @FeatureOptions(
    key: 'dev-prefs-bool-pref',
    title: 'Toggle pref',
    description: 'This is toggle preference',
    defaultValue: false,
  )
  final BooleanFeature booleanFeature;

  @FeatureOptions(
    key: 'dev-prefs-double-pref',
    title: 'Number double pref',
    description: 'This is number double preference',
    defaultValue: 2.2,
  )
  final DoubleFeature doubleFeature;

  @FeatureOptions(
    key: 'dev-prefs-integer-pref',
    title: 'Number integer pref',
    description: 'This is number integer preference',
    defaultValue: 1,
  )
  final IntegerFeature integerFeature;

  @FeatureOptions(
    key: 'dev-prefs-json-pref',
    title: 'Json pref',
    description: 'This is json preference',
    defaultValue: {"value": "Json default value"},
  )
  final JsonFeature jsonFeature;
}
```

- **Annotations**: Use the `@FeatureManagerInit()` annotation on the AppFeatures class to indicate that code should be generated.
- **Feature Fields**: Annotate each feature field with `@FeatureOptions()` and provide the necessary parameters.
- **Factory Constructor**: The factory AppFeatures.instance() returns an instance of the generated class \_$AppFeatures().
- **Part Directive**: The part `'features.g.dart'`; directive tells Dart where to find the generated code.

2. Run the Code Generator

Execute the following command to generate the feature classes:

```dart
flutter packages pub run build_runner build
```

3. Use the Generated Features

Import the generated file and use the features in your code:

```dart
import 'features.dart';
// The generated part file is automatically included due to the 'part' directive.

void main() {
  final appFeatures = AppFeatures.instance();

  // Access individual features
  final textValue = appFeatures.textFeature.value;
  final isEnabled = appFeatures.booleanFeature.isEnabled;

  // Access all features using the extension
  for (final feature in appFeatures.values) {
    print('Feature key: ${feature.key}');
  }
}
```

- **Accessing Features**: You can access each feature via the instance of AppFeatures.
- **Using the Extension**: An extension AppFeaturesExt is generated to provide a values getter, which returns a list of all features.

### Activate feature manager

To fetch and active feature values use **activate** function. You should call `RemoteConfigFeatureManager.getInstance()` function to initialize RemoteConfigFeatureManager instance with its dependencies. After that you can use `RemoteConfigFeatureManager.instance` all over the app.

```dart
...
final featureManager =
      await RemoteConfigFeatureManager.getInstance();

await featureManager.activate(
            Features.values,
            minimumFetchInterval: const Duration(
                  minutes: 5,
            ),
      );
...
```

If you want to initialize FirebaseRemoteConfig elsewhere, you can just use **refresh** function to map remote values to your features.

```dart
...
featureManager.refresh(Features.values);
...
```

#### Using Features

To check whether a feature is enabled using RemoteConfigFeatureManager, you can create an instance via dependency injection (e.g., Provider, GetIt) or directly:

```dart
import 'package:feature_manager/feature_manager.dart';

final featureManager = RemoteConfigFeatureManager.instance;

final appFeatures = AppFeatures.instance();

// Check if a feature is enabled
final isEnabled = featureManager.isEnabled(appFeatures.booleanFeature);
```

Alternatively, since each feature provides an isEnabled property, you can directly access it:

```dart
final isEnabled = featureManager.booleanFeature.isEnabled;
// OR
final isEnabled = appFeatures.booleanFeature.isEnabled;
```

#### Modify remote feature values in Firebase Console

![Example 01](doc/feature-manager-3.png)

#### Modify feature values in DEBUG (develop) mode

To do it, you can simply open DeveloperPreferences screen in any part of your app.
You should pass list of your features as parameter for this screen.

P.S. You should hide this button for production builds.

```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (BuildContext context) =>
      DeveloperPreferencesScreen(Features.values),
    ),
);
```

### Feature parameters

| Parameter                    |        Default        | Description                                                                                  |
| :--------------------------- | :-------------------: | :------------------------------------------------------------------------------------------- |
| **key** _String_             |       required        | This key will be used to store value in local storage.                                       |
| **type** _FeatureType_       | `FeatureType.feature` | It can be used to separate local features and experiments driven by some remote provider.    |
| **remoteSourceKey** _String_ |                       | Key from remote source.                                                                      |
| **description** _String_     |                       | Description that will be used inside Developer Preferences Screen.                           |
| **value** _Object?_          |         Null          | Stored value of the Feature. Will be fetched from local storage.                             |
| **defaultValue** _Object?_   |         Null          | Default value of the Feature. Will be returned by `FeatureManager` if stored value is `Null` |

```dart
enum FeatureType { feature, experiment }
```

```dart
enum FeatureValueType { text, toggle, doubleNumber, integerNumber, json }
```

## Contributions

Feel free to contact me (agetman@bedcode.dev) or create Pull Requests/Issues for this repository :)
