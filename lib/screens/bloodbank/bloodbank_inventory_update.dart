import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:redcell_connect/components/components.dart';
import 'package:redcell_connect/services/get_database_data.dart';
import 'package:redcell_connect/services/inventory_updater_boxes.dart';

class UpdateInventory extends StatefulWidget {
  const UpdateInventory({super.key});

  @override
  State<UpdateInventory> createState() => _UpdateInventoryState();
}

class _UpdateInventoryState extends State<UpdateInventory> {
  Map<String, dynamic> data = {};
  bool isLoading = false; // For the progress indicator

  // This function will be used for the data fetching
  Future<void> fetchData() async {
    log("Function called");
    data = await fetchDataFromDocument("RedCell_Connect_BloodBanks");
    log("$data");
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function of the refresh button
  Future<void> refreshData() async {
    await fetchData();
    if (data.isEmpty && context.mounted) {
      showAlertDialog(
          context: context,
          headertext: "Error",
          descriptionText:
              "Network error or server error. Make sure you are connected to the internet.",
          contiueFunction: refreshData);
    }
    if (mounted) {
      setState(() {});
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
          log("message");
          await refreshData();
          log("After message");
          setState(() {
            isLoading = false;
          });
        },
        isloading: isLoading,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 8, left: 25, right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Portion
                  const Text(
                    "Blood Bag Types: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Blood Bag details
                  Container(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, bottom: 10),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(157, 0, 0, 1),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: const Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Normal - Single: ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              "250 ml",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Normal - Double: ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              "350 ml",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Normal - Triple: ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              "450 ml",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            const Divider(
              thickness: 3,
              indent: 150,
              endIndent: 150,
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(157, 0, 0, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  )),
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Update Inventory",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.warning,
                          size: 18,
                          color: Colors.white,
                        ),
                        Text(
                          "Adjust the quantity of bags.",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Icon(
                          Icons.warning,
                          size: 18,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // // Blood Group: A+
                  UpdateInventoryBoxes(
                      bloodGroup: "A+",
                      singleBags: nullChecker(data["singleA+"]),
                      doubleBags: nullChecker(data["doubleA+"]),
                      tripleBags: nullChecker(data["tripleA+"])),
                  // // Blood Group A-
                  UpdateInventoryBoxes(
                      bloodGroup: "A-",
                      singleBags: nullChecker(data["singleA-"]),
                      doubleBags: nullChecker(data["doubleA-"]),
                      tripleBags: nullChecker(data["tripleA-"])),
                  // // Blood Group B+
                  UpdateInventoryBoxes(
                      bloodGroup: "B+",
                      singleBags: nullChecker(data["singleB+"]),
                      doubleBags: nullChecker(data["doubleB+"]),
                      tripleBags: nullChecker(data["tripleB+"])),
                  // // Blood Group B-
                  UpdateInventoryBoxes(
                      bloodGroup: "B-",
                      singleBags: nullChecker(data["singleB-"]),
                      doubleBags: nullChecker(data["doubleB-"]),
                      tripleBags: nullChecker(data["tripleB-"])),
                  // // Blood Group AB+
                  UpdateInventoryBoxes(
                    bloodGroup: "AB+",
                    singleBags: nullChecker(data["singleAB+"]),
                    doubleBags: nullChecker(data["doubleAB+"]),
                    tripleBags: nullChecker(data["tripleAB+"]),
                  ),
                  // // Blood Group AB-
                  UpdateInventoryBoxes(
                      bloodGroup: "AB-",
                      singleBags: nullChecker(data["singleAB-"]),
                      doubleBags: nullChecker(data["doubleAB-"]),
                      tripleBags: nullChecker(data["tripleAB-"])),
                  // // Blood Group O+
                  UpdateInventoryBoxes(
                      bloodGroup: "O+",
                      singleBags: nullChecker(data["singleO+"]),
                      doubleBags: nullChecker(data["doubleO+"]),
                      tripleBags: nullChecker(data["tripleO+"])),
                  // // Blood Group O-
                  UpdateInventoryBoxes(
                      bloodGroup: "O-",
                      singleBags: nullChecker(data["singleO-"]),
                      doubleBags: nullChecker(data["doubleO-"]),
                      tripleBags: nullChecker(data["tripleO-"])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
