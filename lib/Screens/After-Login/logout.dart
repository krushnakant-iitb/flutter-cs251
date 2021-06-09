import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

///This Function Logs the user out, redirects backend to remove the token,
///and directs user to LoginScreen.
void logout(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String tok = await prefs.getString('token');
  String reg = await fbm.getToken();
  print(reg);
  print(tok);
  final response = await http.post(
    'https://back-dashboard.herokuapp.com/api/regremove/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'JWT ' + tok,
    },
    body: jsonEncode(<String, String>{"reg_id": reg}),
  );
  print(response.body);
  prefs.clear();
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => LoginScreen(),
    ),
    (e) => false,
  );
}

///The StatefulWidget for LogoutButton
class LogoutButton extends StatefulWidget {
  @override
  _LogoutButtonState createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  ///Widget for Logout Button, uses RaisedButton and invokes logout Function.
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => {showAlertDialog(context)},
      child: Text('Logout'),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("No"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Yes"),
    onPressed: () {
      logout(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Confirmation"),
    content: Text("Do you really want to Logout?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
