import 'package:flutter/material.dart';
import 'package:netsherlock/widget/rounded_input_field_widget.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late String apiKey;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
      child: Column(children: [
        Text("AccountName"),
        Text("Account type"),
        ElevatedButton.icon(
          icon: Icon(Icons.edit_square),
          label: Text('Edit'),
          onPressed: () => {},
        ),
      ]),
    ));
  }
}
