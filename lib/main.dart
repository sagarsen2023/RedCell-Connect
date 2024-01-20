import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redcell_connect/firebase_options.dart';
import 'package:redcell_connect/screens/auth/auth_screen.dart';
import 'package:redcell_connect/screens/bloodbank/bloodbank_homepage.dart';
import 'package:redcell_connect/screens/hospitals/hospitals_homepage.dart';
import 'package:redcell_connect/components/theme_changer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: FutureBuilder<Widget>(
        future: pageController(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return snapshot.data ?? const AuthScreen();
          }
        },
      ),
    );
  }
}

Future<Widget> pageController() async {
  if (FirebaseAuth.instance.currentUser != null) {
    SharedPreferences value = await SharedPreferences.getInstance();
    if (value.getString("userType") == "RedCell_Connect_Hospitals") {
      return const HospitalHomePage();
    } else if (value.getString("userType") == "RedCell_Connect_BloodBanks") {
      return const BloodBankHomePage();
    }
  }
  return const AuthScreen();
}
