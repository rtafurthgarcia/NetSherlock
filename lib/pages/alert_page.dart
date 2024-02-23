import 'package:flutter/material.dart';
import 'package:netsherlock/models/shodan_alert_model.dart';
import 'package:netsherlock/services/shodan_account_service.dart';
import 'package:netsherlock/services/shodan_alerts_service.dart';
import 'package:netsherlock/shared.dart';
import 'package:netsherlock/widgets/custom_error_widget.dart';
import 'package:netsherlock/widgets/navigationdrawer_widget.dart';
import 'package:netsherlock/widgets/shodan_alert_widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ShodanAccountService>(create: (_) => ShodanAccountService()),
        ChangeNotifierProvider<ShodanAlertsService>(create: (_) => ShodanAlertsService()),
      ],
      child: Scaffold(
          appBar: AppBar(title: const Text ("NetSherlock")),
          drawer: AppNavigationDrawer(),
          body: Consumer<ShodanAlertsService>(
            builder: (context, shodanAlertsService, child) {
              if (shodanAlertsService.state == ShodanServiceState.error) {
                return CustomErrorWidget(errorMessage: shodanAlertsService.error.toString());
              }

              final alerts = shodanAlertsService.state == ShodanServiceState.loading ? 
                List.generate(
                  5, (index) => ShodanAlert(
                    id: "FAKEFAKEFAKEFAKE",
                    name: "New service",
                    created: DateTime.now(),
                    expiration: DateTime.now().add(const Duration(days: 30))
                  )
              ) : shodanAlertsService.alerts;

              return Skeletonizer(
                enabled: shodanAlertsService.state == ShodanServiceState.loading,
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: alerts!.length,
                  itemBuilder: (BuildContext context, index) {
                    return ShodanAlertWidget(alert: alerts[index]);
                  }
                ),
              );
            }
          ),
        )
    );
  }
}