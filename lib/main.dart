import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memory_app/verouillage_screen.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MaterialApp(
        home: MyApp(),
      ),
    ),
  ));

}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool isLocked = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed ) {
      print("CONTEXT :$context");
      final appState = Provider.of<AppState>(context, listen: false);
      if (appState.isLocked) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LockScreenPage(),
          ),
              (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return  const LockScreenPage();
  }
}

