import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:netsherlock/models/new_shodan_asset_model.dart';
import 'package:netsherlock/services/shodan_assets_service.dart';
import 'package:netsherlock/shared.dart';
import 'package:provider/provider.dart';

class AssetCreationPage extends StatefulWidget {
  const AssetCreationPage({super.key});
  
  _AssetCreationPageState createState() => _AssetCreationPageState();
}

class _AssetCreationPageState extends State<AssetCreationPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController ipController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ShodanAssetsService(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text ("Create a new asset to monitor"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(6.0),
            child: Consumer<ShodanAssetsService>(
              builder: (context, shodanAssetsService, child) {
                if (shodanAssetsService.state == ShodanState.loading) {
                  return const LinearProgressIndicator();
                } else {
                  return Container();
                }
              }
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Asset name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: ipController,
                      decoration: const InputDecoration(labelText: 'IP address(es), separated with a space'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an IP address ';
                        }

                        final possibleIpAddresses = value.split(" ");

                        // IPv4 regex pattern
                        final ipv4Pattern =
                            RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');

                        // IPv6 regex pattern
                        final ipv6Pattern = RegExp(
                            r'^([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}$|^([0-9a-fA-F]{1,4}:){1,7}:|^([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}$|^([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}$|^([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}$|^([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}$|^([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}$|^[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})$|:^:((:[0-9a-fA-F]{1,4}){0,6})$');

                        bool areIpsValid = possibleIpAddresses.every((ip) => (ipv4Pattern.hasMatch(ip) || ipv6Pattern.hasMatch(ip)));

                        if(! areIpsValid) {
                          return 'Enter a valid IPv4 or IPv6 address';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Consumer<ShodanAssetsService>(
                      builder: (context, shodanAssetsService, child) {
                        return ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              String title = titleController.text;
                              List<String> ips = ipController.text.split(' ');
                  
                              await shodanAssetsService.createAsset(
                                NewShodanAsset(name: title, ips: ips)
                              );

                              if (shodanAssetsService.state == ShodanState.error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                  content: Text(shodanAssetsService.error.toString()),
                                  action: SnackBarAction(
                                    label: "It's Joever",
                                    onPressed: () {
                                      // accept my fate.
                                    }),
                                  )
                                );
                              } else {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          child: const Text('Create'),
                        );
                      }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}