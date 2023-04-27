import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lasagna_app/widgets/main_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 38),
                        child: AnimatedTextKit(
                          repeatForever: false,
                          isRepeatingAnimation: false,
                          animatedTexts: [
                            TyperAnimatedText(
                              'Forgot Password',
                              textStyle: const TextStyle(
                                fontSize: 50,
                                fontFamily: 'Uber',
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF4A148C),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        icon: defaultTargetPlatform == TargetPlatform.iOS
                            ? const Icon(CupertinoIcons.mail)
                            : const Icon(Icons.email_outlined),
                        // hintText: 'Phone number for reply texts',
                        hintText: 'Email',
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Go Back?'),
                      ),
                    ),
                    MainButton(
                      onTap: onSubmit,
                      buttonTitleString: 'SUBMIT',
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSubmit() async {
    if (!emailController.text.contains('@') &&
        !emailController.text.contains('.')) {
      showErrMessage('Please a Valid Email Address');
      return;
    }

    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text)
        .then((_) {
      Navigator.pop(context, 'Check Email to Reset Your Password');
    }).catchError((err) {
      FirebaseAuthException thisErr = err;
      showErrMessage(thisErr.message);
    });
  }

  void showErrMessage(String? errMsg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(errMsg!)));
  }
}
