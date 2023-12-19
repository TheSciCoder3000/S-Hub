import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_hub/screens/auth/auth_field.dart';
import 'package:s_hub/screens/auth/custom_painter.dart';
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
  String? errorEmail;
  String? errorPass;
  bool registering = false;

  void redirectToSignin(BuildContext context) {
    Navigator.pushNamed(context, "/auth");
  }

  void registerUser() async {
    setState(() {
      errorEmail = null;
      registering = true;
    });
    try {
      User? user = await AuthService().registerWithEmail(email, password, icalLink);
      if (user != null) {
        Navigator.pushNamed(context, "/dashboard");
      } else {
        setState(() { registering = false; });
      }
    } catch (e) {
      print(e);
      setState(() {
        registering = false;
        if (e.toString().contains("The email address is badly formatted")) {
          errorEmail = "The email address is badly formatted";
        } else {
          errorEmail = null;
        }

        if (e.toString().contains("Password should be at least 6 characters")) {
          errorPass = "Password should be at least 6 characters";
        } else {
          errorPass = null;
        }
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
          Positioned(
            left: 0,
            top: 0,
            width: width,
            height: height,
            child: CustomPaint(
              size: Size(width, height*1.2), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
              painter: RPSCustomPainter(),
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
                          const SizedBox(height: 50.0),
                          const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0,
                              color: Colors.white
                            ),
                          ),
                          const SizedBox(height: 80.0),
                          AuthField(
                            hintText: "Email",
                            onChange: (value) => setState(() { email = value; }),
                            errorMsg: errorEmail,
                          ),
                          const SizedBox(height: 10.0),
                          AuthField(
                            hintText: "password",
                            onChange: (value) => setState(() { password = value; }),
                            errorMsg: errorPass,
                            obscureText: true,
                            icon: Icons.key,
                          ),
                          const SizedBox(height: 10.0),
                          AuthField(
                            onChange: (value) => setState(() { icalLink = value; }), 
                            hintText: "ICal link",
                            icon: Icons.http,
                          ),
                          const SizedBox(height: 35.0),
                          ElevatedButton(
                            onPressed: registering ? null : registerUser,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)
                              ),
                              minimumSize: const Size(double.infinity, 45.0)
                            ),
                            child: const Text("Register"),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("already have an account? "),
                          TextButton(
                            onPressed: () => redirectToSignin(context), 
                            child: const Text("sign in now")
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}