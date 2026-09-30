import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/root_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MummasTailorHubApp());
}

class MummasTailorHubApp extends StatelessWidget {
  const MummasTailorHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mumma's Tailor Hub",
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      darkTheme: buildAppDarkTheme(),
      themeMode: ThemeMode.system,
      home: const RootShell(),
    );
  }
}
