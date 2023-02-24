import 'package:feature_manager/feature_manager.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class RemoteConfigFeatureManager extends FeatureManager {
  RemoteConfigFeatureManager({
    required this.firebaseRemoteConfig,
    required super.sharedPreferences,
  });

  final FirebaseRemoteConfig firebaseRemoteConfig;

  Future<void> activate(
    List<Feature> features, {
    Duration fetchTimeout = const Duration(minutes: 1),
    Duration minimumFetchInterval = const Duration(hours: 1),
    Map<String, dynamic> defaultValues = const <String, dynamic>{},
  }) async {
    try {
      await firebaseRemoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: fetchTimeout,
          minimumFetchInterval: minimumFetchInterval,
        ),
      );
      await firebaseRemoteConfig.setDefaults(defaultValues);
      await firebaseRemoteConfig.fetchAndActivate();
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

  void refresh(List<Feature> features) {
    final Map<String, RemoteConfigValue> remoteConfigs =
        firebaseRemoteConfig.getAll();
    for (Feature feature in features) {
      if (remoteConfigs.containsKey(feature.remoteSourceKey)) {
        final RemoteConfigValue remoteConfigValue =
            remoteConfigs[feature.remoteSourceKey]!;
        if (kDebugMode) {
          print(
              ">>> RemoteConfig: ${feature.remoteSourceKey} - ${remoteConfigValue.asString()}");
        }
        switch (feature.valueType) {
          case FeatureValueType.text:
          case FeatureValueType.json:
            sharedPreferences.setString(
              feature.key,
              remoteConfigValue.asString(),
            );
            break;
          case FeatureValueType.toggle:
            sharedPreferences.setBool(
              feature.key,
              remoteConfigValue.asBool(),
            );
            break;
          case FeatureValueType.doubleNumber:
            sharedPreferences.setDouble(
              feature.key,
              remoteConfigValue.asDouble(),
            );
            break;
          case FeatureValueType.integerNumber:
            sharedPreferences.setInt(
              feature.key,
              remoteConfigValue.asInt(),
            );
            break;
        }
      }
    }
    sharedPreferences.reload();
  }
}
