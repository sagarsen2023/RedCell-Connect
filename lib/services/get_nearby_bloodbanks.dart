import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redcell_connect/components/components.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GetNearbyBloodBanks extends StatefulWidget {
  final String country;
  final String state;
  final String bloodGroup;
  final String bloodQuantity;
  final String latitude;
  final String longitude;
  const GetNearbyBloodBanks(
      {super.key,
      required this.country,
      required this.state,
      required this.bloodGroup,
      required this.bloodQuantity,
      required this.latitude,
      required this.longitude});

  @override
  State<GetNearbyBloodBanks> createState() => _GetNearbyBloodBanksState();
}

class _GetNearbyBloodBanksState extends State<GetNearbyBloodBanks> {
  bool isLoading = false;
  Map<double, Map<String, dynamic>> data = {};
  List<double> sortedData = [];
  late Future<void> fetchData;

  Future<void> fetchDocumentsWithFields() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    final int qnty = int.parse(widget.bloodQuantity);
    final double lat = double.parse(widget.latitude);
    final double long = double.parse(widget.longitude);
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("RedCell_Connect_BloodBanks")
              .where("country", isEqualTo: widget.country)
              .where("state", isEqualTo: widget.state)
              .where("total${widget.bloodGroup}", isGreaterThanOrEqualTo: qnty)
              .get();
      if (querySnapshot.docs.isEmpty) {
        log('No data');
      } else {
        for (QueryDocumentSnapshot<Map<String, dynamic>> document
            in querySnapshot.docs) {
          double distance = Geolocator.distanceBetween(
            lat,
            long,
            double.parse(document.get("latitude")),
            double.parse(document.get("longitude")),
          );
          data[distance] = document.data(); // Fix here
        }
        sortedData = data.keys.toList()..sort();
        for (int i = 0; i < data.length; i++) {
          log("${sortedData[i]}meters : ${data[sortedData[i]]}");
        }
      }
    } catch (e) {
      if (context.mounted) {
        redcellSnacBar(
            context: context,
            text: "Connection error",
            bgColour: const Color.fromRGBO(157, 0, 0, 1));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Launching Google maps
  Future<void> _launchMaps(double latitude, double longitude) async {
    final String mapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    try {
      await launchUrlString(mapsUrl);
    } catch (e) {
      if (context.mounted) {
        redcellSnacBar(
            context: context,
            text: "Google Maps not installed. ",
            bgColour: Colors.red);
      }
    }
  }

  // Launching dialer
  Future<void> _launchDialer(int phoneNumber) async {
    final String dialerUrl = "tel:$phoneNumber";
    try {
      await launchUrlString(dialerUrl);
    } catch (e) {
      if (context.mounted) {
        redcellSnacBar(
            context: context, text: "Some error occured", bgColour: Colors.red);
      }
    }
  }

  phoneNumberSelector(
      {required BuildContext context,
      required int bloodBankPhone,
      required int contactPersonPhone}) {
    // Cancel button
    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () => Navigator.pop(context),
    );

    // BloodBank
    Widget bloodBank = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(194, 0, 0, 1),
      ),
      child: const Text(
        "Phone 1",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        _launchDialer(bloodBankPhone);
        Navigator.pop(context);
      },
    );

    // Contact Person
    Widget contactPerson = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(194, 0, 0, 1),
        ),
        child: const Text(
          "Phone 2",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          _launchDialer(contactPersonPhone);
          Navigator.pop(context);
        });
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Direct Call",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text(
        "Select which number you want to call",
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        cancelButton,
        bloodBank,
        contactPerson,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData = fetchDocumentsWithFields();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RedCellHomeAppBar(
          isloading: isLoading, buttonFunction: fetchDocumentsWithFields),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: fetchData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  // If there is no data available
                  if (data.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 40.0,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "No data available",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // If there is data
                    return ListView.builder(
                      controller: ScrollController(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(
                              left: 25, right: 25, bottom: 15),
                          padding: const EdgeInsets.only(
                              left: 10, top: 15, bottom: 15, right: 10),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(157, 0, 0, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Blood Bank: ${index + 1}:",
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 9),
                              // Name of Blood Bank
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.business_center,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 5),
                                    width: 250,
                                    child: Text(
                                        "${data[sortedData[index]]!["name"]}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Phone number 1 of the blood bank
                              Row(
                                children: [
                                  const Icon(Icons.phone, color: Colors.white),
                                  Container(
                                    padding: const EdgeInsets.only(left: 5),
                                    width: 250,
                                    child: Text(
                                        "${data[sortedData[index]]!["phone"]}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Contact Person Name
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.person_2_rounded,
                                      color: Colors.white),
                                  Container(
                                    padding: const EdgeInsets.only(left: 5),
                                    width: 250,
                                    child: Text(
                                        "${data[sortedData[index]]!["contactPerson"]}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Phone number 2 of the blood bank
                              Row(
                                children: [
                                  const Icon(Icons.phone_android,
                                      color: Colors.white),
                                  Container(
                                    padding: const EdgeInsets.only(left: 5),
                                    width: 250,
                                    child: Text(
                                        "${data[sortedData[index]]!["contactPersonPhone"]}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Total Available Qnty
                              Row(
                                children: [
                                  const Icon(Icons.water_drop_rounded,
                                      color: Colors.white),
                                  Container(
                                    padding: const EdgeInsets.only(left: 5),
                                    width: 250,
                                    child: Text(
                                      "Blood Group: ${widget.bloodGroup}, Qnty: ${data[sortedData[index]]!["total${widget.bloodGroup}"]}ml",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Button for google map redirection
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black),
                                    onPressed: () {
                                      _launchMaps(
                                          double.parse(data[sortedData[index]]![
                                              "latitude"]),
                                          double.parse(data[sortedData[index]]![
                                              "longitude"]));
                                    },
                                    child: const Text(
                                      "Direction",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  // Button for Calling
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 30, 122, 33),
                                    ),
                                    onPressed: () {
                                      phoneNumberSelector(
                                          context: context,
                                          bloodBankPhone: int.parse(data[
                                              sortedData[index]]!["phone"]),
                                          contactPersonPhone: int.parse(
                                              data[sortedData[index]]![
                                                  "contactPersonPhone"]));
                                    },
                                    child: const Text(
                                      "Call",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
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
