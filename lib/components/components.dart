import 'package:flutter/material.dart';
import 'package:redcell_connect/components/theme_changer.dart';

// ======================================================

// 1. Custom TextField of the registration and login

class RedCellTextField extends StatelessWidget {
  final String helpText;
  final String customHintText;
  final TextInputType inputKeyboardType;
  final TextEditingController textEditingController;
  const RedCellTextField(
      {super.key,
      required this.helpText,
      required this.customHintText,
      required this.inputKeyboardType,
      required this.textEditingController});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                helpText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                " *",
                style: suffText,
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            keyboardType: inputKeyboardType,
            controller: textEditingController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(15, 20, 20, 10),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(114, 19, 13, 1),
                  width: 3,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              hintText: customHintText,
            ),
          )
        ],
      ),
    );
  }
}

// 2. Custom TextField for the password field of the registration and login

class RedcellPasswordField extends StatefulWidget {
  final String helpText;
  final String customHintText;
  final TextInputType inputKeyboardType;
  final IconData customPreffixIcon;
  final TextEditingController passwordController;
  const RedcellPasswordField(
      {super.key,
      required this.customHintText,
      required this.helpText,
      required this.inputKeyboardType,
      required this.customPreffixIcon,
      required this.passwordController});
  @override
  // ignore: no_logic_in_create_state
  State<RedcellPasswordField> createState() => _RedcellPasswordField(
        helpText: helpText,
        customHintText: customHintText,
        inputKeyboardType: inputKeyboardType,
        customPreffixIcon: customPreffixIcon,
        passwordController: passwordController,
      );
}

class _RedcellPasswordField extends State<RedcellPasswordField> {
  final String helpText;
  final String customHintText;
  final TextInputType inputKeyboardType;
  final IconData customPreffixIcon;
  final TextEditingController passwordController;
  bool isPasswordVisible = true;

  _RedcellPasswordField(
      {required this.helpText,
      required this.customHintText,
      required this.inputKeyboardType,
      required this.customPreffixIcon,
      required this.passwordController});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                helpText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                " *",
                style: suffText,
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: passwordController,
            obscureText: isPasswordVisible,
            keyboardType: inputKeyboardType,
            decoration: InputDecoration(
              prefixIcon: Icon(
                customPreffixIcon,
                size: 20,
              ),
              suffixIcon: IconButton(
                onPressed: () => setState(() {
                  isPasswordVisible = !isPasswordVisible;
                }),
                icon: Icon(isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
                iconSize: 20,
              ),
              contentPadding: const EdgeInsets.fromLTRB(15, 20, 20, 10),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(114, 19, 13, 1),
                  width: 3,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              hintText: customHintText,
            ),
          )
        ],
      ),
    );
  }
}

// 3. Custom Elevated button.

class RedCellElevatedButton extends StatelessWidget {
  final String buttonText;
  final double paddingLeftRight;
  final void Function()? buttonFunction;

  const RedCellElevatedButton(
      {super.key,
      required this.buttonText,
      required this.paddingLeftRight,
      this.buttonFunction});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(
          left: paddingLeftRight,
          right: paddingLeftRight,
          top: 10,
          bottom: 10,
        ),
        elevation: 3.0,
        backgroundColor: const Color.fromRGBO(194, 0, 0, 1),
      ),
      onPressed: buttonFunction,
      child: Text(
        buttonText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// 4. Login & Registration Appbar

class RedCellAuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String preffixtext;
  final String suffixtext;
  const RedCellAuthAppBar(
      {Key? key, required this.preffixtext, required this.suffixtext})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            Text(
              preffixtext,
              style: preText,
            ),
            Text(
              suffixtext,
              style: suffText,
            ),
          ],
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// 5. Snackbars

void redcellSnacBar(
    {required BuildContext context,
    required String text,
    required Color bgColour}) {
  final snackBar = SnackBar(
    content: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.white,
      ),
    ),
    backgroundColor: bgColour,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

// 6. Custom Confirmation message

showAlertDialog(
    {required BuildContext context,
    required String headertext,
    required String descriptionText,
    required Function contiueFunction}) {
  // Cancel Button
  Widget cancelButton = ElevatedButton(
    child: const Text("Cancel"),
    onPressed: () => Navigator.pop(context),
  );
  Widget continueButton = ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromRGBO(194, 0, 0, 1),
    ),
    child: const Text(
      "Continue",
      style: TextStyle(color: Colors.white),
    ),
    onPressed: () => contiueFunction(),
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      headertext,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    content: Text(
      descriptionText,
      style: const TextStyle(fontSize: 16),
    ),
    actions: [
      cancelButton,
      continueButton,
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

// 7. Blood Bank / Hospitals Profile details

class ProfileDetails extends StatelessWidget {
  final String descriptionText;
  final String infoText;
  final IconData icon;
  final bool isloading;
  const ProfileDetails(
      {super.key,
      required this.descriptionText,
      required this.infoText,
      required this.icon,
      required this.isloading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 25,
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                width: 250,
                padding: const EdgeInsets.only(left: 3),
                child: Text(
                  descriptionText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          isloading
              ? const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                )
              : Container(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text(
                    infoText,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.red),
                  ),
                ),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}

// 8. Inventory box for the blood bank.

class InventoryBoxes extends StatelessWidget {
  final String bloodQuantity;
  final String bloodType;
  final String updatedDate;
  const InventoryBoxes(
      {super.key,
      required this.bloodQuantity,
      required this.bloodType,
      required this.updatedDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 1. Blood Type
          Container(
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: Color.fromRGBO(223, 202, 202, 1),
            ),
            child: Text(
              bloodType,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black),
            ),
          ),
          // 2.  Quantity of blood
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Available: ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      bloodQuantity,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Last Updated: ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Text(
                      updatedDate,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 9. AppBar for dashboards

class RedCellHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isloading;
  final void Function()? buttonFunction;
  const RedCellHomeAppBar(
      {super.key, this.buttonFunction, required this.isloading});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Redcell Connect",
        style: suffText,
      ),
      actions: [
        Container(
          padding: const EdgeInsets.only(right: 20, left: 10),
          child: isloading
              ? const SizedBox(
                  height: 15, width: 15, child: CircularProgressIndicator())
              : IconButton(
                  icon: const Icon(Icons.refresh_sharp),
                  onPressed: buttonFunction),
        ),
      ],
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
