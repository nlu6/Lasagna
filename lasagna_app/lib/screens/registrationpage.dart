import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lasagna_app/screens/homepage.dart';
import 'package:lasagna_app/screens/loginpage.dart';
import 'package:page_transition/page_transition.dart';

import '../widgets/main_button.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = 'register';
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
                                'Register',
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
                        textAlignVertical: TextAlignVertical.top,
                        controller: nameController,
                        keyboardType: TextInputType.multiline,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          border: const OutlineInputBorder(),
                          icon: defaultTargetPlatform == TargetPlatform.iOS
                              ? const Icon(CupertinoIcons.person)
                              : const Icon(Icons.person),
                          hintText: 'Name',
                          // labelText: 'Message',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        onFieldSubmitted: (value) => onSubmit(),
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
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        onFieldSubmitted: (value) => onSubmit(),
                        controller: confirmPassController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          icon: defaultTargetPlatform == TargetPlatform.iOS
                              ? const Icon(CupertinoIcons.check_mark)
                              : const Icon(Icons.check),
                          // hintText: 'Phone number for reply texts',
                          hintText: 'Confirm Password',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () => Navigator.push(
                                    context,
                                    PageTransition(
                                        child: const LoginPage(),
                                        type: PageTransitionType.fade),
                                  ),
                              child: const Text('Log in Instead?')),
                          TextButton(
                              onPressed: () => Navigator.push(
                                    context,
                                    PageTransition(
                                        child: const HomePage(),
                                        type: PageTransitionType.fade),
                                  ),
                              child: const Text('Skip')),
                        ],
                      ),
                      MainButton(
                        onTap: onSubmit,
                        buttonTitleString: 'REGISTER',
                      ),
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
    if (nameController.text.length < 3) {
      showErrMessage('Please Provide a Valid Full Name');
      return;
    }
    if (!emailController.text.contains('@') &&
        !emailController.text.contains('.')) {
      showErrMessage('Please a Valid Email Address');
      return;
    }
    if (passController.text.length < 8) {
      showErrMessage('Please a Valid Password');
      return;
    }
    if (passController.text != confirmPassController.text) {
      showErrMessage('Passwords do Not Match');
      return;
    }

    registerUser();
  }

  void registerUser() async {
    UserCredential user = await _auth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passController.text)
        // ignore: body_might_complete_normally_catch_error
        .catchError((err) {
      FirebaseAuthException thisErr = err;
      showErrMessage(thisErr.message);
    });

    DatabaseReference newUserRef =
        FirebaseDatabase.instance.ref().child('/users/${user.user?.uid}');

    Map userInfo = {
      'fullName': nameController.text,
      'email': emailController.text,
    };

    newUserRef.set(userInfo);

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
