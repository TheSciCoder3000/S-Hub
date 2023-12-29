import 'package:flutter/material.dart';
import 'package:s_hub/models/user.dart';
import 'package:s_hub/screens/auth/auth_field.dart';
import 'package:s_hub/utils/firebase/auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String email = "";
  String password = "";
  String? errorEmail;
  String? errorPass;
  bool signingIn = false;

  void redirectToRegister(BuildContext context) {
    Navigator.pushNamed(context, "/register");
  }

  void signinUser(VoidCallback navigateFunc) async {
    setState(() {
      errorEmail = null;
      errorPass = null;
      signingIn = true;
    });
    try {
      SUser? user = await AuthService().signInWithEmail(email, password);
      if (user != null) {
        navigateFunc();
      } else {
        setState(() { signingIn = false; });
      }
    } catch (e) {
      setState(() {
        if (e.toString().contains("The email address is badly formatted")) {
          errorEmail = "The email address is badly formatted";
        } else {
          errorEmail = null;
        }

        if (e.toString().contains("credential is incorrect")) {
          errorPass = "Wrong password";
        } else {
          errorPass = null;
        }

        signingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Color(0xff1a1b1b), Color(0xFF1F3221)],
              )
            )
          ),
          const Positioned(
            bottom: 0,
            height: 270,
            child: Image(
              image: AssetImage("assets/waves.png"),
            ),
          ),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: width,
                minHeight: height
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 180,
                            child: Image(
                              image: AssetImage("assets/logo.png"),
                            ),
                          ),
                          const SizedBox(height: 50.0),
                          AuthField(
                            hintText: "Email",
                            onChange: (value) => setState(() { email = value; }),
                            errorMsg: errorEmail,
                          ),
                          AuthField(
                            hintText: "password",
                            onChange: (value) => setState(() { password = value; }),
                            errorMsg: errorPass,
                            obscureText: true,
                            icon: Icons.key,
                          ),
                          const SizedBox(height: 40.0),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft, end: Alignment.centerRight,
                                colors: [Color.fromARGB(255, 13, 228, 109), Color.fromARGB(255, 6, 214, 169)],
                              ),
                              borderRadius: BorderRadius.circular(30.0)
                            ),
                            child: ElevatedButton(
                              onPressed: signingIn ? null : () => signinUser(() {
                                Navigator.pushNamed(context, "/dashboard");
                              }),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)
                                ),
                                minimumSize: const Size(double.infinity, 45.0)
                              ),
                              child: const Text("Sign In"),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("don't have an account? "),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color.fromARGB(255, 0, 242, 206)
                            ),
                            onPressed: () => redirectToRegister(context), 
                            child: const Text("register now")
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
