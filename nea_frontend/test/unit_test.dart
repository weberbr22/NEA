import 'dart:convert';

import 'package:parkrun/presentation/login.dart';
import 'package:parkrun/presentation/welcome.dart';
import 'package:parkrun/presentation/data1.dart';
import 'package:parkrun/presentation/data2.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:parkrun/presentation/welcome.dart';

void main() async {
  test('Test Login', () async {
    List<dynamic> sampleUsers = [
      {
        "UserID": 12345,
        "Category": "M18",
        "Email": "ff@ff.com",
        "Weight": 65,
        "FirstName": "Rex",
        "LastName": "Weber-Brown",
        "Password": "password"
      }
    ];

    List<dynamic> output = await Authenticate(
        "johndoe@gmail.com", "incorrectpassword"); // sampleusers

    expect(output.isEmpty, true);
  });

  test('Test Factory', () {
    String response = jsonEncode({
      "data": {
        "Ranking": 1,
        "NetTime": 1200,
        "Category": "W23",
        "Weight": 100,
        "RaceCount": 1
      }
    }); // Sample JSON response from Django

    RunnerData Instance = RunnerData.fromJson(jsonDecode(response)['data'],
        "ABCDE", 12345); // Generate an object from the JSON and parameters

    expect(Instance.Ranking, 1);
    expect(Instance.NetTime, 1200);
    expect(Instance.Category, "W23");
    expect(Instance.Weight, 100);
    expect(Instance.RaceCount, 1);
    expect(Instance.EPC, "ABCDE");
    expect(Instance.UserID, 12345);
  });

  test('Data Points functions', () {
    // Pace:

    List<int> PaceList = CalculatePace(20, 0); // Time of 20 minutes

    int milepaceminutes = PaceList[0];
    int milepaceseconds = PaceList[1];
    int kmpaceminutes = PaceList[2];
    int kmpaceseconds = PaceList[3];

    // VO2max:

    double VO2max = CalculateVO2max(20);

    // Calories:

    int calories = CalculateCalories(20, 0, 65);

    expect(milepaceminutes, 6); // Pace of 6:26 min / mile
    expect(milepaceseconds, 26);
    expect(kmpaceminutes, 4); // Pace of 4:00 min / mile
    expect(kmpaceseconds, 0);

    expect(VO2max.toStringAsFixed(2), "49.81"); // Truncate VO2max to 2dp

    expect(calories, 346);
  });

  test('GET Request', () async {
    http.Response response = await http
        .get(Uri.parse('http://172.28.137.209:8000/Users/?format=json'));

    final Map<String, dynamic> responseBody =
        json.decode(response.body); // Parse but leave in original form

    final sample = {
      "count": 1,
      "next": null,
      "previous": null,
      "results": [
        {
          "UserID": 12345,
          "Category": "M18",
          "Email": "ff@ff.com",
          "Weight": 65,
          "FirstName": "Rex",
          "LastName": "Weber-Brown",
          "Password": "password"
        }
      ]
    };

    expect(responseBody, sample);
  });

  test('POST Request', () async {
    final requestData = {"UserID_num": 12345, "EPC_num": "ABCDE"};

    final sample = {
      "data": {
        "Ranking": 1,
        "NetTime": 1200,
        "Category": "M18",
        "Weight": 65,
        "RaceCount": 1
      }
    };

    Map<String, String> headers = {"Content-Type": "application/json"};

    final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/Runners/'),
        body: jsonEncode(requestData),
        headers: headers);

    final Map<String, dynamic> responseBody = json.decode(response.body);

    expect(responseBody, sample);
  });

  test('Parse GET Request', () async {
    List<dynamic> userList = await fetchUsers();

    List<dynamic> sampleUsers = [
      {
        "UserID": 12345,
        "Category": "M18",
        "Email": "ff@ff.com",
        "Weight": 65,
        "FirstName": "Rex",
        "LastName": "Weber-Brown",
        "Password": "password"
      }
    ]; // What I expect to be the parsed output

    expect(userList, sampleUsers);
  });
}
