import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
//Material UI
import 'package:flutter/material.dart';
//Páginas Internas
import 'package:games/firebase_options.dart';
import 'package:games/pages/login_page.dart';
import 'package:games/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCPWZ-xbasRaDExcUvYNb2-I1zPBcKizYg",
        authDomain: "pokedex-app-12f28.firebaseapp.com",
        projectId: "pokedex-app-12f28",
        storageBucket: "pokedex-app-12f28.firebasestorage.app",
        messagingSenderId: "147417047798",
        appId: "1:147417047798:web:815713eb19374ac7da02d7"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
