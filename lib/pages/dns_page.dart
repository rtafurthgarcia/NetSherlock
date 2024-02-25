import 'package:flutter/material.dart';
import 'package:netsherlock/models/shodan_asset_model.dart';
import 'package:netsherlock/models/shodan_dns_entry.dart';
import 'package:netsherlock/services/shodan_account_service.dart';
import 'package:netsherlock/services/shodan_assets_service.dart';
import 'package:netsherlock/services/shodan_domain_service.dart';
import 'package:netsherlock/shared.dart';
import 'package:netsherlock/pages/asset_creation_page.dart';
import 'package:netsherlock/widgets/custom_error_widget.dart';
import 'package:netsherlock/widgets/navigationdrawer_widget.dart';
import 'package:netsherlock/widgets/shodan_asset_widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DNSPage extends StatefulWidget {
  const DNSPage({super.key});

  @override
  State<DNSPage> createState() => _DNSPageState();
}

class _DNSPageState extends State<DNSPage> {
  final TextEditingController domainNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ShodanAccountService>(create: (_) => ShodanAccountService()),
        ChangeNotifierProvider<ShodanDomainService>(create: (_) => ShodanDomainService()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text ("Domain look-up"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(6.0),
            child: Consumer<ShodanDomainService>(
              builder: (context, shodanDomainService, child) {
                if (shodanDomainService.state == ShodanState.loading) {
                  return const LinearProgressIndicator();
                } else {
                  return Container();
                }
              }
            ),
          ),
        ),
        drawer: AppNavigationDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Consumer<ShodanDomainService>(
            builder: (context, shodanDomainService, child) {
              return Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: domainNameController,
                          decoration: const InputDecoration(labelText: ''),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a domain name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              String domain = domainNameController.text;
                  
                              await shodanDomainService.lookupDomain(domain);

                              if (shodanDomainService.state == ShodanState.error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                  content: Text(shodanDomainService.error.toString()),
                                  action: SnackBarAction(
                                    label: "It's Joever",
                                    onPressed: () {
                                      // accept my fate.
                                    }),
                                  )
                                );
                              }
                            }
                          },
                          child: const Text('Look-up'),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                  shodanDomainService.state != ShodanState.initial ? generateListViewResults(shodanDomainService) : Container()
                ],
              );
            }
          ),
        ),     )
    );
  }

  Widget generateListViewResults(ShodanDomainService shodanDomainService) {
    final subdomains = shodanDomainService.state == ShodanState.loading ? 
      /*List.generate(
        5, (index) => ShodanDNSEntry(
          subdomain: "", 
          type: "MX", 
          value: "mx.domain.example", 
          lastSeen: DateTime.now())
        )*/
      List.generate(5, (index) => "bs.domain.example")
      : shodanDomainService.result!.subdomains;

    return Skeletonizer(
      enabled: shodanDomainService.state == ShodanState.loading,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Subdomains:", 
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w800
              ),
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: subdomains.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, index) {
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        subdomains[index].toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  ]
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}