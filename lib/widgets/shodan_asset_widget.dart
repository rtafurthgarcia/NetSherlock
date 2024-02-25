import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:netsherlock/models/shodan_asset_model.dart';

class ShodanAlertWidget extends StatelessWidget {
  final ShodanAsset alert;
  final void Function() onDeleteAsset;

  const ShodanAlertWidget({super.key, required this.alert, required this.onDeleteAsset});

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Asset monitoring deletion'),
          content: const Text('Are you sure you want to delete this asset monitoring?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                onDeleteAsset();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.computer,
                  size: 24.0,
                  semanticLabel: 'Computer asset',
                ),
                title: Text(
                  alert.name, 
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w800
                  ),
                ),
                subtitle: Text(
                  "Monitored since: ${DateFormat.yMd('de').format(alert.created)}", 
                  style: Theme.of(context).textTheme.bodyMedium,
                ), 
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 0.0,
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
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed:() { 
                showDeleteConfirmationDialog(context);
              }
            )
          ),
        ],
      ),
    );
  }
}