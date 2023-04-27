import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lasagna_app/screens/forgotpassword.dart';
import 'package:lasagna_app/screens/registrationpage.dart';
import 'package:page_transition/page_transition.dart';

import '../widgets/main_button.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
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
                                'Login',
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
                        onFieldSubmitted: (value) => onSubmit(),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          icon: defaultTargetPlatform == TargetPlatform.iOS
                              ? const Icon(CupertinoIcons.mail)
                              : const Icon(Icons.email_outlined),
                          // hintText: 'Phone number for reply texts',
                          hintText: 'Email',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        onFieldSubmitted: (value) => onSubmit(),
                        controller: passController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          icon: defaultTargetPlatform == TargetPlatform.iOS
                              ? const Icon(CupertinoIcons.lock)
                              : const Icon(Icons.password_outlined),
                          // hintText: 'Phone number for reply texts',
                          hintText: 'Password',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {
                              String message = await Navigator.push(
                                context,
                                PageTransition(
                                    child: const ForgotPassword(),
                                    type: PageTransitionType.fade),
                              );
                              showErrMessage(message);
                            },
                            child: const Text('Forgot Password?'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              PageTransition(
                                  child: const RegistrationPage(),
                                  type: PageTransitionType.fade),
                            ),
                            child: const Text('Need to Register?'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              PageTransition(
                                  child: const HomePage(),
                                  type: PageTransitionType.fade),
                            ),
                            child: const Text('Skip'),
                          ),
                        ],
                      ),
                      MainButton(
                        onTap: onSubmit,
                        buttonTitleString: 'LOGIN',
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSubmit() {
    if (!emailController.text.contains('@') &&
        !emailController.text.contains('.')) {
      showErrMessage('Please a Valid Email Address');
      return;
    }
    if (passController.text.length < 8) {
      showErrMessage('Please a Valid Password');
      return;
    }

    loginUser();
  }

  void loginUser() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passController.text)
        // ignore: body_might_complete_normally_catch_error
        .catchError((err) {
      FirebaseAuthException thisErr = err;
      showErrMessage(thisErr.message);
    });

    if (context.mounted) {
      Navigator.push(
        context,
        PageTransition(child: const HomePage(), type: PageTransitionType.fade),
      );
    }
  }

  void showErrMessage(String? errMsg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(errMsg!)));
  }
}
