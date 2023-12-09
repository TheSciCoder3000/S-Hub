
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:s_hub/firebase_options.dart';
import 'package:s_hub/ical_viewer.dart';
import 'package:s_hub/screens/auth/signin.dart';
import 'package:s_hub/screens/auth/register.dart';
import 'package:s_hub/screens/dashboard/index.dart';
import 'package:s_hub/utils/firebase/auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: '/auth',
        routes: {
          '/auth': (context) => const AuthPage(),    // edit this to point to a page
          '/register': (context) => const RegisterPage(),
          '/dashboard': (context) => const Dashboard()
        },
      ),
    );
  }
}



