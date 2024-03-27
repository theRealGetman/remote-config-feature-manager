import 'package:feature_manager/feature_manager.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A class that manages remote configuration features using Firebase Remote Config.
///
/// This class implements the FeatureManager interface and provides functionality
/// to interact with Firebase Remote Config for feature management. It initializes
/// the FirebaseRemoteConfig, SharedPreferences, and FeatureManager instances upon
/// creation. The class enables activation of remote configuration with a list of
/// features, refreshing the features based on the remote configuration, and providing
/// methods to retrieve feature values such as strings, JSON, integers, and booleans.
class RemoteConfigFeatureManager implements FeatureManager {
  RemoteConfigFeatureManager._(
    this._firebaseRemoteConfig,
    this._sharedPreferences,
    this._featureManager,
  );

  static RemoteConfigFeatureManager? _instance;
  final FirebaseRemoteConfig _firebaseRemoteConfig;
  final SharedPreferences _sharedPreferences;
  final FeatureManager _featureManager;

  /// Retrieves the instance of the RemoteConfigFeatureManager class.
  ///
  /// If the instance has not been created yet, it initializes it by
  /// creating a new instance of FirebaseRemoteConfig, SharedPreferences,
  /// and FeatureManager. The created instance is then stored in the
  /// `_instance` variable for future use.
  ///
  /// Returns the instance of the RemoteConfigFeatureManager class.
  static Future<RemoteConfigFeatureManager> getInstance() async {
    if (_instance == null) {
      final firebaseRemoteConfig = FirebaseRemoteConfig.instance;
      final sharedPreferences = await SharedPreferences.getInstance();
      final featureManager = await FeatureManager.getInstance();

      _instance = RemoteConfigFeatureManager._(
        firebaseRemoteConfig,
        sharedPreferences,
        featureManager,
      );
    }
    return _instance!;
  }

