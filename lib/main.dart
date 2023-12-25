
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:s_hub/firebase_options.dart';
import 'package:s_hub/screens/auth/signin.dart';
import 'package:s_hub/screens/auth/register.dart';
import 'package:s_hub/screens/wrapper.dart';
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
        initialRoute: '/',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 20, 20, 20),
        ),
        routes: {
          '/auth': (context) => const AuthPage(),
          '/register': (context) => const RegisterPage(),
          '/': (context) => const MainWrapper()
        },
      ),
    );
  }
}
