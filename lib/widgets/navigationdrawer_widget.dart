import 'package:flutter/material.dart';
import 'package:netsherlock/services/shodan_account_service.dart';
import 'package:provider/provider.dart';
import 'package:netsherlock/shared.dart';

class DrawerDestination {
  DrawerDestination({required this.label, required this.icon, required this.selectedIcon, required this.routeName, this.isHidden = false});

  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final String routeName;
  bool isHidden;
}

List<DrawerDestination> destinations = <DrawerDestination>[
  /*DrawerDestination(label: 'Account', icon: const Icon(Icons.account_circle_outlined), selectedIcon: const Icon(Icons.account_circle), routeName: "/account", isHidden: true),*/
  DrawerDestination(label: 'Assets', icon: const Icon(Icons.api_outlined), selectedIcon: const Icon(Icons.api), routeName: "/assets"),
  DrawerDestination(label: 'Scans', icon: const Icon(Icons.domain_verification_outlined), selectedIcon: const Icon(Icons.domain_verification), routeName: "/scans"),
  DrawerDestination(label: 'DNS', icon: const Icon(Icons.dns_outlined), selectedIcon: const Icon(Icons.dns), routeName: "/lookup"),
  DrawerDestination(label: 'Bug report', icon: const Icon(Icons.bug_report_outlined), selectedIcon: const Icon(Icons.bug_report), routeName: "/bugreport", isHidden: true),
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

          if (shodanAccountService.state == ShodanState.authenticated) {
            userAccount = shodanAccountService.shodanAccount!.plan.isNotEmpty ? shodanAccountService.shodanAccount!.plan : "Anonymous";
            creditsMessage = "${shodanAccountService.shodanAccount!.scanCreditsLeft} credit(s) left";
          }

          return UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
            ),
            accountName: Text(creditsMessage),
            accountEmail: Text(userAccount),
            onDetailsPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/account'); 
            },
            currentAccountPicture: 
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.background,
                child:Icon(
                  Icons.account_circle,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 48,
                ),
              ),
          );
        }),
        ...destinations.where((destination) => !destination.isHidden).map(
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
        const NavigationDrawerDestination(
          label: Text("Report a bug"),
          icon: Icon(Icons.bug_report_outlined),
          selectedIcon: Icon(Icons.bug_report),
        )
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
    widget.screenIndex = destinations.indexWhere((element) => element.routeName == ModalRoute.of(context)?.settings.name);

    return showNavigationDrawer
        ? buildStandardDrawerScaffold(context)
        : buildSideNavigationDrawer(context);
  }
}
