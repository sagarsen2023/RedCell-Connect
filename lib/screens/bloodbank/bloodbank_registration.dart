import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redcell_connect/components/components.dart';
import 'package:redcell_connect/screens/auth/login_screen.dart';

class BloodBankRegistration extends StatefulWidget {
  const BloodBankRegistration({super.key});

  @override
  State<BloodBankRegistration> createState() => _BloodBankRegistrationState();
}

class _BloodBankRegistrationState extends State<BloodBankRegistration> {
  // Variables
  TextEditingController bloodBankNameController = TextEditingController();
  TextEditingController bloodBankEmailController = TextEditingController();
  TextEditingController bloodBankPhoneController = TextEditingController();
  TextEditingController contactPersonNameController = TextEditingController();
  TextEditingController contactPersonPhoneController = TextEditingController();
  TextEditingController createPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String latitude = "";
  String longitude = "";
  String state = "";
  String country = "";
  String loadingText = "Creating account...";
  bool isLoading = false;
  bool gettingLocation = false;

  // Functions
  // Check location permission
  Future<void> getLiveLocation() async {
    try {
      setState(() {
        gettingLocation = true;
      });

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Again asking for location permision if denied
        await Geolocator.requestPermission();
      } else {
        // Fetch the current location
        Position currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        latitude = currentPosition.latitude.toString();
        longitude = currentPosition.longitude.toString();
        // Extracting country and state
        List<Placemark> placemarks = await placemarkFromCoordinates(
            currentPosition.latitude, currentPosition.longitude);
        // Getting the country
        country = placemarks[0].country ?? "";
        // getting the dtate
        state = placemarks[0].administrativeArea ?? "";
        // On Success
        if (context.mounted) {
          redcellSnacBar(
              context: context,
              text: "Live location successfully fetched",
              bgColour: Colors.green);
        }
      }
    } catch (e) {
      // Location fetching failed
      if (context.mounted) {
        redcellSnacBar(
            context: context,
            text: "Network error. Please try agin",
            bgColour: const Color.fromRGBO(157, 0, 0, 1));
      }
    } finally {
      setState(() {
        gettingLocation = false;
      });
    }
  } // Using geolocator

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RedCellAuthAppBar(
        preffixtext: "Registering as ",
        suffixtext: "Blood Bank",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RedCellTextField(
              helpText: "Enter Blood Bank name:",
              customHintText: "Enter name",
              inputKeyboardType: TextInputType.name,
              textEditingController: bloodBankNameController,
            ),
            RedCellTextField(
              helpText: "Enter email address of the Blood Bank: ",
              customHintText: "Enter mail",
              inputKeyboardType: TextInputType.emailAddress,
              textEditingController: bloodBankEmailController,
            ),
            RedCellTextField(
              helpText: "Enter Phone number:",
              customHintText: "Enter phone number with country code",
              inputKeyboardType: TextInputType.phone,
              textEditingController: bloodBankPhoneController,
            ),
            RedCellTextField(
              helpText: "Enter contact person name:",
              customHintText: "Enter name",
              inputKeyboardType: TextInputType.name,
              textEditingController: contactPersonNameController,
            ),
            RedCellTextField(
              helpText: "Enter contact person phone number",
              customHintText: "Enter phone number with country code",
              inputKeyboardType: TextInputType.phone,
              textEditingController: contactPersonPhoneController,
            ),
            RedcellPasswordField(
              helpText: "Create Password",
              customHintText: "Password nust be 6 characters long",
              inputKeyboardType: TextInputType.name,
              customPreffixIcon: Icons.lock,
              passwordController: createPasswordController,
            ),
            RedcellPasswordField(
              helpText: "Confirm Password",
              customHintText: "Password nust be 6 characters long",
              inputKeyboardType: TextInputType.name,
              customPreffixIcon: Icons.lock,
              passwordController: confirmPasswordController,
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 5),
              child: const Text(
                "The current location of the device will be taken for the address of this blood bank. Make sure this device is in the blood bank right now",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Get live location:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                ElevatedButton(
                  onPressed: getLiveLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gettingLocation
                        ? const Color.fromARGB(255, 161, 161, 161)
                        : const Color.fromARGB(255, 202, 18, 5),
                  ),
                  child: Text(
                    gettingLocation
                        ? "Fetching Location..."
                        : "Get Live Location",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding:
            const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
        child: RedCellElevatedButton(
          buttonText: isLoading ? loadingText : "Proceed",
          paddingLeftRight: 15,
          buttonFunction: () async {
            String bloodBankName = bloodBankNameController.text.trim();
            String emailAddress = bloodBankEmailController.text.trim();
            String phoneNumber = bloodBankPhoneController.text.trim();
            String contactPerson = contactPersonNameController.text.trim();
            String contactPersonPhone =
                contactPersonPhoneController.text.trim();
            String newPassword = createPasswordController.text.trim();
            String confirmPassword = confirmPasswordController.text.trim();

            if (bloodBankName == "" ||
                emailAddress == "" ||
                phoneNumber == "" ||
                contactPerson == "" ||
                contactPersonPhone == "" ||
                newPassword == "" ||
                confirmPassword == "") {
              redcellSnacBar(
                  context: context,
                  text: "All (*) marked fields should be filled",
                  bgColour: const Color.fromRGBO(157, 0, 0, 1));
            } else if (newPassword != confirmPassword) {
              redcellSnacBar(
                  context: context,
                  text: "Passwords didn't match",
                  bgColour: const Color.fromRGBO(157, 0, 0, 1));
            } else if (emailAddress == newPassword) {
              redcellSnacBar(
                  context: context,
                  text: "Don't use email id as password for better security",
                  bgColour: const Color.fromRGBO(157, 0, 0, 1));
            } else if (latitude == "" && longitude == "") {
              redcellSnacBar(
                  context: context,
                  text: "Live location not fetched",
                  bgColour: const Color.fromRGBO(157, 0, 0, 1));
            } else {
              showAlertDialog(
                context: context,
                headertext: "Are you sure?",
                descriptionText:
                    "A physical verification will be scheduled based on the above mentioned details. Would you like to continue?",
                contiueFunction: () async {
                  Navigator.pop(context);
                  setState(() {
                    isLoading = true;
                  });
                  log("Continue button clicked");
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailAddress, password: newPassword);
                    Map<String, dynamic> newBloodBank = {
                      "name": bloodBankName,
                      "email": emailAddress,
                      "phone": phoneNumber,
                      "contactPerson": contactPerson,
                      "contactPersonPhone": contactPersonPhone,
                      // Blood Group: A+
                      "singleA+": 0,
                      "doubleA+": 0,
                      "tripleA+": 0,
                      // Blood Group: A-
                      "singleA-": 0,
                      "doubleA-": 0,
                      "tripleA-": 0,
                      // Blood Group: B+
                      "singleB+": 0,
                      "doubleB+": 0,
                      "tripleB+": 0,
                      // Blood Group: B-
                      "singleB-": 0,
                      "doubleB-": 0,
                      "tripleB-": 0,
                      // Blood Group: AB+
                      "singleAB+": 0,
                      "doubleAB+": 0,
                      "tripleAB+": 0,
                      // Blood Group: AB-
                      "singleAB-": 0,
                      "doubleAB-": 0,
                      "tripleAB-": 0,
                      // Blood Group: O+
                      "singleO+": 0,
                      "doubleAO+": 0,
                      "tripleO+": 0,
                      // Blood Group: O-
                      "singleO-": 0,
                      "doubleO-": 0,
                      "tripleO-": 0,
                      // Sending Location Details
                      "latitude": latitude,
                      "longitude": longitude,
                      "country": country,
                      "state": state
                    };
                    try {
                      await FirebaseFirestore.instance
                          .collection("RedCell_Connect_BloodBanks")
                          .doc(emailAddress)
                          .set(newBloodBank);
                      setState(() {
                        loadingText = "Sending your details...";
                      });
                      if (context.mounted) {
                        redcellSnacBar(
                            context: context,
                            text:
                                "Your registration is successfull\nPlease login using your credential",
                            bgColour: Colors.green);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
                      }
                      // ignore: unused_catch_clause
                    } on FirebaseAuthException catch (e) {
                      if (context.mounted) {
                        redcellSnacBar(
                            context: context,
                            text: "Some error occured. Please try again.",
                            bgColour: const Color.fromRGBO(157, 0, 0, 1));
                      }
                      setState(() {
                        isLoading = false;
                      });
                    }
                    // ignore: unused_catch_clause
                  } on FirebaseAuthException catch (e) {
                    if (context.mounted) {
                      redcellSnacBar(
                          context: context,
                          text:
                              "Incorrect email or this email is already in use",
                          bgColour: const Color.fromRGBO(157, 0, 0, 1));
                    }
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
