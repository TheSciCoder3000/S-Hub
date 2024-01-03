import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:s_hub/models/event.dart';
import 'package:s_hub/routes/constants.dart';
import 'package:s_hub/screens/auth/auth_field.dart';
import 'package:s_hub/utils/firebase/auth.dart';
import 'package:s_hub/utils/firebase/db.dart';

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
  final _formKey = GlobalKey<FormState>();

  void redirectToSignin(BuildContext context) {
    context.go(context.namedLocation(RoutePath.signin.name));
  }

  void registerUser(VoidCallback navigateFunc) async {
    bool formIsValid = _formKey.currentState!.validate();
    final eventState = context.read<EventState>();

    if (!formIsValid) return;

    setState(() {
      errorEmail = null;
      registering = true;
    });
    try {
      User? user = await AuthService().registerWithEmail(email, password, icalLink);
      if (user != null) {
        await FirestoreService(uid: user.uid).syncEvents();
        final events =  await FirestoreService(uid: user.uid).getAllEvents();
        eventState.parse(events);
        navigateFunc();
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
                  child: Form(
                    key: _formKey,
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
                            const SizedBox(height: 30.0),
                            AuthField(
                              hintText: "Email",
                              onChange: (value) => setState(() { email = value; }),
                              errorMsg: errorEmail,
                              validator: (value) {
                                final isEmailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);
                                if (!isEmailValid) {
                                  return "Please enter a valid email";
                                }

                                return null;
                              },
                            ),
                            AuthField(
                              hintText: "password",
                              onChange: (value) => setState(() { password = value; }),
                              errorMsg: errorPass,
                              obscureText: true,
                              icon: Icons.key,
                              validator: (passKey) {
                                if (passKey == null || passKey.length < 10) {
                                  return "Please enter more than 10 characters";
                                }

                                return null;
                              },
                            ),
                            AuthField(
                              onChange: (value) => setState(() { icalLink = value; }), 
                              hintText: "ICal link",
                              icon: Icons.http,
                              validator: (urlValue) {
                                bool validURL = Uri.parse(urlValue!).isAbsolute;

                                if (!validURL) {
                                  return "Enter a valid ICal url";
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 30.0),
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft, end: Alignment.centerRight,
                                  colors: [Color.fromARGB(255, 13, 228, 109), Color.fromARGB(255, 6, 214, 169)],
                                ),
                                borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: ElevatedButton(
                                onPressed: registering ? null : () => registerUser(() {
                                  context.go(context.namedLocation(RoutePath.dashboard.name));
                                }),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)
                                  ),
                                  minimumSize: const Size(double.infinity, 45.0)
                                ),
                                child: const Text("Register", style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("already have an account? "),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: const Color.fromARGB(255, 0, 242, 206)
                              ),
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
          ),
        ],
      ),
    );
  }
}