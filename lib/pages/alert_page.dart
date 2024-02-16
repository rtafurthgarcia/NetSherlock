import 'package:flutter/material.dart';
import 'package:netsherlock/widgets/navigationdrawer_widget.dart';
import 'package:provider/provider.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final List<String> entries = <String>['A', 'B', 'C'];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text ("NetSherlock")),
      drawer: const AppNavigationDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, index) {
          return Container(
            height: 50,
            child: Center(child: Text('Entry ${entries[index]}')),
          );
        }
      ),
    );
  }
}