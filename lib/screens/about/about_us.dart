import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.0),
            Padding(
              padding: EdgeInsets.all(25.0),
              child: Text("About Us",
                style: TextStyle(
                  fontSize: 50.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/chan.png'),
                  radius: 60,
                ),
                SizedBox(width: 40),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/juvi.png'),
                  radius: 60,
                )
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(25.0),
              child: Text("Welcome to S-Hub, where innovation meets productivity! We are a dynamic team of students who believe in the power of efficiency and the endless possibilities that come with it. Our journey began as a collective desire to bridge the gap between the demands of student life and the need for effective time management.",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25.0),
              child: Text("S-Hub is not just a productivity app; it's a reflection of our commitment to empowering individuals with the tools they need to succeed. As students ourselves, we understand the challenges of juggling classes, assignments, extracurricular activities, and personal commitments. This insight fueled our passion to create a solution that goes beyond the ordinary.",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25.0),
              child: Text("What sets S-Hub apart is its intuitive design and user-friendly interface. We wanted to ensure that our app caters to all levels of tech-savviness, making it accessible to every student, regardless of their background. Whether you're a seasoned multitasker or just starting your academic journey, [App Name] is designed to streamline your workflow and maximize your potential.",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
