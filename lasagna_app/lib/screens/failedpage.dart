import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class FailedPage extends StatelessWidget {
  const FailedPage({super.key, required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedTextKit(
                repeatForever: false,
                isRepeatingAnimation: false,
                animatedTexts: [
                  TyperAnimatedText(
                    'Failed!',
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
                    errorMessage,
                    textStyle: const TextStyle(
                      fontFamily: 'Uber',
                      fontWeight: FontWeight.w500,
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
                    '\nTap Anywhere to Dismiss',
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
