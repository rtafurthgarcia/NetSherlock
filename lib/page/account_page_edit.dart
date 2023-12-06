import 'package:flutter/material.dart';
import 'package:netsherlock/widget/rounded_input_field_widget.dart';

class AccountPageEdit extends StatefulWidget {
  const AccountPageEdit({super.key});

  @override
  State<AccountPageEdit> createState() => AccountPageEditState();
}

class AccountPageEditState extends State<AccountPageEdit> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late String apiKey;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Center(
              child: RoundedInputField(
              hintText: "Your Shodan API key",
              icon: Icons.key,
              cursorColor: Colors.black,
              editTextBackgroundColor: Colors.grey[200],
              iconColor: Colors.black,
              onChanged: (value) {
                apiKey = value;
              },
            )
          )
        ],
      ),
    );
  }
}
