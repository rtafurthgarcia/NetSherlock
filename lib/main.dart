import 'package:flutter/material.dart';
import 'package:netsherlock/services/shodan_account_service.dart';
import 'package:netsherlock/widgets/navigationdrawer_widget.dart';
import 'package:provider/provider.dart';

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
      home: ChangeNotifierProvider(
        create: (context) => ShodanAccountService(),
        child: const AppNavigationDrawer(),
      ),
    );
  }
}
