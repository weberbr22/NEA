import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:parkrun/core/app_export.dart';
import 'package:http/http.dart' as http;
import 'data1.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:typed_data';
import 'dart:async';
import 'welcome.dart';
import 'package:parkrun/widgets/custom_elevated_button.dart';

class DNF extends StatelessWidget {
  final int UserID;
  final String FirstName;
  const DNF({Key? key, required this.UserID, required this.FirstName})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: SizeUtils.width,
        height: SizeUtils.height,
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimaryContainer,
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
            horizontal: 30.h,
            vertical: 34.v,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Spacer(
                flex: 15,
              ),
              CustomImageView(
                imagePath: ImageConstant.imgImage2,
                height: 122.v,
                width: 261.h,
              ),
              Spacer(
                flex: 30,
              ),
              Text(
                "DNF",
                style: theme.textTheme.displaySmall,
              ),
              Spacer(
                flex: 10,
              ),
              Text(
                "You didn't finish the race.",
                style: CustomTextStyles.titleLarge22,
              ),
              Spacer(
                flex: 60,
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
