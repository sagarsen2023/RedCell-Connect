import 'package:flutter/material.dart';
import 'package:redcell_connect/components/components.dart';
import 'package:redcell_connect/screens/bloodbank/bloodbank_registration.dart';
import 'package:redcell_connect/screens/hospitals/hospitals_registration.dart';
import 'package:redcell_connect/screens/auth/login_screen.dart';
import 'package:redcell_connect/components/theme_changer.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextStyle footerTextStype = const TextStyle(
    color: Color.fromRGBO(255, 0, 0, 1),
    decoration: TextDecoration.underline,
    decorationColor: Color.fromRGBO(255, 0, 0, 1),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to",
              style: preText,
            ),
            Text(
              " RedCell Connect",
              style: suffText,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 250,
              height: 335,
              child: Image.asset("assets/images/authscreen.png"),
            ),
            RedCellElevatedButton(
              buttonText: "Sign Up as Hospital",
              paddingLeftRight: 80,
              buttonFunction: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HospitalRegistration(),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            RedCellElevatedButton(
              buttonText: "Sign Up as Blood Banks",
              paddingLeftRight: 64,
              buttonFunction: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BloodBankRegistration(),
                ),
              ), // Navigator
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 20, left: 150, right: 150, bottom: 20),
              child: const Divider(
                thickness: 5,
                color: Colors.black,
              ),
            ),
            const Text(
              "Already Registered?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(
                      top: 10, left: 50, right: 50, bottom: 10),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  elevation: 5.0,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 3,
                  )),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen())),
              child: Text(
                "Login",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 40, right: 40),
        color: Theme.of(context).colorScheme.background,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          // Functionality will be added later on
          children: [
            Text(
              "Need Help: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              "FAQ",
              style: TextStyle(
                color: Color.fromRGBO(255, 0, 0, 1),
                decoration: TextDecoration.underline,
                decorationColor: Color.fromRGBO(255, 0, 0, 1),
              ),
            ),
            Text(
              " || ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.red,
              ),
            ),
            Text(
              "Privacy Policy",
              style: TextStyle(
                color: Color.fromRGBO(255, 0, 0, 1),
                decoration: TextDecoration.underline,
                decorationColor: Color.fromRGBO(255, 0, 0, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
