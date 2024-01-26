import 'package:flutter/material.dart';
import 'package:netsherlock/pages/account_page.dart';
import 'package:netsherlock/services/shodan_account_service.dart';
import 'package:provider/provider.dart';
import 'package:netsherlock/consts.dart';

class DrawerDestination {
  const DrawerDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<DrawerDestination> destinations = <DrawerDestination>[
  DrawerDestination('Profile', Icon(Icons.account_circle_outlined),
      Icon(Icons.account_circle)),
  DrawerDestination('Alerts', Icon(Icons.warning_amber_outlined),
      Icon(Icons.warning_amber)),
  DrawerDestination('Scans', Icon(Icons.domain_verification_outlined),
      Icon(Icons.domain_verification)),
  DrawerDestination(
      'DNS', Icon(Icons.dns_outlined), Icon(Icons.dns)),
];

class AppNavigationDrawer extends StatefulWidget {
  const AppNavigationDrawer({super.key});

  @override
  State<AppNavigationDrawer> createState() => AppNavigationDrawerState();
}

class AppNavigationDrawerState extends State<AppNavigationDrawer> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int screenIndex = 0;
  late bool showNavigationDrawer;

  void updateScreenIndex(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
  }

  Widget displayProperScreen() {
    switch (screenIndex) {
      case 0:
        return const AccountPage();
      default:
        return const AccountPage();
    }
  }

  void openDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  Widget buildSideNavigationDrawer(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: const Text("NetSherlock")),
      drawer: NavigationDrawer(
        onDestinationSelected: updateScreenIndex,
        selectedIndex: screenIndex,
        children: <Widget>[
          Consumer<ShodanAccountService>(
          builder: (context, shodanAccountService, child) {
            String userAccount = "Not connected.";
            String creditsMessage = "";

            if (shodanAccountService.state == ShodanAccountState.authenticated) {
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
      ),
      body: Column(
        children: [
          Expanded(
            child: displayProperScreen(),
          ),
        ],
      ),
    );
  }

  Widget buildStandardDrawerScaffold(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
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
                  selectedIndex: screenIndex,
                  useIndicator: true,
                  onDestinationSelected: updateScreenIndex),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: displayProperScreen(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showNavigationDrawer = MediaQuery.of(context).size.width >= Consts.MAX_SCREEN_WIDTH;
  }

  @override
  Widget build(BuildContext context) {
    return showNavigationDrawer
        ? buildStandardDrawerScaffold(context)
        : buildSideNavigationDrawer(context);
  }
}
