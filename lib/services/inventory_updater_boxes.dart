import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redcell_connect/components/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class UpdateInventoryBoxes extends StatefulWidget {
  final String bloodGroup;
  int singleBags;
  int doubleBags;
  int tripleBags;
  UpdateInventoryBoxes({
    super.key,
    required this.bloodGroup,
    required this.singleBags,
    required this.doubleBags,
    required this.tripleBags,
  });

  @override
  State<UpdateInventoryBoxes> createState() => _UpdateInventoryBoxesState();
}

class _UpdateInventoryBoxesState extends State<UpdateInventoryBoxes> {
  bool isloading = false;
  // Functions
  void updateDatabyBloodGroup() async {
    setState(() {
      isloading = true;
    });
    SharedPreferences documentId = await SharedPreferences.getInstance();
    final email = documentId.getString("userEmail").toString();
    try {
      switch (widget.bloodGroup) {
        case "A+":
          await FirebaseFirestore.instance
              .collection("RedCell_Connect_BloodBanks")
              .doc(email)
              .update({
            "singleA+": widget.singleBags,
            "doubleA+": widget.doubleBags,
            "tripleA+": widget.tripleBags,
          });
          break;
        case "A-":
          await FirebaseFirestore.instance
              .collection("RedCell_Connect_BloodBanks")
              .doc(email)
              .update({
            "singleA-": widget.singleBags,
            "doubleA-": widget.doubleBags,
            "tripleA-": widget.tripleBags,
          });
          break;
        case "B+":
          await FirebaseFirestore.instance
              .collection("RedCell_Connect_BloodBanks")
              .doc(email)
              .update({
            "singleB+": widget.singleBags,
            "doubleB+": widget.doubleBags,
            "tripleB+": widget.tripleBags,
          });
          break;
        case "B-":
          await FirebaseFirestore.instance
              .collection("RedCell_Connect_BloodBanks")
              .doc(email)
              .update({
            "singleB-": widget.singleBags,
            "doubleB-": widget.doubleBags,
            "tripleB-": widget.tripleBags,
          });
          break;
        case "AB+":
          await FirebaseFirestore.instance
              .collection("RedCell_Connect_BloodBanks")
              .doc(email)
              .update({
            "singleAB+": widget.singleBags,
            "doubleAB+": widget.doubleBags,
            "tripleAB+": widget.tripleBags,
          });
          break;
        case "AB-":
          await FirebaseFirestore.instance
              .collection("RedCell_Connect_BloodBanks")
              .doc(email)
              .update({
            "singleAB-": widget.singleBags,
            "doubleAB-": widget.doubleBags,
            "tripleAB-": widget.tripleBags,
          });
          break;
        case "O+":
          await FirebaseFirestore.instance
              .collection("RedCell_Connect_BloodBanks")
              .doc(email)
              .update({
            "singleO+": widget.singleBags,
            "doubleO+": widget.doubleBags,
            "tripleO+": widget.tripleBags,
          });
          break;
        case "O-":
          await FirebaseFirestore.instance
              .collection("RedCell_Connect_BloodBanks")
              .doc(email)
              .update({
            "singleO-": widget.singleBags,
            "doubleO-": widget.doubleBags,
            "tripleO-": widget.tripleBags,
          });
          break;
      }
      if (context.mounted) {
        redcellSnacBar(
            context: context,
            text: "Your data successfully saved. \n Plase Refresh",
            bgColour: Colors.green);
      }
    } catch (e) {
      if (context.mounted) {
        showAlertDialog(
            context: context,
            headertext: "Some error occured.",
            descriptionText: "Please Try again",
            contiueFunction: () => Navigator.of(context));
      }
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Blood Group: ${widget.bloodGroup}",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 23),
              ),
              ElevatedButton(
                onPressed: updateDatabyBloodGroup,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 3,
                    )),
                child: isloading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator())
                    : const Text(
                        "Save",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
              ),
            ],
          ),
          // Normal Single
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Normal - Single:",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (widget.singleBags == 0) {
                        redcellSnacBar(
                            context: context,
                            text: "Bags count cannot be negetive",
                            bgColour: Colors.red);
                      } else {
                        setState(() {
                          widget.singleBags -= 1;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.remove_circle,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "${widget.singleBags}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      if (widget.singleBags == 10000) {
                        redcellSnacBar(
                            context: context,
                            text: "Bags count cannot be more than 1000",
                            bgColour: Colors.red);
                      } else {
                        setState(() {
                          widget.singleBags += 1;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.add_circle,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
          // Normal Double
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Normal - Double:",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (widget.doubleBags == 0) {
                        redcellSnacBar(
                            context: context,
                            text: "Bags count cannot be negetive",
                            bgColour: Colors.red);
                      } else {
                        setState(() {
                          widget.doubleBags -= 1;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.remove_circle,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "${widget.doubleBags}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      if (widget.doubleBags == 10000) {
                        redcellSnacBar(
                            context: context,
                            text: "Bags count cannot be more than 1000",
                            bgColour: Colors.red);
                      } else {
                        setState(() {
                          widget.doubleBags += 1;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.add_circle,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
          // Normal Triple
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Normal - Triple:",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (widget.tripleBags == 0) {
                        redcellSnacBar(
                            context: context,
                            text: "Bags count cannot be negetive",
                            bgColour: Colors.red);
                      } else {
                        setState(() {
                          widget.tripleBags -= 1;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.remove_circle,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "${widget.tripleBags}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      if (widget.tripleBags == 1000) {
                        redcellSnacBar(
                            context: context,
                            text: "Bags count cannot be more than 1000",
                            bgColour: const Color.fromRGBO(157, 0, 0, 1));
                      } else {
                        setState(() {
                          widget.tripleBags += 1;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.add_circle,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
