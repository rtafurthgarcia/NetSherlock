import 'package:flutter/material.dart';
import 'package:netsherlock/services/shodan_account_service.dart';
import 'package:provider/provider.dart';

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
    final shodanAccountService =  Provider.of<ShodanAccountService>(context, listen: false);
    shodanAccountService.setApiKey(_apiKeyController.text);

    if (shodanAccountService.error == null) {
      shodanAccountService.reloadDetails();
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
    return Consumer<ShodanAccountService>(
        builder: (context, shodanAccountService, child) {
      if (shodanAccountService.isLoading) {
        return const CircularProgressIndicator();
      } else if (shodanAccountService.isAuthenticated) {
        String accountName =
            "Hi, ${shodanAccountService.shodanAccount?.accountName ?? "anonymous fella"}";
        String creditsLeft =
            "You have ${shodanAccountService.shodanAccount?.creditsLeft.toString()} credit(s) left.";
        return Column(
          children: [
            Row(
              children: [
                Text(
                  accountName,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                Text(creditsLeft),
              ],
            ),
          ],
        );
      } else {
        return const Column(
          children: [
            Text(
              "Can't show you anything if you don't log-in first, chief.",
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
        Consumer<ShodanAccountService>(
          builder: (context, shodanAccountService, child) {
            if (shodanAccountService.isLoading) {
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
                    prefixIcon: const Icon(Icons.password),
                    errorText: shodanAccountService.error != null ? shodanAccountService.error.toString() : null),
                obscureText: true,
                controller: _apiKeyController,
                onChanged: (value) => shodanAccountService.setApiKey(value),
              );
            }
          },
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: ShodanAccountService.isApiKeyValid(_apiKeyController.text) == null ? _submit : null,
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.purple,
          ),
          child: const Text(
            "Test API connection",
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }

  buildSignup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an API key?"),
        TextButton(
            onPressed: () {},
            child: const Text(
              "Get one here, or create yourself an account",
              style: TextStyle(color: Colors.purple),
            )
          )
      ],
    );
  }
}
