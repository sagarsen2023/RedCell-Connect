import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redcell_connect/components/components.dart';
import 'package:redcell_connect/screens/auth/auth_screen.dart';
import 'package:redcell_connect/services/get_database_data.dart';

class EditProfileDetails extends StatefulWidget {
  final String collectionName;
  const EditProfileDetails({super.key, required this.collectionName});

  @override
  State<EditProfileDetails> createState() => _EditProfileDetailsState();
}

class _EditProfileDetailsState extends State<EditProfileDetails> {
  bool isLoading = false;
  Map<String, dynamic> data = {};

  // Edit Basic Details
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController contactPerosnController = TextEditingController();
  TextEditingController contactPersonPhoneController = TextEditingController();

  // Getting the database data
  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    data = await fetchDataFromDocument(widget.collectionName);
    nameController.text = "${data["name"]}";
    emailController.text = "${data["email"]}";
    phoneController.text = "${data["phone"]}";
    contactPerosnController.text = "${data["contactPerson"]}";
    contactPersonPhoneController.text = "${data["contactPersonPhone"]}";
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Updating the details
  void editDetails() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection(widget.collectionName)
          .doc("${data["email"]}")
          .update({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "contactPerson": contactPerosnController.text.trim(),
        "contactPersonPhone": contactPersonPhoneController.text.trim()
      });
      if (context.mounted) {
        redcellSnacBar(
            context: context,
            text: "Data Successfully updated",
            bgColour: Colors.green);
      }
    } catch (e) {
      if (context.mounted) {
        redcellSnacBar(
            context: context,
            text: "Unable to Update due to some error. Please try agin",
            bgColour: Colors.red);
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RedCellHomeAppBar(isloading: isLoading, buttonFunction: getData),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 8,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Editing basic Details
                  const Padding(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 5),
                    child: Text(
                      "Edit Your details:",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  RedCellTextField(
                      helpText: "Name",
                      customHintText: "${data["name"]}",
                      inputKeyboardType: TextInputType.name,
                      textEditingController: nameController),
                  RedCellTextField(
                      helpText: "Email",
                      customHintText: "${data["email"]}",
                      inputKeyboardType: TextInputType.emailAddress,
                      textEditingController: emailController),
                  RedCellTextField(
                      helpText: "Phone",
                      customHintText: "${data["phone"]}",
                      inputKeyboardType: TextInputType.emailAddress,
                      textEditingController: phoneController),
                  RedCellTextField(
                      helpText: "Contact Person Name",
                      customHintText: "${data["contactPerson"]}",
                      inputKeyboardType: TextInputType.emailAddress,
                      textEditingController: contactPerosnController),
                  RedCellTextField(
                      helpText: "Contact Person Phone",
                      customHintText: "${data["contactPersonPhone"]}",
                      inputKeyboardType: TextInputType.emailAddress,
                      textEditingController: contactPersonPhoneController),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: RedCellElevatedButton(
                          buttonText: "Update details",
                          paddingLeftRight: 15,
                          buttonFunction: () {
                            showAlertDialog(
                                context: context,
                                headertext: "Update Data",
                                descriptionText:
                                    "Have you entered the correct details?",
                                contiueFunction: () {
                                  editDetails();
                                  Navigator.pop(context);
                                });
                          }),
                    ),
                  ),
                  const Divider(
                    indent: 180,
                    endIndent: 180,
                    thickness: 4,
                  ),

                  Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 25, right: 25, bottom: 8),
                      child: Center(
                        child: RedCellElevatedButton(
                          buttonText: "LogOut",
                          paddingLeftRight: 15,
                          buttonFunction: () async {
                            try {
                              await FirebaseAuth.instance.signOut();
                              if (context.mounted) {
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AuthScreen(),
                                    ));
                              }
                            } catch (e) {
                              if (context.mounted) {
                                redcellSnacBar(
                                    context: context,
                                    text: "Unable to logout",
                                    bgColour: Colors.red);
                              }
                            }
                          },
                        ),
                      )),
                ],
              ),
            ),
    );
  }
}
