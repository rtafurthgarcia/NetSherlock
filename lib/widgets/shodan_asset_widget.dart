import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:netsherlock/models/shodan_asset_model.dart';
import 'package:intl/date_symbol_data_local.dart'; // for other locales

class ShodanAlertWidget extends StatelessWidget {
  final ShodanAsset alert;

  const ShodanAlertWidget({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
        color: Theme.of(context).cardColor
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          const Icon(
            Icons.computer,
            size: 24.0,
            semanticLabel: 'Alert',
          ),
          const SizedBox(width: 16,),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(alert.name, style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w800
                    ),),
                    
                  ],
                ),
                const SizedBox(height: 4,),
                Text(DateFormat.yMd('de').format(alert.created), style: Theme.of(context).textTheme.bodyMedium,),
                Wrap(
                  spacing: 8.0,
                  children: [
                  ...alert.ips.map((String ip) {
                    return Chip(
                      padding: const EdgeInsets.all(0),

                      backgroundColor: Theme.of(context).colorScheme.onSecondary,
                      label: Text(
                        ip, 
                        style: Theme.of(context).textTheme.labelSmall,
                      )
                    );
                  })
                ],)
              ],
            ),
          )
        ],
      ),
    );
  }
}