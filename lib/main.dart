import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ombre_task/routes.dart';
import 'package:ombre_task/screens/onboarding_screens/login_screen.dart';

Future<void> main() async{
    WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: routeLinks,
      debugShowCheckedModeBanner: false,
    );
  }
}
