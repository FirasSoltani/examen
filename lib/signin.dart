import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String username;
  String password;
  GlobalKey<FormState> _keyForm = new GlobalKey<FormState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  getStatus(status, user) async {
    SharedPreferences prefs = await _prefs;
    dynamic userData = jsonDecode(user);
    print(userData);
    if (status != 500) {
      prefs.setString("userId", userData["_id"]);
      prefs.setString("username", userData["username"]);
      prefs.setString("email", userData["email"]);
      prefs.setString("avatar", userData["avatar"]);
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    } else
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Failed"),
            content: Text("Wrong username or password please try again."),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.pop(context), child: Text("OK"))
            ],
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignIn"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
              key: _keyForm,
              child: Column(
                children: [
                  SizedBox(),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Username"),
                    validator: (String value) {
                      if (value.isEmpty)
                        return "Username must not be empty";
                      else
                        return null;
                    },
                    onSaved: (String value) {
                      username = value;
                    },
                  ),
                  SizedBox(),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Password"),
                    validator: (String value) {
                      if (value.isEmpty)
                        return "Password must not be empty";
                      else
                        return null;
                    },
                    onSaved: (String value) {
                      password = value;
                    },
                  ),
                  SizedBox(),
                  Column(
                    children: [
                      MaterialButton(
                          onPressed: () {
                            if (!_keyForm.currentState.validate()) return;
                            _keyForm.currentState.save();

                            Map<String, String> headers = {
                              "Content-Type": "application/json; charset=UTF-8"
                            };

                            Map user = {
                              "username": username,
                              "password": password,
                            };
                            http
                                .post("http://localhost:9090/user/signin",
                                    headers: headers, body: jsonEncode(user))
                                .then((value) =>
                                    getStatus(value.statusCode, value.body));
                          },
                          child: Text("Signin")),
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }
}
