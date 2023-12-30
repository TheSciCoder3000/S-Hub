import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:s_hub/models/event.dart';
import 'package:s_hub/routes/constants.dart';
import 'package:s_hub/utils/firebase/db.dart';

class Splash extends StatefulWidget {
  const Splash({super.key, required this.uid});
  final String? uid;

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      final eventState = context.read<EventState>();
      String? user = widget.uid;

      if (user == null) {
        context.go(context.namedLocation(RoutePath.signin.name));
      } else {
        FirestoreService(uid: user).getAllEvents().then((events) {
          eventState.parse(events);
        });
        context.go(context.namedLocation(RoutePath.dashboard.name));
      }
    });
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
              child: const SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 250,
                      child: Image(
                        image: AssetImage("assets/logo.png"),
                      ),
                    ),
                    SizedBox(height: 120.0)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}