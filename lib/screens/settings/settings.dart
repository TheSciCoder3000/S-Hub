import 'package:flutter/material.dart';
import 'package:s_hub/utils/firebase/auth.dart';

class AppSettigs extends StatefulWidget {
  const AppSettigs({super.key});

  @override
  State<AppSettigs> createState() => _AppSettigsState();
}

class _AppSettigsState extends State<AppSettigs> {
  @override
  Widget build(BuildContext context) {
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
                AuthService().signOut();
              },
            )
          ],
        ),
      ),
    );
  }
}