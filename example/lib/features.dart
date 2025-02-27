import 'package:remote_config_feature_manager/remote_config_feature_manager.dart';

part 'features.g.dart';

@FeatureManagerInit()
class Features {
  Features({
    required this.textFeature,
    required this.booleanFeature,
    required this.doubleFeature,
    required this.integerFeature,
    required this.jsonFeature,
    required this.nullableTextFeature,
  });

  factory Features.instance() => _$Features();

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
    remoteSourceKey: 'remote_prefs_bool_pref',
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
    defaultValue: {'value': 'Json default value'},
  )
  final JsonFeature jsonFeature;

  @FeatureOptions(
    key: 'dev-prefs-text-pref',
    title: 'Text pref',
    description: 'This is text preference',
  )
  final TextFeature nullableTextFeature;
}
