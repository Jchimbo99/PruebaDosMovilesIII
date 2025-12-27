

import 'package:app_evaluacion/screens/BancariaHomeScreen.dart';
import 'package:app_evaluacion/screens/HomeScreen.dart';

import 'package:app_evaluacion/screens/LoginScreen.dart';
import 'package:app_evaluacion/screens/RegistroScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Firebase
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),

      home: const HomeScreen(),

    routes: {
  "/login": (context) => const LoginScreen(),
  "/bancaria": (context) => const BancariaHome(),
  "/registro": (context) => const RegistroScreen(),
},

    );
  }
}
