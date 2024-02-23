import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:netsherlock/models/shodan_alert_model.dart';

class ShodanAlertWidget extends StatelessWidget {
  final ShodanAlert alert;

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
            Icons.warning_rounded,
            size: 24.0,
            semanticLabel: 'Alert',
          ),
          const SizedBox(width: 16,),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.name, style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w800
                ),),
                const SizedBox(height: 4,),
                Text(alert.created.toString(), style: Theme.of(context).textTheme.bodyMedium,)
              ],
            ),
          )
        ],
      ),
    );
  }
}