import 'package:flutter/material.dart';
import 'package:netsherlock/models/shodan_asset_model.dart';
import 'package:netsherlock/services/shodan_account_service.dart';
import 'package:netsherlock/services/shodan_assets_service.dart';
import 'package:netsherlock/shared.dart';
import 'package:netsherlock/pages/asset_creation_page.dart';
import 'package:netsherlock/widgets/custom_error_widget.dart';
import 'package:netsherlock/widgets/navigationdrawer_widget.dart';
import 'package:netsherlock/widgets/shodan_asset_widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({super.key});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ShodanAccountService>(create: (_) => ShodanAccountService()),
        ChangeNotifierProvider<ShodanAssetsService>(create: (_) => ShodanAssetsService()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text ("NetSherlock")),
        drawer: AppNavigationDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed("/assets/new");
          },
          child: const Icon(Icons.add),
        ),
        body: Consumer<ShodanAssetsService>(
          builder: (context, shodanAssetsservice, child) {
            if (shodanAssetsservice.state == ShodanState.error) {
              return CustomErrorWidget(errorMessage: shodanAssetsservice.error.toString());
            }

            final assets = shodanAssetsservice.state == ShodanState.loading ? 
              List.generate(
                5, (index) => ShodanAsset(
                  id: "FAKEFAKEFAKEFAKE",
                  name: "New service",
                  created: DateTime.now(),
                  expiration: DateTime.now().add(const Duration(days: 30)), 
                  ips: List<String>.from({"127.0.0.1", "127.0.0.2"})
                )
            ) : shodanAssetsservice.assets;

            return Skeletonizer(
              enabled: shodanAssetsservice.state == ShodanState.loading,
              child: RefreshIndicator(
                onRefresh: () => _pullRefresh(shodanAssetsservice),
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: assets!.length,
                  itemBuilder: (BuildContext context, index) {
                    return ShodanAlertWidget(
                      alert: assets[index],
                      onDeleteAsset: () => shodanAssetsservice.deleteAsset(assets[index].id)
                    );
                  }
                ),
              ),
            );
          }
        ),
      )
    );
  }

  Future<void> _pullRefresh(ShodanAssetsService shodanAssetsService) async {
    shodanAssetsService.loadAssets();
  }
}