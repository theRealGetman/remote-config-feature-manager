import 'package:remote_config_feature_manager/remote_config_feature_manager.dart';

class Features {
  static const Feature textFeature = Feature(
    key: 'dev-prefs-text-pref',
    remoteSourceKey: 'remote_prefs_text_pref',
    title: 'Text pref',
    description: 'This is text preference',
    defaultValue: '',
    valueType: FeatureValueType.text,
  );

  static const Feature booleanFeature = Feature(
    key: 'dev-prefs-bool-pref',
    remoteSourceKey: 'remote_prefs_bool_pref',
    title: 'Toggle pref',
    description: 'This is toggle preference',
    defaultValue: false,
    valueType: FeatureValueType.toggle,
  );

  static const Feature doubleFeature = Feature(
    key: 'dev-prefs-double-pref',
    remoteSourceKey: 'remote_prefs_double_pref',
    title: 'Number double pref',
    description: 'This is number double preference',
    defaultValue: 0.0,
    valueType: FeatureValueType.doubleNumber,
  );

  static const Feature integerFeature = Feature(
    key: 'dev-prefs-integer-pref',
    remoteSourceKey: 'remote_prefs_integer_pref',
    title: 'Number integer pref',
    description: 'This is number integer preference',
    defaultValue: 0,
    valueType: FeatureValueType.integerNumber,
  );

  static const Feature jsonFeature = Feature(
    key: 'dev-prefs-json-pref',
    remoteSourceKey: 'remote_prefs_json_pref',
    title: 'Json pref',
    description: 'This is json preference',
    defaultValue: """{"value": "Json default value"}""",
    valueType: FeatureValueType.json,
  );

  static const List<Feature> values = <Feature>[
    Features.textFeature,
    Features.booleanFeature,
    Features.doubleFeature,
    Features.integerFeature,
    Features.jsonFeature,
  ];
}
