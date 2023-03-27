import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton(
      {super.key, required this.onTap, required this.buttonTitleString});

  final VoidCallback onTap;
  final String buttonTitleString;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoButton.filled(
              onPressed: onTap, child: Text(buttonTitleString))
          : SizedBox(
              width: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A148C),
                ),
                onPressed: onTap,
                child: Text(buttonTitleString),
              ),
            ),
    );
  }
}