  /// Activates the remote configuration with the provided list of features.
  /// Optional parameters:
  /// - fetchTimeout: Timeout for fetching the remote configuration, default is 1 minute.
  /// - minimumFetchInterval: Minimum interval between fetching the remote configuration, default is 1 hour.
  /// - defaultValues: Default values for the remote configuration, default is an empty map.
  Future<void> activate(
    List<Feature> features, {
    Duration fetchTimeout = const Duration(minutes: 1),
    Duration minimumFetchInterval = const Duration(hours: 1),
    Map<String, dynamic> defaultValues = const <String, dynamic>{},
  }) async {
    try {
      await _firebaseRemoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: fetchTimeout,
          minimumFetchInterval: minimumFetchInterval,
        ),
      );
      await _firebaseRemoteConfig.setDefaults(defaultValues);
      await _firebaseRemoteConfig.fetchAndActivate();
      refresh(features);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('>>> RemoteConfig: fetch throttled: $e');
      }
    } catch (e) {
      if (kDebugMode) {
        print('>>> RemoteConfig: Unable to fetch remote config. $e');
      }
    }
  }

  /// Refreshes the features in the remote configuration with the values from the shared preferences.
  ///
  /// The [features] parameter is a list of [Feature] objects that represent the features to be refreshed.
  /// Each [Feature] object contains the key, value type, and remote source key.
  ///
  /// This function retrieves all the remote configurations from the Firebase remote config and iterates
  /// over the [features] list. If a remote configuration exists for a feature's remote source key,
  /// the function retrieves the corresponding value and updates the shared preferences accordingly.
  /// The shared preferences are updated based on the feature's value type.
  ///
  /// The function supports the following value types:
  /// - [FeatureValueType.text]: The value is stored as a string in the shared preferences.
  /// - [FeatureValueType.json]: The value is stored as a string in the shared preferences.
  /// - [FeatureValueType.toggle]: The value is stored as a boolean in the shared preferences.
  /// - [FeatureValueType.doubleNumber]: The value is stored as a double in the shared preferences.
  /// - [FeatureValueType.integerNumber]: The value is stored as an integer in the shared preferences.
  ///
  /// After updating the shared preferences, the function reloads the shared preferences to ensure
  /// the changes are reflected.
  void refresh(List<Feature> features) {
    // Retrieve all remote configurations from the Firebase remote config
    final Map<String, RemoteConfigValue> remoteConfigs = _firebaseRemoteConfig.getAll();

    // Iterate over the features list
    for (Feature feature in features) {
      // Check if a remote configuration exists for the feature's remote source key
      if (remoteConfigs.containsKey(feature.remoteSourceKey)) {
        // Retrieve the remote configuration value
        final RemoteConfigValue remoteConfigValue =
            remoteConfigs[feature.remoteSourceKey]!;

        // Print the remote configuration value if in debug mode
        if (kDebugMode) {
          print(
              ">>> RemoteConfig: ${feature.remoteSourceKey} - ${remoteConfigValue.asString()}");
        }

        // Update the shared preferences based on the feature's value type
        switch (feature.valueType) {
          case FeatureValueType.text:
          case FeatureValueType.json:
            _sharedPreferences.setString(
              feature.key,
              remoteConfigValue.asString(),
            );
            break;
          case FeatureValueType.toggle:
            _sharedPreferences.setBool(
              feature.key,
              remoteConfigValue.asBool(),
            );
            break;
          case FeatureValueType.doubleNumber:
            _sharedPreferences.setDouble(
              feature.key,
              remoteConfigValue.asDouble(),
            );
            break;
          case FeatureValueType.integerNumber:
            _sharedPreferences.setInt(
              feature.key,
              remoteConfigValue.asInt(),
            );
            break;
        }
      }
    }

    // Reload the shared preferences to ensure the changes are reflected
    _sharedPreferences.reload();
  }

  /// Retrieves a double value associated with the given [feature].
  ///
  /// The [feature] parameter specifies the feature for which the double value is
  /// to be retrieved.
  ///
  /// Returns the double value associated with the given [feature], or null if
  /// no value is found.
  @override
  double? getDouble(Feature feature) => _featureManager.getDouble(feature);

  /// Retrieves an integer value associated with the given [feature] from the shared preferences.
  ///
  /// The [feature] parameter specifies the feature for which the integer value is to be retrieved.
  ///
  /// Returns the integer value associated with the [feature] key in the shared preferences, or null if the key is not found.
  @override
  int? getInt(Feature feature) => _featureManager.getInt(feature);

  /// Retrieves and decodes a JSON string from the provided Feature object, returning the decoded Map<String, dynamic> or null if the string is empty or null.
  ///
  /// The [feature] parameter specifies the feature for which the double value is
  /// to be retrieved.
  ///
  /// Returns the decoded Map<String, dynamic> if the JSON string is not empty or null; otherwise, returns null.
  @override
  Map<String, dynamic>? getJson(Feature feature) => _featureManager.getJson(feature);

  /// Retrieves a string value from the shared preferences based on the provided [feature] key.
  ///
  /// The [feature] parameter specifies the feature for which the string value is retrieved.
  ///
  /// Returns the string value associated with the [feature] key, or `null` if the key does not exist.
  @override
  String? getString(Feature feature) => _featureManager.getString(feature);

  /// Retrieves the value associated with the given [feature] from the shared preferences.
  ///
  /// The function first checks if there is a value stored for the given [feature] key in the shared preferences.
  /// If a value is found, it is returned. Otherwise, the default value of the [feature] is returned.
  ///
  /// Parameters:
  ///   - `feature`: The [Feature] object for which the value needs to be retrieved.
  ///
  /// Returns:
  ///   - The value associated with the [feature] key in the shared preferences, or the default value of the [feature] if no value is found.
  @override
  Object? getValue(Feature feature) => _featureManager.getValue(feature);

  /// Determines if the given [feature] is enabled.
  ///
  /// The function checks if the [feature]'s value type is [FeatureValueType.toggle].
  /// If it is, the function retrieves the boolean value associated with the [feature]'s key
  /// from the shared preferences. If the value is not found, it returns the default value
  /// of the [feature] if it is of type bool. If the default value is not available, it returns false.
  /// If the [feature]'s value type is not [FeatureValueType.toggle], the function returns false.
  ///
  /// Parameters:
  /// - `feature`: The [Feature] object to check.
  ///
  /// Returns:
  /// - `bool`: `true` if the [feature] is enabled, `false` otherwise.
  @override
  bool isEnabled(Feature feature) => _featureManager.isEnabled(feature);
}
