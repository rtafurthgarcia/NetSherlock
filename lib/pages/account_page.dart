import 'package:flutter/material.dart';
import 'package:netsherlock/consts.dart';
import 'package:netsherlock/services/shodan_account_service.dart';
import 'package:netsherlock/widgets/circular_usage_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isScreenWide = false;

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl() async {
    final shodanUrl = Uri.parse("https://account.shodan.io/register");
    if (!await launchUrl(shodanUrl)) {
      throw Exception('Could not launch $shodanUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    _isScreenWide = MediaQuery.sizeOf(context).width >= Consts.MAX_SCREEN_WIDTH;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Container(
                  margin: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildHeader(context),
                      buildInputField(context),
                      const SizedBox(),
                      buildSignup(context),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  buildHeader(context) {
    return Center(
      child: Consumer<ShodanAccountService>(
          builder: (context, shodanAccountService, child) {
        if (shodanAccountService.state == ShodanAccountState.loading) {
          return const CircularProgressIndicator();
        } else if (shodanAccountService.state ==
            ShodanAccountState.authenticated) {
          String accountName =
              "Hi, ${shodanAccountService.shodanAccount!.plan.isNotEmpty ? shodanAccountService.shodanAccount!.plan : "anonymous fella"}";
          return Column(
            children: [
              Text(
                accountName,
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Flex(
                direction: _isScreenWide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularUsageWidget(
                        currentUsage:
                            shodanAccountService.shodanAccount!.scanCreditsLeft,
                        maxUsage: 100,
                        name: "scan credit(s)"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularUsageWidget(
                        currentUsage:
                            shodanAccountService.shodanAccount!.queryCreditsLeft,
                        maxUsage: 100,
                        name: "query credit(s)"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularUsageWidget(
                        currentUsage: shodanAccountService
                            .shodanAccount!.amountOfMonitoredIps,
                        maxUsage: 100,
                        name: "monitored IP(s)"),
                  ),
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
      }),
    );
  }

  buildInputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 10),
        Consumer<ShodanAccountService>(
          builder: (context, shodanAccountService, child) {
            if (shodanAccountService.state == ShodanAccountState.loading) {
              return const CircularProgressIndicator();
            } else if (shodanAccountService.state ==
                ShodanAccountState.authenticated) {
              return const SizedBox.shrink(); // so that nothing appears
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
                onChanged: (String newText) =>
                    shodanAccountService.setApiKey(_apiKeyController.text),
              );
            }
          },
        ),
        const SizedBox(height: 10),
        Consumer<ShodanAccountService>(
          builder: (context, shodanAccountService, child) {
            dynamic callBack = null;
            if (shodanAccountService.state == ShodanAccountState.authenticated) {
              callBack = shodanAccountService.clearDetails;
            } else if (shodanAccountService.error == null) {
              callBack = shodanAccountService.reloadDetails;
            }

            return ElevatedButton(
              onPressed: callBack,
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                backgroundColor: Colors.purple,
              ),
              child: Text(
                shodanAccountService.state == ShodanAccountState.authenticated ? "Log-out" : "Log-in",
                style: const TextStyle(fontSize: 20),
              ),
          );
        })
      ],
    );
  }

  buildSignup(context) {
    return Selector<ShodanAccountService, ShodanAccountState>(
        selector: (_, shodanAccountService) => shodanAccountService.state,
        builder: (context, shodanAccountState, child) 
      {
        if (shodanAccountState == ShodanAccountState.authenticated) {
          return const SizedBox.shrink();
        } else {
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
    );
  }
}
