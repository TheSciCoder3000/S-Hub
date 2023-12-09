import 'package:flutter/material.dart';
import 'package:s_hub/utils/firebase/auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String email = "";
  String password = "";
  String icalLink = "";

  void redirectToSignin(BuildContext context) {
    Navigator.pushNamed(context, "/auth");
  }

  void registerUser() {
    AuthService().registerWithEmail(email, password, icalLink)
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
              const Text("Register"),
              const SizedBox(height: 10.0),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => setState(() { email = value; }),
              ),
              TextField(
                obscureText: true,
                onChanged: (value) => setState(() { password = value; }),
              ),
              TextField(
                onChanged: (value) => setState(() { icalLink = value; }),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(onPressed: registerUser, child: const Text("Sign Up")),
              Row(
                children: [
                  const Text("already have an account? "),
                  TextButton(onPressed: () => redirectToSignin(context), child: const Text("Sign in now"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}