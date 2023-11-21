
import 'package:flutter/material.dart';
import 'package:s_hub/ical_viewer.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '',
      routes: {
        '/': (context) => const ICalViewer()    // edit this to point to a page
      },
    );
  }
}



