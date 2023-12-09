import 'package:flutter/material.dart';
import 'package:s_hub/utils/firebase/auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String email = "";
  String password = "";

  void redirectToRegister(BuildContext context) {
    Navigator.pushNamed(context, "/register");
  }

  void signinUser() {
    AuthService().signInWithEmail(email, password)
    .then((user) {
      if (user != null) {
        Navigator.pushNamed(context, "/dashboard");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Text("Sign Up"),
              const SizedBox(height: 10.0),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => setState(() { email = value; }),
              ),
              TextField(
                obscureText: true,
                onChanged: (value) => setState(() { password = value; }),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(onPressed: signinUser, child: const Text("Sign In")),
              Row(
                children: [
                  const Text("already have an account? "),
                  TextButton(onPressed: () => redirectToRegister(context), child: const Text("register now"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}