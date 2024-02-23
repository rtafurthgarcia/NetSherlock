import 'package:flutter/material.dart';
import 'package:netsherlock/services/shodan_account_service.dart';
import 'package:provider/provider.dart';
import 'package:netsherlock/shared.dart';

class DrawerDestination {
  const DrawerDestination({required this.label, required this.icon, required this.selectedIcon, required this.routeName});

  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final String routeName;
}

const List<DrawerDestination> destinations = <DrawerDestination>[
  DrawerDestination(label: 'Account', icon: Icon(Icons.account_circle_outlined), selectedIcon: Icon(Icons.account_circle), routeName: "/account"),
  DrawerDestination(label: 'Alerts', icon: Icon(Icons.warning_amber_outlined), selectedIcon: Icon(Icons.warning_amber), routeName: "/alerts"),
  DrawerDestination(label: 'Scans', icon: Icon(Icons.domain_verification_outlined), selectedIcon: Icon(Icons.domain_verification), routeName: "/scans"),
  DrawerDestination(label: 'DNS', icon: Icon(Icons.dns_outlined), selectedIcon: Icon(Icons.dns), routeName: "/dns"),
];

class AppNavigationDrawer extends StatefulWidget {
  AppNavigationDrawer({super.key});
  
  int screenIndex = 0;

  @override
  State<AppNavigationDrawer> createState() => AppNavigationDrawerState();
}

class AppNavigationDrawerState extends State<AppNavigationDrawer> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late bool showNavigationDrawer;

  void openDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  void updateRoute(int selectedIndex) {
    setState(() {
      widget.screenIndex = selectedIndex;
    });
    Navigator.pop(context);
    Navigator.pushNamed(context, destinations[selectedIndex].routeName); 
  }

  Widget buildSideNavigationDrawer(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: updateRoute,
      selectedIndex: widget.screenIndex,
      children: <Widget>[
        Consumer<ShodanAccountService>(
        builder: (context, shodanAccountService, child) {
          String userAccount = "Not connected.";
          String creditsMessage = "";

          if (shodanAccountService.state == ShodanServiceState.authenticated) {
            userAccount = shodanAccountService.shodanAccount!.plan.isNotEmpty ? shodanAccountService.shodanAccount!.plan : "Anonymous";
            creditsMessage = "${shodanAccountService.shodanAccount!.scanCreditsLeft} credit(s) left";
          }

          return UserAccountsDrawerHeader(
            accountName: Text(creditsMessage),
            accountEmail: Text(userAccount),
          );
        }),
        ...destinations.map(
          (DrawerDestination destination) {
            return NavigationDrawerDestination(
              label: Text(destination.label),
              icon: destination.icon,
              selectedIcon: destination.selectedIcon,
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
      ],
      );
  }

  Widget buildStandardDrawerScaffold(BuildContext context) {
    return SafeArea(
        bottom: false,
        top: false,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: NavigationRail(
                  minWidth: 50,
                  labelType: NavigationRailLabelType.all,
                  destinations: destinations.map(
                    (DrawerDestination destination) {
                      return NavigationRailDestination(
                        label: Text(destination.label),
                        icon: destination.icon,
                        selectedIcon: destination.selectedIcon,
                      );
                    },
                  ).toList(),
                selectedIndex: widget.screenIndex,
                useIndicator: true,
                onDestinationSelected: updateRoute,
              )
            ),
            const VerticalDivider(thickness: 1, width: 1)
          ],
        ),
      );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showNavigationDrawer = MediaQuery.of(context).size.width >= Shared.MAX_SCREEN_WIDTH;
  }

  @override
  Widget build(BuildContext context) {
    return showNavigationDrawer
        ? buildStandardDrawerScaffold(context)
        : buildSideNavigationDrawer(context);
  }
}
