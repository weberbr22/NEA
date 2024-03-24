import 'package:flutter/material.dart';
import 'package:parkrun/core/app_export.dart';
import '../presentation/welcome.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';

Future<List<Map<String, dynamic>>> fetchUsers() async {
  // The function returns a list of mappings of strings to any data type

  try {
    final response = await http
        .get(Uri.parse('http://192.168.1.223:8000/Users/?format=json'));

    // Parse the raw JSON into said mapping

    final parsed = (jsonDecode(response.body)['results'] as List)
        .cast<Map<String, dynamic>>();
    return parsed;
  } catch (e) {
    Future<List<Map<String, dynamic>>> output = Future.value([]);
    return output;
  }
}

Future<List<dynamic>> Authenticate(String email, String password) async {
  // Get the User List
  List<Map<String, dynamic>> userList = await fetchUsers();

  List<dynamic> output = [];

  for (var x in userList) {
    if (email == x['Email'] && password == x['Password']) {
      output.add(x['FirstName']);
      output.add(x['LastName']);
      output.add(x['UserID']);
    }
  }

  return output;
}

class Login extends StatefulWidget {
  const Login({Key? key})
      : super(
          key: key,
        );

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
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
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30.h,
              vertical: 34.v,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Spacer(
                  flex: 12,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgImage2,
                  height: 122.v,
                  width: 261.h,
                ),
                Spacer(
                  flex: 30,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String email = emailController.text;
                          String password = passwordController.text;
                          List<dynamic> authenticate =
                              await Authenticate(email, password);

                          if (authenticate.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Username or Password incorrect'),
                              ),
                            );
                          } else {
                            final String FirstName = authenticate[0];
                            final String LastName = authenticate[1];
                            final int UserID = authenticate[2];

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Welcome(
                                    UserID: UserID, FirstName: FirstName),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill input')),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ),
                Spacer(
                  flex: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
