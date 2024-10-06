import 'dart:async';
import 'package:flutter/material.dart';

import 'main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUSTAIN',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  String displayedText = "";
  String fullText = "SUSTAIN";

  @override
  void initState() {
    super.initState();

    // Animation controller for displaying letters one by one
    _controller = AnimationController(
      duration: const Duration(seconds: 4), // Adjust time for the effect
      vsync: this,
    );

    _animation = IntTween(begin: 0, end: fullText.length).animate(_controller)
      ..addListener(() {
        setState(() {
          displayedText = fullText.substring(0, _animation.value);
        });
      });

    // Start the letter animation
    _controller.forward();

    // Redirect to the main page after the animation completes (4 seconds)
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background space image
          Image.asset(
            'assets/space_image.jpg', // Add space background image to assets folder
            fit: BoxFit.cover,
          ),
          // Center the text in the middle of the screen
          Center(
            child: Text(
              displayedText,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


