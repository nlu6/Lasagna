import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 25.0,
              ),
              AnimatedTextKit(
                repeatForever: true,
                isRepeatingAnimation: true,
                animatedTexts: [
                  TyperAnimatedText(
                    'Sending....',
                    textStyle: const TextStyle(
                      fontSize: 30,
                      fontFamily: 'Uber',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4A148C),
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
