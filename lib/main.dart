import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const EcoLinkApp());
}

class EcoLinkApp extends StatelessWidget {
  const EcoLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoLink',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: AppRoutes.main,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
