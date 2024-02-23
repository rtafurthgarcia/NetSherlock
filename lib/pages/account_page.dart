import 'package:flutter/material.dart';
import 'package:netsherlock/shared.dart';
import 'package:netsherlock/helpers.dart';
import 'package:netsherlock/services/shodan_account_service.dart';
import 'package:netsherlock/widgets/circular_usage_widget.dart';
import 'package:netsherlock/widgets/navigationdrawer_widget.dart';
import 'package:netsherlock/widgets/qr_code_scanner_overlay.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController _apiKeyController = TextEditingController();

  bool _isScreenWide = false;

  Future<void> _launchUrl() async {
    final shodanUrl = Uri.parse("https://account.shodan.io/register");
    if (!await launchUrl(shodanUrl)) {
      throw Exception('Could not launch $shodanUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    _isScreenWide = MediaQuery.sizeOf(context).width >= Shared.MAX_SCREEN_WIDTH;

    return ChangeNotifierProvider(
      create: (context) => ShodanAccountService(),
      child: Scaffold(
        appBar: AppBar(title: const Text("NetSherlock")),
        drawer: AppNavigationDrawer(),
        body: LayoutBuilder(builder: (context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Container(
                margin: const EdgeInsets.all(24),
                child: Consumer<ShodanAccountService>(
                    builder: (context, shodanAccountService, child) {
                  if (shodanAccountService.state ==
                      ShodanServiceState.loading) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildHeader(context, shodanAccountService),
                        buildInputField(context, shodanAccountService),
                        const SizedBox(),
                        buildSignup(context, shodanAccountService),
                      ],
                    );
                  }
                }),
              ),
            ),
          );
        }),
      )
    );
  }

  buildHeader(context, ShodanAccountService shodanAccountService) {
    if (shodanAccountService.state == ShodanServiceState.initial) {
      return const Column(
        children: [
          Text(
            "Can't show you anything if you don't log-in first, chief.",
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ],
      );
    } else {
      String accountName =
          "Hi, ${shodanAccountService.shodanAccount!.plan.isNotEmpty ? shodanAccountService.shodanAccount!.plan : "anonymous fella"}";
      final usedScanCredits =
          shodanAccountService.shodanAccount!.usageLimits.scanCredits -
              shodanAccountService.shodanAccount!.scanCreditsLeft;
      final usedQueryCredits =
          shodanAccountService.shodanAccount!.usageLimits.queryCredits -
              shodanAccountService.shodanAccount!.queryCreditsLeft;
      final monitoredIps =
          shodanAccountService.shodanAccount!.usageLimits.monitoredIps -
              shodanAccountService.shodanAccount!.amountOfMonitoredIps;

      return Center(
        child: Column(
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
                      currentUsage: usedScanCredits,
                      maxUsage: shodanAccountService
                          .shodanAccount!.usageLimits.scanCredits,
                      name: "scan credit(s)",
                      message: "used."),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularUsageWidget(
                      currentUsage: usedQueryCredits,
                      maxUsage: shodanAccountService
                          .shodanAccount!.usageLimits.queryCredits,
                      name: "query credit(s)",
                      message: "used."),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularUsageWidget(
                      currentUsage: monitoredIps,
                      maxUsage: shodanAccountService
                          .shodanAccount!.usageLimits.monitoredIps,
                      name: "monitored IP(s)",
                      message: "left."),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  buildInputField(context, ShodanAccountService shodanAccountService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 10),
        Builder(
          builder: (context) {
            if (shodanAccountService.state ==
                ShodanServiceState.authenticated) {
              return const SizedBox.shrink(); // so that nothing appears
            } else {
              _apiKeyController.text = Shared.apiKey;

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
                      : null,
                  suffixIcon: Helpers.isPlateformValidForQr()
                      ? IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BarcodeScannerWithOverlay(
                                    onQrCodeDetected: (newApiKey) {
                                  if (newApiKey == null ||
                                      ShodanAccountService.validateApiKey(
                                              newApiKey) !=
                                          null) {
                                    return;
                                  }

                                  shodanAccountService.setApiKey(newApiKey);
                                  shodanAccountService.load();
                                  Navigator.pop(context);
                                }),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.qr_code_scanner,
                          ),
                        )
                      : null,
                ),
                obscureText: true,
                controller: _apiKeyController,
                onChanged: (String newText) =>
                    shodanAccountService.setApiKey(_apiKeyController.text),
              );
            }
          },
        ),
        const SizedBox(height: 10),
        Builder(builder: (context) {
          dynamic callBack;
          if (shodanAccountService.state == ShodanServiceState.authenticated) {
            callBack = shodanAccountService.clearDetails;
          } else if (shodanAccountService.error == null) {
            callBack = shodanAccountService.load;
          }

          return FilledButton(
            onPressed: callBack,
            style: FilledButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20)),
            child: Text(
                shodanAccountService.state == ShodanServiceState.authenticated
                    ? "Log-out"
                    : "Log-in"),
          );
        })
      ],
    );
  }

  buildSignup(context, ShodanAccountService shodanAccountService) {
    return Builder(builder: (context) {
      if (shodanAccountService.state == ShodanServiceState.authenticated) {
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
                ))
          ],
        );
      }
    });
  }
}
