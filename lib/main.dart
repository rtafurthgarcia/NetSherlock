import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:netsherlock/color_schemes.g.dart';
import 'package:netsherlock/helpers.dart';
import 'package:netsherlock/pages/account_page.dart';
import 'package:netsherlock/pages/asset_creation_page.dart';
import 'package:netsherlock/pages/assets_page.dart';
import 'package:netsherlock/pages/bug_report_page.dart';
import 'package:netsherlock/pages/dns_page.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Must add this line.
  if (Helpers.isDesktop()) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(400, 320),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      windowButtonVisibility: true
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

   await SentryFlutter.init(
    (options) {
      options.dsn = 'https://d622f7a687d0b8bb0555204c9dc158b8@o4506809592512512.ingest.sentry.io/4506809593757696';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('de');

     return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      initialRoute: "/account",
      routes: {
        "/account": (context) => const AccountPage(),
        "/assets": (context) => const AssetsPage(),
        "/assets/new": (context) => const AssetCreationPage(),
        "/lookup": (context) => const DNSPage(),
        "/bugreport": (context) => const BugReportPage()
      },
    );
  }
}
