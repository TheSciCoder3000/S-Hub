import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:s_hub/models/event.dart';
import 'package:s_hub/models/user.dart';
import 'package:s_hub/utils/firebase/auth.dart';
import 'package:s_hub/utils/firebase/db.dart';

class AppSettigs extends StatefulWidget {
  const AppSettigs({super.key});

  @override
  State<AppSettigs> createState() => _AppSettigsState();
}

class _AppSettigsState extends State<AppSettigs> {
  @override
  Widget build(BuildContext context) {
    String? uid = context.select<SUser, String?>((model) => model.uid);

    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60.0),
            const Padding(
              padding: EdgeInsets.all(25.0),
              child: Text("Settings", 
                style: TextStyle(
                  fontSize: 50.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            ListTile(
              title: const Text("Sign Out", style: TextStyle(color: Colors.white)),
              leading: const Icon(Icons.logout, color: Colors.white),
              tileColor: const Color.fromARGB(255, 28, 28, 28),
              onTap: () {
                final eventState = context.read<EventState>();
                eventState.clear();
                AuthService().signOut();
              },
            ),
            ListTile(
              title: const Text("Sync Data", style: TextStyle(color: Colors.white)),
              leading: const Icon(Icons.sync, color: Colors.white),
              subtitle: const Text("Update Online Database with ICalLink", style: TextStyle(color: Color.fromARGB(255, 130, 130, 130)),),
              tileColor: const Color.fromARGB(255, 28, 28, 28),
              onTap: () {
                if (uid != null) {
                  FirestoreService(uid: uid).syncEvents();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}