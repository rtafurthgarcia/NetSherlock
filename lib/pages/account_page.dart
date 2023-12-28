import 'package:flutter/material.dart';
import 'package:netsherlock/services/shodan_account_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fl_chart/fl_chart.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  void _submit() {
    final shodanAccountService = Provider.of<ShodanAccountService>(context, listen: false);

    if (shodanAccountService.error == null) {
      shodanAccountService.reloadDetails();
    }
  }

  Future<void> _launchUrl() async {
    final shodanUrl =  Uri.parse("https://account.shodan.io/register");
    if (!await launchUrl(shodanUrl)) {
      throw Exception('Could not launch $shodanUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildHeader(context),
              buildInputField(context),
              buildSignup(context),
            ],
          ),
        ),
      ),
    );
  }

  buildHeader(context) {
    return Consumer<ShodanAccountService>(builder: (context, shodanAccountService, child) {
      if (shodanAccountService.state == ShodanAccountState.loading) {
        return const CircularProgressIndicator();
      } else if (shodanAccountService.state == ShodanAccountState.authenticated) {
        String accountName =
            "Hi, ${shodanAccountService.shodanAccount!.plan.isNotEmpty ? shodanAccountService.shodanAccount!.plan : "anonymous fella"}";
        String scanCreditsLeft =
            "You have ${shodanAccountService.shodanAccount!.scanCreditsLeft.toString()} scan credit(s) left.";
        String queryCreditsLeft =
            "You have ${shodanAccountService.shodanAccount!.queryCreditsLeft.toString()} query credit(s) left.";
        return Column(
          children: [
            Row(
              children: [
                Text(
                  accountName,
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                Text(scanCreditsLeft),
              ],
            ),
            Row(
              children: [
                Text(queryCreditsLeft),
              ],
            ),
          ],
        );
      } else {
        return const Column(
          children: [
            Text(
              "Can't show you anything if you don't log-in first, chief.",
              overflow: TextOverflow.visible,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ],
        );
      }
    });
  }

  buildInputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        Consumer<ShodanAccountService>(builder: (context, shodanAccountService, child) {
            if (shodanAccountService.state == ShodanAccountState.loading) {
              return const CircularProgressIndicator();
            } else {
              _apiKeyController.text = shodanAccountService.apiKey;

              return TextField(
                decoration: InputDecoration(
                    hintText: "Shodan API Key",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: Colors.purple.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.key),
                    errorText: shodanAccountService.error != null
                        ? shodanAccountService.error.toString()
                        : null),
                obscureText: true,
                controller: _apiKeyController,
                onChanged: (String newText) => shodanAccountService.setApiKey(_apiKeyController.text),
              );
            }
          },
        ),
        const SizedBox(height: 10),
        Consumer<ShodanAccountService>(
            builder: (context, shodanAccountService, child) {
          return ElevatedButton(
            onPressed: shodanAccountService.error == null ? _submit : null,
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
              backgroundColor: Colors.purple,
            ),
            child: const Text(
              "Log-in",
              style: TextStyle(fontSize: 20),
            ),
          );
        })
      ],
    );
  }

  buildSignup(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("You don't have an API key yet?"),
        TextButton(
            onPressed: _launchUrl,
            child: const Text(
              "Get one here, or create yourself an account",
              overflow: TextOverflow.visible,
              style: TextStyle(color: Colors.purple),
            ))
      ],
    );
  }
}
