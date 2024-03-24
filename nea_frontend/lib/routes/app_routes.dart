import 'package:flutter/material.dart';
import 'package:parkrun/presentation/welcome.dart';
import 'package:parkrun/presentation/login.dart';
import 'package:parkrun/presentation/data1.dart';
import 'package:parkrun/presentation/data2.dart';
import 'package:parkrun/presentation/app_navigation_screen.dart';

class AppRoutes {
  static const String dataLoadingScreen = '/data_loading_screen';

  static const String loginScreen = '/login_screen';

  static const String data1Screen = '/data1_screen';

  static const String data2Screen = '/data2_screen';

  static const String welcomeScreen = '/welcome_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static Map<String, WidgetBuilder> routes = {
    loginScreen: (context) => Login(),
    data1Screen: (context) => Data1(
          minutes: 3,
          seconds: 3,
          ranking: 3,
          count: 3,
          weight: 3,
          category: 'P',
          UserID: 3,
          FirstName: 'P',
        ),
    data2Screen: (context) => Data2(
          milepaceminutes: 3,
          milepaceseconds: 3,
          kmpaceminutes: 3,
          kmpaceseconds: 3,
          weight: 3,
          category: 'P',
          vo2max: 3,
          calories: 3,
          minutes: 3,
          seconds: 3,
        ),
    welcomeScreen: (context) => Welcome(
          UserID: 3,
          FirstName: 'P',
        ),
    appNavigationScreen: (context) => AppNavigationScreen()
  };
}
