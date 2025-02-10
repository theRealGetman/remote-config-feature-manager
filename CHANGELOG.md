## 3.0.4

### Refactored Feature Type Handling:

- Removed FeatureValueType and replaced it with generic type inference for Feature<T>.
- The generator now detects the correct feature type (`BooleanFeature`, `TextFeature`, etc.) based on the generic type (`Feature<bool>`, `Feature<String>,` etc.).
- Added better logging for invalid feature fields.

## 3.0.0

- Updated to the latest `FeatureManager` changes

## 2.0.0

- Updated to the latest `FeatureManager` changes
- Added documentation
- Removed specified dependencies versions

## 1.0.2

- Upgraded Dart and Flutter versions

## 1.0.1

- Updated Readme

## 1.0.0

- Initial release
