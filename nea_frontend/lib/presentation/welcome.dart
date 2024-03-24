import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:parkrun/core/app_export.dart';
import 'package:http/http.dart' as http;
import 'data1.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:typed_data';
import 'dart:async';
import 'dnf.dart';

Future<String?> tagRead() async {
  Completer<String?> completer = Completer<String?>();

  try {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      // Take identifier:
      Uint8List? identifier = tag.data['mifare']['identifier'];
      // Convert format of identifier:
      String? EPC = identifier
          ?.map((i) => i.toRadixString(16).padLeft(2, '0'))
          .join(' ')
          .toUpperCase();

      NfcManager.instance.stopSession();

      print("Tag Read: $EPC");

      completer.complete(EPC);
    });
  } catch (e) {
    completer.complete("Couldn't read Tag");
  }
  return completer.future;
}

class RunnerData {
  // Declare attributes:
  final String EPC;
  final int UserID;
  final int NetTime;
  final int Ranking;
  final String Category;
  final int Weight;
  final int RaceCount;

  // Declare Constructor
  RunnerData(
      {required this.EPC,
      required this.UserID,
      required this.NetTime,
      required this.Ranking,
      required this.Category,
      required this.Weight,
      required this.RaceCount});

  // Factory:
  factory RunnerData.fromJson(
      Map<String, dynamic> Response, String EPC, int UserID) {
    return RunnerData(
        EPC: EPC,
        UserID: UserID,
        NetTime: Response['NetTime'],
        Ranking: Response['Ranking'],
        Category: Response['Category'],
        Weight: Response['Weight'],
        RaceCount: Response['RaceCount']);
  }
}

Future<RunnerData> fetchRunnerData(String EPC, int UserID) async {
  Map<String, dynamic> body = {"EPC_num": EPC, "UserID_num": UserID};
  String jsonBody = json.encode(body);
  try {
    final response = await http.post(
        Uri.parse("http://192.168.1.223:8000/Runners/"),
        headers: {"Content-Type": "application/json"},
        body: jsonBody);

    // Generate an object based off response

    print((jsonDecode(response.body)['data']).toString());
    RunnerData runnerData =
        RunnerData.fromJson(jsonDecode(response.body)['data'], EPC, UserID);

    return runnerData;
  } catch (e) {
    // Create a null runner data object to return:
    RunnerData nullrunnerData = RunnerData(
        EPC: EPC,
        UserID: UserID,
        NetTime: 0,
        Ranking: -1,
        Category: "NA",
        Weight: 0,
        RaceCount: 0);

    return nullrunnerData;
  }
}

/*
NB the format of the tag.data:
{
  ndef: 
    {
      isWritable: true, 
      maxSize: 492, 
      cachedMessage: 
        {
          records: 
            [
              {
                type: [84], 
                typeNameFormat: 1, 
                payload: [2, 101, 110, 65, 32, 105, 115, 32, 109, 101], 
                identifier: []
              }
            ]
        }
      },

  mifare: 
    {
      identifier: [4, 89, 177, 171, 103, 38, 129], 
      historicalBytes: [], 
      mifareFamily: 2
    }
}
*/

class Welcome extends StatelessWidget {
  final int UserID;
  final String FirstName;
  const Welcome({Key? key, required this.UserID, required this.FirstName})
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
                "How was the run, $FirstName?",
                style: theme.textTheme.displaySmall,
              ),
              Spacer(
                flex: 10,
              ),
              Text(
                "Click Below to Connect to your Tag:",
                style: CustomTextStyles.titleLarge22,
              ),
              Spacer(
                flex: 60,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  onPressed: () async {
                    String? EPC = await tagRead();
                    if (EPC != null) {
                      RunnerData runnerData =
                          await fetchRunnerData(EPC, UserID);
                      final int Minutes = (runnerData.NetTime / 60).floor();
                      final int Seconds = (runnerData.NetTime % 60);

                      if (runnerData.Ranking != -1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Data1(
                              minutes: Minutes,
                              seconds: Seconds,
                              ranking: runnerData.Ranking,
                              count: runnerData.RaceCount,
                              weight: runnerData.Weight,
                              category: runnerData.Category,
                              UserID: UserID,
                              FirstName: FirstName,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DNF(
                              UserID: UserID,
                              FirstName: FirstName,
                            ),
                          ),
                        );
                      }
                    } else {}
                  },
                  icon: Image.asset(
                    'assets/images/RFIDsignal_5463.png',
                    height: 100,
                    width: 100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
