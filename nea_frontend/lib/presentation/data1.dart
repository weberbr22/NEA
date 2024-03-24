import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:parkrun/core/app_export.dart';
import 'package:parkrun/presentation/welcome.dart';
import 'package:parkrun/widgets/custom_elevated_button.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'data2.dart';

import 'package:url_launcher/url_launcher.dart';

final Uri _url =
    Uri.parse('https://volunteer.parkrun.com/how-to-volunteer-at-parkrun');

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

List<int> CalculatePace(int minutes, int seconds) {
  // Create decvalue, a decimal value for minutes
  final double decvalue = minutes + seconds / 60;

  // 5K = 3.107 Miles
  // These two paces are in the same format as decvalue
  final double milepace = decvalue / 3.107;
  final double kmpace = decvalue / 5;

  // Now split the decvalues into minutes and seconds

  final int milepaceminutes = milepace.floor();
  final int milepaceseconds = ((milepace - milepaceminutes) * 60).floor().abs();

  final int kmpaceminutes = kmpace.floor();
  final int kmpaceseconds = ((kmpace - kmpaceminutes) * 60).floor().abs();

  return [milepaceminutes, milepaceseconds, kmpaceminutes, kmpaceseconds];
}

double CalculateVO2max(int minutes) {
  // Find velocity in metres / minute
  final double v = 5000 / minutes;
  // Apply JD formula
  final double VO2max = (-4.6 + 0.182258 * v + 0.000104 * v * v) /
      (0.8 +
          0.1894393 * exp(-0.012778 * minutes) +
          0.2989558 * exp(-0.1932605 * minutes));

  return VO2max;
}

int CalculateCalories(int minutes, int seconds, int weight) {
  final double decvalue = minutes + seconds / 60;

  final double v = 5000 / minutes;

  final double mets;

  // Determine met level off velocity:

  if (1 / v > 10) {
    mets = 8;
  } else if (1 / v > 7.5 && 1 / v < 10) {
    mets = 10;
  } else if (1 / v > 6 && 1 / v < 7.5) {
    mets = 13.5;
  } else if (1 / v < 6) {
    mets = 16;
  } else {
    mets = 100;
  }

  // Apply formula:

  final int calories = (mets * weight * (decvalue / 60)).floor();

  return calories;
}

class Data1 extends StatelessWidget {
  final int minutes;
  final int seconds;
  final int ranking;
  final int count;
  final int weight;
  final String category;
  final int UserID;
  final String FirstName;

  Data1(
      {Key? key,
      required this.minutes,
      required this.seconds,
      required this.ranking,
      required this.count,
      required this.weight,
      required this.category,
      required this.UserID,
      required this.FirstName})
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
              Spacer(),
              CustomImageView(
                imagePath: ImageConstant.imgImage2,
                height: 122.v,
                width: 261.h,
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
                        "Time:",
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "$minutes:$seconds",
                        style: theme.textTheme.displayMedium,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.v),
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
                        "Ranking:",
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "$ranking/$count",
                        style: theme.textTheme.displayMedium,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.v),
              CustomElevatedButton(
                onPressed: () {
                  List<int> PaceList = CalculatePace(minutes, seconds);
                  int milepaceminutes = PaceList[0];
                  int milepaceseconds = PaceList[1];
                  int kmpaceminutes = PaceList[2];
                  int kmpaceseconds = PaceList[3];

                  double VO2max = CalculateVO2max(minutes);

                  int calories = CalculateCalories(minutes, seconds, weight);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Data2(
                              milepaceminutes: milepaceminutes,
                              milepaceseconds: milepaceseconds,
                              kmpaceminutes: kmpaceminutes,
                              kmpaceseconds: kmpaceseconds,
                              weight: weight,
                              category: category,
                              vo2max: VO2max,
                              calories: calories,
                              minutes: minutes,
                              seconds: seconds)));
                },
                text: "See more data",
              ),
              SizedBox(height: 30.v),
              CustomElevatedButton(
                onPressed: () {
                  _launchUrl();
                },
                text: "Join our volunteers",
              ),
              SizedBox(height: 46.v),
              Text(
                "Congratulations!",
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 38.v),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Welcome(UserID: UserID, FirstName: FirstName)));
                },
                text: "Log another run",
              ),
              SizedBox(height: 49.v),
            ],
          ),
        ),
      ),
    );
  }
}
