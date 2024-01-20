import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:redcell_connect/components/components.dart';
import 'package:redcell_connect/screens/auth/edit_details.dart';
import 'package:redcell_connect/services/get_database_data.dart';
import 'package:redcell_connect/components/theme_changer.dart';
import 'package:redcell_connect/services/get_nearby_bloodbanks.dart';

class HospitalHomePage extends StatefulWidget {
  const HospitalHomePage({super.key});

  @override
  State<HospitalHomePage> createState() => _HospitalHomePageState();
}

class _HospitalHomePageState extends State<HospitalHomePage> {
  Map<String, dynamic> data = {};
  bool isLoading = false;
  String selectedBloodGroup = "Select";
  final TextEditingController bloodQuantityController = TextEditingController();

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      selectedBloodGroup = "Select";
    });
    try {
      data = await fetchDataFromDocument("RedCell_Connect_Hospitals");
      if (context.mounted) {
        redcellSnacBar(
            context: context, text: "Data Updated", bgColour: Colors.green);
      }
    } catch (e) {
      if (mounted) {
        redcellSnacBar(
            context: context,
            text: "Network Error",
            bgColour: const Color.fromRGBO(157, 0, 0, 1));
        setState(() {
          isLoading = false;
        });
      }
    }
    log("$data");
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          RedCellHomeAppBar(isloading: isLoading, buttonFunction: fetchData),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container:- Profile Details of the hospital
            Container(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                children: [
                  ProfileDetails(
                      descriptionText: "Name",
                      infoText: "${data["name"]}",
                      icon: Icons.business,
                      isloading: isLoading),
                  ProfileDetails(
                      descriptionText: "Email",
                      infoText: "${data["email"]}",
                      icon: Icons.email,
                      isloading: isLoading),
                  ProfileDetails(
                      descriptionText: "Phone",
                      infoText: "${data["phone"]}",
                      icon: Icons.call,
                      isloading: isLoading),
                  ProfileDetails(
                      descriptionText: "Contact Person Name",
                      infoText: "${data["contactPerson"]}",
                      icon: Icons.person_4,
                      isloading: isLoading),
                  ProfileDetails(
                      descriptionText: "Contact Person Phone",
                      infoText: "${data["contactPersonPhone"]}",
                      icon: Icons.call_outlined,
                      isloading: isLoading),
                  Center(
                    child: RedCellElevatedButton(
                        buttonText: "Edit Details",
                        paddingLeftRight: 15,
                        buttonFunction: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileDetails(collectionName: "RedCell_Connect_Hospitals")));
                        }),
                  )
                ],
              ),
            ),
            // Section 2:- For getting the requirements
            const SizedBox(height: 15),
            const Divider(
              indent: 180,
              endIndent: 180,
              thickness: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    "Search",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Blood Group",
                          style: preText,
                        ),
                        DropdownButton<String>(
                            padding: const EdgeInsets.only(left: 16.0),
                            value: selectedBloodGroup,
                            underline: Container(
                              height: 2,
                              color: const Color.fromRGBO(194, 0, 0, 1),
                            ),
                            icon: const Padding(
                              padding: EdgeInsets.only(left: 14.0),
                              child: Icon(
                                Icons.arrow_drop_down_circle_rounded,
                                color: Color.fromRGBO(194, 0, 0, 1),
                              ),
                            ),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            items: const [
                              DropdownMenuItem<String>(
                                  value: "Select", child: Text("Select")),
                              DropdownMenuItem<String>(
                                  value: "A+", child: Text("A+")),
                              DropdownMenuItem<String>(
                                  value: "A-", child: Text("A-")),
                              DropdownMenuItem<String>(
                                  value: "B+", child: Text("B+")),
                              DropdownMenuItem<String>(
                                  value: "B-", child: Text("B-")),
                              DropdownMenuItem<String>(
                                  value: "AB+", child: Text("AB+")),
                              DropdownMenuItem<String>(
                                  value: "AB-", child: Text("AB-")),
                              DropdownMenuItem<String>(
                                  value: "O+", child: Text("O+")),
                              DropdownMenuItem<String>(
                                  value: "O-", child: Text("O-")),
                            ],
                            onChanged: (String? bloodgropu) {
                              setState(() {
                                selectedBloodGroup = bloodgropu!;
                              });
                            }),
                      ],
                    ),
                  ),
                ),
                // Getting the quantity of bloods
                RedCellTextField(
                    helpText: "Enter quantity of the blood in ml",
                    customHintText: "Enter value in ml",
                    inputKeyboardType: TextInputType.number,
                    textEditingController: bloodQuantityController),
                const SizedBox(height: 5),
                Center(
                  child: RedCellElevatedButton(
                    buttonText: "Search",
                    paddingLeftRight: 25,
                    buttonFunction: () {
                      log("The Blood Group is: $selectedBloodGroup");
                      log("The selected quantity is: ${bloodQuantityController.text.trim()}ml");
                      log("${data["state"]}, ${data["country"]}");
                      // Work: Implement wrong input error page.
                      // ...
                      if (bloodQuantityController.text.trim() == "" ||
                          selectedBloodGroup == "Select") {
                        redcellSnacBar(
                            context: context,
                            text: "Select Blood Group and quantity properly",
                            bgColour: const Color.fromRGBO(194, 0, 0, 1));
                      } else {
                        Navigator.push(
                          // Going to the get_nearby_bloodbanks.dart page.
                          context,
                          MaterialPageRoute(
                            builder: (context) => GetNearbyBloodBanks(
                              latitude: data["latitude"],
                              longitude: data["longitude"],
                              country: data["country"],
                              state: data["state"],
                              bloodGroup: selectedBloodGroup,
                              bloodQuantity:
                                  bloodQuantityController.text.trim(),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
