import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redcell_connect/components/components.dart';
import 'package:redcell_connect/screens/auth/login_screen.dart';

class HospitalRegistration extends StatefulWidget {
  const HospitalRegistration({super.key});

  @override
  State<HospitalRegistration> createState() => HospitalRegistrationState();
}

class HospitalRegistrationState extends State<HospitalRegistration> {
  // Variables
  TextEditingController hospitalNameController = TextEditingController();
  TextEditingController hospitalEmailController = TextEditingController();
  TextEditingController hospitalPhoneController = TextEditingController();
  TextEditingController contactPersonNameController = TextEditingController();
  TextEditingController contactPersonPhoneController = TextEditingController();

  TextEditingController createPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String country = "";
  String state = "";
  String latitude = "";
  String longitude = "";
  String loadingText = "Creating account...";
  bool isLoading = false;
  bool gettingLocation = false;

  void getLiveLocation() async {
    try {
      setState(() {
        gettingLocation = true;
      });
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Again asking for location permision
        await Geolocator.requestPermission();
      } else {
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
        if (context.mounted) {
          redcellSnacBar(
              context: context,
              text: "Live location successfully fetched",
              bgColour: Colors.green);
        }
      }
    } catch (e) {
      if (context.mounted) {
        redcellSnacBar(
            context: context, text: "Network error", bgColour: Colors.red);
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
            preffixtext: "Registering as ", suffixtext: "Hospital"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Hospital Name
              RedCellTextField(
                helpText: "Enter hospital name:",
                customHintText: "Enter name",
                inputKeyboardType: TextInputType.name,
                textEditingController: hospitalNameController,
              ),

              // Hospital email
              RedCellTextField(
                helpText: "Enter email address of the hospital: ",
                customHintText: "Enter mail",
                inputKeyboardType: TextInputType.emailAddress,
                textEditingController: hospitalEmailController,
              ),

              // Hospital phone number
              RedCellTextField(
                helpText: "Enter Phone number:",
                customHintText: "Enter phone number with country code",
                inputKeyboardType: TextInputType.phone,
                textEditingController: hospitalPhoneController,
              ),

              // Contact person name
              RedCellTextField(
                helpText: "Enter contact person name:",
                customHintText: "Enter name",
                inputKeyboardType: TextInputType.name,
                textEditingController: contactPersonNameController,
              ),

              // Contact person phone number
              RedCellTextField(
                helpText: "Enter contact person phone number",
                customHintText: "Enter phone number with country code",
                inputKeyboardType: TextInputType.phone,
                textEditingController: contactPersonPhoneController,
              ),

              // Creating a password
              RedcellPasswordField(
                helpText: "Create Password",
                customHintText: "Password nust be 6 characters long",
                inputKeyboardType: TextInputType.name,
                customPreffixIcon: Icons.lock,
                passwordController: createPasswordController,
              ),

              //  Confirming the password
              RedcellPasswordField(
                helpText: "Cirnfirm Password",
                customHintText: "Password nust be 6 characters long",
                inputKeyboardType: TextInputType.name,
                customPreffixIcon: Icons.lock,
                passwordController: confirmPasswordController,
              ),

              //  Live location fetcher
              Container(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 15, bottom: 5),
                child: const Text(
                  "The current location of the device will be taken for the address of this Hospital. Make sure this device is in the Hospital right now",
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
                          ? "Fetching location..."
                          : "Get live location:",
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
              const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
          child: RedCellElevatedButton(
            buttonText: isLoading ? loadingText : "Proceed",
            paddingLeftRight: 15,
            buttonFunction: () async {
              String hospitalName = hospitalNameController.text.trim();
              String emailAddress = hospitalEmailController.text.trim();
              String phoneNumber = hospitalPhoneController.text.trim();
              String contactPerson = contactPersonNameController.text.trim();
              String contactPersonPhone =
                  contactPersonPhoneController.text.trim();
              String newPassword = createPasswordController.text.trim();
              String confirmPassword = confirmPasswordController.text.trim();

              if (hospitalName == "" ||
                  emailAddress == "" ||
                  phoneNumber == "" ||
                  contactPerson == "" ||
                  contactPersonPhone == "" ||
                  newPassword == "" ||
                  confirmPassword == "") {
                redcellSnacBar(
                    context: context,
                    text: "All (*) marked fields should be filled",
                    bgColour: Colors.red);
              } else if (newPassword != confirmPassword) {
                redcellSnacBar(
                    context: context,
                    text: "Passwords didn't match",
                    bgColour: Colors.red);
              } else if (emailAddress == newPassword) {
                redcellSnacBar(
                    context: context,
                    text: "Don't use email id as password for better security",
                    bgColour: Colors.red);
              } else if (latitude == "" && longitude == "") {
                redcellSnacBar(
                    context: context,
                    text: "Live location not fetched",
                    bgColour: Colors.red);
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
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: emailAddress, password: newPassword);
                      Map<String, dynamic> newHospital = {
                        "name": hospitalName,
                        "email": emailAddress,
                        "phone": phoneNumber,
                        "contactPerson": contactPerson,
                        "contactPersonPhone": contactPersonPhone,
                        "latitude": latitude,
                        "longitude": longitude,
                        "country": country,
                        "state": state
                      };

                      try {
                        // Adding a new user
                        await FirebaseFirestore.instance
                            .collection("RedCell_Connect_Hospitals")
                            .doc(emailAddress)
                            .set(newHospital);
                        setState(() {
                          loadingText = "Sending your details...";
                        });
                      } catch (e) {
                        if (context.mounted) {
                          redcellSnacBar(
                              context: context,
                              text: "Some error occured or internet error",
                              bgColour: Colors.red);
                        }
                      }
                      if (context.mounted) {
                        redcellSnacBar(
                            context: context,
                            text: "Account successfully Created",
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
                            text:
                                "Incorrect email or this email is already in use",
                            bgColour: Colors.red);
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
        ));
  }
}
