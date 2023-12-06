import 'package:flutter/material.dart';

class DrawerDestination {
  const DrawerDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<DrawerDestination> destinations = <DrawerDestination>[
  DrawerDestination('Profile', Icon(Icons.account_circle_outlined),
      Icon(Icons.account_circle)),
  DrawerDestination(
      'Alerts', Icon(Icons.warning_amber_outlined), Icon(Icons.warning_amber)),
  DrawerDestination('Scans', Icon(Icons.domain_verification_outlined),
      Icon(Icons.domain_verification)),
  DrawerDestination('DNS', Icon(Icons.dns_outlined), Icon(Icons.dns)),
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

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
  }

  void openDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

 Widget buildModalDrawerScaffold(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: const Text("NetSherlock")),
      /*body: Center(
        child: _widgetOptions[_selectedIndex],
      ),*/
      drawer: NavigationDrawer(
        onDestinationSelected: handleScreenChanged,
        selectedIndex: screenIndex,
        children: <Widget>[
          /*Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'NetSherlock',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),*/
          const UserAccountsDrawerHeader(
            accountName: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Test'),
                Text('450 credits left'),
              ],
            ),
            accountEmail: Text('test@.com'),
            
          ),
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
                onDestinationSelected: (int index) {
                  setState(() {
                    screenIndex = index;
                  });
                },
              ),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Page Index = $screenIndex'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showNavigationDrawer = MediaQuery.of(context).size.width >= 450;
  }

  @override
  Widget build(BuildContext context) {
    return showNavigationDrawer
        ? buildStandardDrawerScaffold(context)
        : buildModalDrawerScaffold(context);
  }
}
