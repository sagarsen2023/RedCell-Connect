import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redcell_connect/components/components.dart';
import 'package:redcell_connect/screens/bloodbank/bloodbank_homepage.dart';
import 'package:redcell_connect/components/theme_changer.dart';
import 'package:redcell_connect/screens/hospitals/hospitals_homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<String> userTypes = [
    "RedCell_Connect_BloodBanks",
    "RedCell_Connect_Hospitals"
  ];
  String userType = "";

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  List<bool> isselected = [false, false];

  // Functions
  Future<bool> doesEmailExist(String userType, String email) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection(userType)
          .doc(email)
          .get();

      return docSnapshot.exists;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RedCellAuthAppBar(
          preffixtext: "Continue with your ", suffixtext: "account"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Image.asset("assets/images/authscreen.png"),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Logging in ",
                  style: suffText,
                ),
                Text(
                  "as: ",
                  style: preText,
                )
              ],
            ),
            RadioListTile(
                title: const Text(
                  "Hospitals",
                  style: preText,
                ),
                value: userTypes[1],
                groupValue: userType,
                onChanged: (value) {
                  setState(() {
                    userType = userTypes[1];
                  });
                }),
            RadioListTile(
                title: const Text(
                  "Blood Bank",
                  style: preText,
                ),
                value: userTypes[0],
                groupValue: userType,
                onChanged: (value) {
                  setState(() {
                    userType = userTypes[0];
                  });
                }),
            RedCellTextField(
              helpText: "Enter your email:",
              customHintText: "Email",
              inputKeyboardType: TextInputType.name,
              textEditingController: emailController,
            ),
            RedcellPasswordField(
              helpText: "Enter your password:",
              customHintText: "Password must contain 6 characters",
              inputKeyboardType: TextInputType.name,
              customPreffixIcon: Icons.lock,
              passwordController: passwordController,
            ),
            GestureDetector(
              onTap: () async {
                // Checking if email is empty
                if (emailController.text.trim() == "" && context.mounted) {
                  redcellSnacBar(
                      context: context,
                      text: "Enter a email to reset passsword",
                      bgColour: Colors.red);
                } else {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: emailController.text.trim());
                    if (context.mounted) {
                      redcellSnacBar(
                          context: context,
                          text: "Reset Email sent successfully",
                          bgColour: Colors.green);
                    }
                  } on FirebaseAuthException catch (e) {
                    if (context.mounted) {
                      redcellSnacBar(
                          context: context,
                          text: e.message.toString(),
                          bgColour: Colors.red);
                    }
                  }
                }
              },
              child: const Text(
                "Forgot Password?",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            RedCellElevatedButton(
              buttonText: isLoading ? "Loggin in..." : "Proceed",
              paddingLeftRight: 30,
              buttonFunction: () async {
                //
                // Login Button function
                //
                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                if (email == "" || password == "") {
                  redcellSnacBar(
                      context: context,
                      text: "Email or passwprd can not be empty",
                      bgColour: Colors.red);
                } else if (password.length <= 6) {
                  redcellSnacBar(
                      context: context,
                      text: "Password must be above 6 characters",
                      bgColour: Colors.red);
                } else if (userType == "") {
                  redcellSnacBar(
                      context: context,
                      text: "Select your login type",
                      bgColour: Colors.red);
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  bool emailExists = await doesEmailExist(userType, email);
                  if (emailExists) {
                    try {
                      // Trying to log in
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (context.mounted) {
                        redcellSnacBar(
                            context: context,
                            text: "Successfully Logged in",
                            bgColour: Colors.green);
                        try {
                          // Storing the
                          SharedPreferences localValue =
                              await SharedPreferences.getInstance();
                          localValue.setString("userType", userType);
                          SharedPreferences storedEmail =
                              await SharedPreferences.getInstance();
                          storedEmail.setString("userEmail", email);
                          if (context.mounted) {
                            if (userType == "RedCell_Connect_Hospitals") {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          const HospitalHomePage())));
                            } else {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          const BloodBankHomePage())));
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            redcellSnacBar(
                                context: context,
                                text: "Sorry some error occured.",
                                bgColour: Colors.red);
                          }
                        }
                      }
                      // ignore: unused_catch_clause
                    } on FirebaseAuthException catch (e) {
                      if (context.mounted) {
                        redcellSnacBar(
                            context: context,
                            text:
                                "Error: Invalid Credential, Check your email and password details",
                            bgColour: Colors.red);
                      }
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  } else {
                    if (context.mounted) {
                      redcellSnacBar(
                          context: context,
                          text:
                              "Sorry your email is not available in the specified login type",
                          bgColour: Colors.red);
                    }
                    setState(() {
                      isLoading = false;
                    });
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
