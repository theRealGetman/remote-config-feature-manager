// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'features.dart';

// **************************************************************************
// FeatureGenerator
// **************************************************************************

class _$Features implements Features {
  factory _$Features() {
    return _instance;
  }

  static final _$Features _instance = _$Features._internal();

  _$Features._internal()
      : textFeature = TextFeature(
          key: 'dev-prefs-text-pref',
          remoteSourceKey: 'REMOTE-KEY-dev-prefs-text-pref',
          title: 'Text pref',
          description: 'This is text preference',
          defaultValue: 'Some default text',
          type: FeatureType.feature,
        ),
        booleanFeature = BooleanFeature(
          key: 'dev-prefs-bool-pref',
          remoteSourceKey: 'remote_prefs_bool_pref',
          title: 'Toggle pref',
          description: 'This is toggle preference',
          defaultValue: false,
          type: FeatureType.feature,
        ),
        doubleFeature = DoubleFeature(
          key: 'dev-prefs-double-pref',
          remoteSourceKey: '',
          title: 'Number double pref',
          description: 'This is number double preference',
          defaultValue: 2.2,
          type: FeatureType.feature,
        ),
        integerFeature = IntegerFeature(
          key: 'dev-prefs-integer-pref',
          remoteSourceKey: '',
          title: 'Number integer pref',
          description: 'This is number integer preference',
          defaultValue: 1,
          type: FeatureType.feature,
        ),
        jsonFeature = JsonFeature(
          key: 'dev-prefs-json-pref',
          remoteSourceKey: '',
          title: 'Json pref',
          description: 'This is json preference',
          defaultValue: '{value: \'Json default value\'}',
          type: FeatureType.feature,
        ),
        nullableTextFeature = TextFeature(
          key: 'dev-prefs-text-pref',
          remoteSourceKey: '',
          title: 'Text pref',
          description: 'This is text preference',
          defaultValue: null,
          type: FeatureType.feature,
        );
  @override
  final TextFeature textFeature;
  @override
  final BooleanFeature booleanFeature;
  @override
  final DoubleFeature doubleFeature;
  @override
  final IntegerFeature integerFeature;
  @override
  final JsonFeature jsonFeature;
  @override
  final TextFeature nullableTextFeature;
}

extension FeaturesExt on Features {
  List<Feature> get values => [
        textFeature,
        booleanFeature,
        doubleFeature,
        integerFeature,
        jsonFeature,
        nullableTextFeature,
      ];
}

extension FeatureManagerExt on FeatureManager {
  TextFeature get textFeature => _$Features().textFeature;
  BooleanFeature get booleanFeature => _$Features().booleanFeature;
  DoubleFeature get doubleFeature => _$Features().doubleFeature;
  IntegerFeature get integerFeature => _$Features().integerFeature;
  JsonFeature get jsonFeature => _$Features().jsonFeature;
  TextFeature get nullableTextFeature => _$Features().nullableTextFeature;
}
