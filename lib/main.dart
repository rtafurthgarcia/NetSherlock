import 'package:flutter/material.dart';
import 'package:netsherlock/widget/navigationdrawer_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const AppNavigationDrawer(),
    );
  }
}
