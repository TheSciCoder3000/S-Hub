import 'package:flutter/material.dart';
import 'package:s_hub/models/user.dart';
import 'package:s_hub/screens/auth/auth_field.dart';
import 'package:s_hub/screens/auth/custom_painter.dart';
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

  void signinUser() async {
    setState(() {
      errorEmail = null;
      errorPass = null;
      signingIn = true;
    });
    try {
      SUser? user = await AuthService().signInWithEmail(email, password);
      if (user != null) {
        Navigator.pushNamed(context, "/dashboard");
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
                            "Log In",
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
                          const SizedBox(height: 50.0),
                          ElevatedButton(
                            onPressed: signingIn ? null : signinUser,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)
                              ),
                              minimumSize: const Size(double.infinity, 45.0)
                            ),
                            child: const Text("Sign In"),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("don't have an account? "),
                          TextButton(
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
