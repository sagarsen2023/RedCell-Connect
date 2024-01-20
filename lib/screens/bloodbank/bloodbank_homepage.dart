import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redcell_connect/components/components.dart';
import 'package:redcell_connect/screens/auth/edit_details.dart';
import 'package:redcell_connect/screens/bloodbank/bloodbank_inventory_update.dart';
import 'package:redcell_connect/services/get_database_data.dart';

class BloodBankHomePage extends StatefulWidget {
  const BloodBankHomePage({super.key});

  @override
  State<BloodBankHomePage> createState() => _BloodBankHomePageState();
}

class _BloodBankHomePageState extends State<BloodBankHomePage> {
  Map<String, dynamic> data = {};
  bool isLoading = false;

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    data = await fetchDataFromDocument("RedCell_Connect_BloodBanks");
    await calculateTotal("A+");
    await calculateTotal("A-");
    await calculateTotal("B+");
    await calculateTotal("B-");
    await calculateTotal("AB+");
    await calculateTotal("AB-");
    await calculateTotal("O+");
    await calculateTotal("O-");
    data = await fetchDataFromDocument("RedCell_Connect_BloodBanks");
    log("$data");
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    await fetchData();
    if (data.isEmpty && context.mounted) {
      showAlertDialog(
          context: context,
          headertext: "Error",
          descriptionText:
              "Network error or server error. Make sure you are connected to the internet.",
          contiueFunction: () => Navigator.pop(context));
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> calculateTotal(String bloodType) async {
    int result = 0;
    if (data["single$bloodType"] == null ||
        data["double$bloodType"] == null ||
        data["triple$bloodType"] == null) {
      if (data["single$bloodType"] != null) {
        result += (data["single$bloodType"] as int) * 250;
      }
      if (data["double$bloodType"] != null) {
        result += (data["double$bloodType"] as int) * 350;
      }
      if (data["triple$bloodType"] != null) {
        result += (data["triple$bloodType"] as int) * 450;
      }
    } else {
      result = (data["single$bloodType"] * 250) +
          (data["double$bloodType"] * 350) +
          (data["triple$bloodType"] * 450);
    }
    try {
      await FirebaseFirestore.instance
          .collection("RedCell_Connect_BloodBanks")
          .doc(data["email"])
          .update({
        "total$bloodType": result,
      });
    } catch (e) {
      if (context.mounted) {
        redcellSnacBar(
            context: context,
            text: "Some error occured",
            bgColour: const Color.fromRGBO(157, 0, 0, 1));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    int nullChecker(var value) {
      if (value == null) {
        return 0;
      } else {
        return value as int;
      }
    }

    return Scaffold(
      appBar: RedCellHomeAppBar(
          buttonFunction: () async {
            setState(() {
              isLoading = true;
            });
            await refreshData();
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          },
          isloading: isLoading),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // blood bank details
            Container(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Blood Bank details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Showing the blood bank details
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileDetails(
                              isloading: isLoading,
                              icon: Icons.person,
                              descriptionText: "Name",
                              infoText: "${data["name"]}"),
                          ProfileDetails(
                              isloading: isLoading,
                              icon: Icons.phone,
                              descriptionText: "Phone",
                              infoText: "${data["phone"]}"),
                          ProfileDetails(
                              isloading: isLoading,
                              icon: Icons.person_4,
                              descriptionText: "Contact Person",
                              infoText: "${data["contactPerson"]}"),
                          ProfileDetails(
                              isloading: isLoading,
                              icon: Icons.phone_android_rounded,
                              descriptionText: "Contact Person Phone",
                              infoText: "${data["contactPersonPhone"]}"),
                        ],
                      ),
                    ),
                  ),
                  // const SizedBox(height: 15),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: RedCellElevatedButton(
                      buttonText: "Edit Details",
                      paddingLeftRight: 20,
                      buttonFunction: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileDetails(collectionName: "RedCell_Connect_BloodBanks"),
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 3,
                    indent: 150,
                    endIndent: 150,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.warning,
                          size: 18,
                        ),
                        Text(
                          "Keep the inventory up to date",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.warning,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            // Inventory management
            Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(157, 0, 0, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Inventory",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 10,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      const UpdateInventory())));
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Edit",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InventoryBoxes(
                      bloodQuantity: "${nullChecker(data["totalA+"])} ml",
                      bloodType: "A+",
                      updatedDate: "Under development"),
                  InventoryBoxes(
                      bloodQuantity: "${nullChecker(data["totalA-"])} ml",
                      bloodType: "A-",
                      updatedDate: "Under development"),
                  InventoryBoxes(
                      bloodQuantity: "${nullChecker(data["totalB+"])} ml",
                      bloodType: "B+",
                      updatedDate: "Under development"),
                  InventoryBoxes(
                      bloodQuantity: "${nullChecker(data["totalB-"])} ml",
                      bloodType: "B-",
                      updatedDate: "Under development"),
                  InventoryBoxes(
                      bloodQuantity: "${nullChecker(data["totalAB+"])} ml",
                      bloodType: "AB+",
                      updatedDate: "Under development"),
                  InventoryBoxes(
                      bloodQuantity: "${nullChecker(data["totalAB-"])} ml",
                      bloodType: "AB-",
                      updatedDate: "Under development"),
                  InventoryBoxes(
                      bloodQuantity: "${nullChecker(data["totalO+"])} ml",
                      bloodType: "O+",
                      updatedDate: "Under development"),
                  InventoryBoxes(
                      bloodQuantity: "${nullChecker(data["totalO-"])} ml",
                      bloodType: "O-",
                      updatedDate: "Under development"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
