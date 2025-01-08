import 'package:flutter/material.dart';
import 'package:remote_config_feature_manager/remote_config_feature_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'features.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final RemoteConfigFeatureManager featureManager =
      await RemoteConfigFeatureManager.getInstance();
  await featureManager.activate(
    Features.instance().values,
    minimumFetchInterval: const Duration(
      minutes: 5,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider.value(
          value: sharedPreferences,
        ),
        Provider.value(
          value: featureManager,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feature Manager Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final feature = context.read<RemoteConfigFeatureManager>().booleanFeature;
    final bool isEnabled = feature.isEnabled;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Manager Demo Application'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(
                text: 'Feature toggle ${feature.remoteSourceKey} >>> ',
                children: <InlineSpan>[
                  TextSpan(
                    text: isEnabled ? 'enabled' : 'disabled',
                    style: TextStyle(
                      color: isEnabled ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Open developer preferences'),
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        DeveloperPreferencesScreen(
                      featuresList: Features.instance().values,
                      sharedPreferences: context.read(),
                    ),
                  ),
                )
                    .then((value) {
                  setState(() {});
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
