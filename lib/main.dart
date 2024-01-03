import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:s_hub/firebase_options.dart';
import 'package:s_hub/models/event.dart';
import 'package:s_hub/models/user.dart';
import 'package:s_hub/routes/configurations.dart';
import 'package:s_hub/routes/router_notifier.dart';
import 'package:s_hub/utils/firebase/auth.dart';
import 'package:provider/provider.dart';

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
  final appRouter = MyAppRouter(RouterNotifier(AuthService().user));

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<SUser>(
          create: (_) => AuthService().user, 
          initialData: SUser(initializing: true),
        ),
        ChangeNotifierProvider<EventState>(
          create: (context) => EventState()
        ),
      ],
      child: MaterialApp.router(
        title: 'Schoolbook Hub',
        theme: ThemeData.dark(),
        routerConfig: appRouter.router,
      )
    );
  }
}
