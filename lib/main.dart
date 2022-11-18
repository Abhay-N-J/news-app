import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_app/home.dart';
import 'package:news_app/login.dart';
import 'package:news_app/second.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News-app',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        Home.route: (context) => const Home(),
        Country.route: (context) => const Country(),
      },
    );
  }
}
