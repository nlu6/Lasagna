import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lasagna_app/firebase_options.dart';
import 'package:lasagna_app/screens/homepage.dart';
import 'package:lasagna_app/screens/loginpage.dart';
import 'package:lasagna_app/screens/registrationpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lasagna',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: HomePage.id,
      routes: {
        HomePage.id: (context) => const HomePage(),
        LoginPage.id: (context) => const LoginPage(),
        RegistrationPage.id: (context) => const RegistrationPage(),
      },
    );
  }
}
