import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: const Color(0xFF00C853),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedTextKit(
                repeatForever: false,
                isRepeatingAnimation: false,
                animatedTexts: [
                  TyperAnimatedText(
                    'Message Sent!',
                    textStyle: const TextStyle(
                      fontSize: 50,
                      fontFamily: 'Uber',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              AnimatedTextKit(
                repeatForever: false,
                isRepeatingAnimation: false,
                animatedTexts: [
                  TyperAnimatedText(
                    speed: const Duration(milliseconds: 15),
                    'Tap Anywhere to Continue',
                    textStyle: const TextStyle(
                      fontFamily: 'Uber',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
