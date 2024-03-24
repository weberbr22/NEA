import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'core/app_export.dart';
import 'package:nfc_manager/nfc_manager.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
late NfcManager _nfcManager;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //await NfcManager.instance.startSession();

  _nfcManager = NfcManager.instance;

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  ///Please update theme as per your need if required.
  ThemeHelper().changeTheme('primary');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          theme: theme,
          title: 'parkrun',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.loginScreen,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
