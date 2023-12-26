
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:s_hub/firebase_options.dart';
import 'package:s_hub/models/user.dart';
import 'package:s_hub/screens/Splash.dart';
import 'package:s_hub/screens/auth/signin.dart';
import 'package:s_hub/screens/wrapper.dart';
import 'package:s_hub/utils/firebase/auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool initializing = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 7), () {
      setState(() {
        initializing = false;
      });
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 20, 20, 20),
      ),
      home: StreamBuilder<SUser?>(
        stream: AuthService().user,
        builder: (context, snapshot) {
          if (!initializing) {
            if (snapshot.hasData) {
              return const MainWrapper();
            } else {
              return const AuthPage();
            }
          } else {
            return const Splash();
          }
        },
      ),
    );
  }
}
