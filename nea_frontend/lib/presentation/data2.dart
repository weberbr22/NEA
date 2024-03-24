import 'package:flutter/material.dart';
import 'package:parkrun/core/app_export.dart';
import 'package:parkrun/widgets/custom_elevated_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> postActivity(int minutes, int seconds) async {
  DateTime myDateTime = DateTime.now();
  // Convert DateTime to iso8601
  String iso8601String = myDateTime.toIso8601String();
  String dayMonth = '${myDateTime.day}/${myDateTime.month}';

  final int netTime = 60 * minutes + seconds;
  final url = Uri.parse('https://www.strava.com/api/v3/activities?');
  Map<String, dynamic> parameters = {
    'name': 'Fulham Palace Parkrun $dayMonth',
    'type': 'Run',
    'sport_type': 'Run',
    'start_date_local': iso8601String,
    'elapsed_time': netTime.toString(),
    'access_token': '9b9aca2720c508c75a6277e1e0e02907dac687f2',
    'distance': '5010',
    'description': '🌳🏃🌳 - thank you to the volunteers'
  };

  try {
    final response = await http.post(url, body: parameters);
  } catch (e) {
    print(e);
  }
}

class Data2 extends StatelessWidget {
  final int milepaceminutes;
  final int milepaceseconds;
  final int kmpaceminutes;
  final int kmpaceseconds;
  final int weight;
  final String category;
  final double vo2max;
  final int calories;
  final int minutes;
  final int seconds;

  const Data2(
      {Key? key,
      required this.milepaceminutes,
      required this.milepaceseconds,
      required this.kmpaceminutes,
      required this.kmpaceseconds,
      required this.weight,
      required this.category,
      required this.vo2max,
      required this.calories,
      required this.minutes,
      required this.seconds})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: theme.colorScheme.onPrimary,
      body: Container(
        width: SizeUtils.width,
        height: SizeUtils.height,
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary,
          image: DecorationImage(
            image: AssetImage(
              ImageConstant.imgIphone1415Pro,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 57.h,
            vertical: 34.v,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Spacer(flex: 5),
              CustomImageView(
                imagePath: ImageConstant.imgImage2,
                height: 122.v,
                width: 261.h,
              ),
              Spacer(flex: 5),
              SizedBox(
                height: 66.v,
                width: 315.h,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 156.h),
                        decoration: AppDecoration.fillTealA,
                        child: VerticalDivider(
                          width: 1.h,
                          thickness: 1.v,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "min/km:",
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 46.h,
                          bottom: 8.v,
                        ),
                        child: Text(
                          "$kmpaceminutes:$kmpaceseconds",
                          style: theme.textTheme.headlineLarge,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 57.v,
                        width: 109.h,
                        margin: EdgeInsets.only(right: 47.h),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "min/mile:",
                                style: theme.textTheme.titleSmall,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "$milepaceminutes:$milepaceseconds",
                                style: theme.textTheme.headlineLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(flex: 2),
              SizedBox(
                height: 70.v,
                width: 315.h,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 66.v,
                        width: 315.h,
                        decoration: BoxDecoration(
                          color: appTheme.tealA400,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "VO2 Max:",
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        vo2max.toStringAsFixed(2),
                        style: theme.textTheme.displayMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(flex: 2),

              SizedBox(
                height: 70.v,
                width: 315.h,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 66.v,
                        width: 315.h,
                        decoration: BoxDecoration(
                          color: appTheme.tealA400,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Calories:",
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "$calories",
                        style: theme.textTheme.displayMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(flex: 5),

              //_buildUserProfile(context),
              //SizedBox(height: 25.v),
              Text(
                "VO2 Max and Calories are estimates. Adults need around 2000 kcal a day.",
                style: theme.textTheme.titleLarge,
              ),
              Spacer(flex: 3),
              CustomElevatedButton(
                onPressed: () {
                  try {
                    postActivity(minutes, seconds);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Activity uploaded successfully'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error uploading activity'),
                      ),
                    );
                  }
                },
                text: "Upload to Strava",
              ),
              SizedBox(height: 25.v),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: "Go back",
              ),
              SizedBox(height: 38.v),
            ],
          ),
        ),
      ),
    );
  }
}
