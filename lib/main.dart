
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:s_hub/firebase_options.dart';
import 'package:s_hub/models/event.dart';
import 'package:s_hub/models/user.dart';
import 'package:s_hub/screens/splash.dart';
import 'package:s_hub/screens/auth/signin.dart';
import 'package:s_hub/screens/wrapper.dart';
import 'package:s_hub/utils/firebase/auth.dart';
import 'package:provider/provider.dart';
import 'package:s_hub/utils/firebase/db.dart';

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
    Timer(const Duration(seconds: 10), () {
      setState(() {
        initializing = false;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schoolbook Hub',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 20, 20, 20),
      ),
      home: MultiProvider(
        providers: [
          StreamProvider<SUser>(
            create: (_) => AuthService().user, 
            initialData: SUser(initializing: true),
          ),
          ChangeNotifierProvider<EventState>(
            create: (context) => EventState()
          )
        ],
        child: StreamBuilder<SUser?>(
          stream: AuthService().user,
          builder: (context, snapshot) {
            String? userUid = context.watch<SUser>().uid;
            EventState eventState = context.watch<EventState>();

            if (!initializing) {
              if (snapshot.hasData) {
                if (userUid != null) {
                  if (!eventState.initializing) {
                    return const MainWrapper();
                  } else {
                    FirestoreService(uid: userUid).getAllEvents()
                    .then((eventList) {
                      eventState.parse(eventList);
                    });
                    return const Splash();
                  }
                } else {
                  return const AuthPage();
                }
              } else {
                return const Splash();
              }
            } else {
              return const Splash();
            }
          },
        )
      )
    );
  }
}