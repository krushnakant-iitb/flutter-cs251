import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Home/home.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../main.dart';

///Variable to keep track of if the user is a professor or a student.
bool prof = false;

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  ///A function that logs in user with [username] and [password]
  Future<bool> login(String username, String password) async {
    ///Await ServerResponse on login attempt
    final response = await http.post(
      'https://back-dashboard.herokuapp.com/api/auth/get-token/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{"username": username, "password": password}),
    );
    if (response.statusCode == 200) {
      /// If the server did return a 200 CREATED response, then parse the JSON.
      var V = jsonDecode(response.body);
      String tok = V['token'];
      token = tok;
      prefs.addString('token', tok);
      print(tok);
      prefs.addString('username', username);
      print("addString: ");
      print(username + '1');
      print("addString----------");

      ///Determine if token is expired or not
      DateTime expirationDate = JwtDecoder.getExpirationDate(tok);
      print(expirationDate);
      prefs.addString('expiry', expirationDate.toIso8601String());
      final resp = await http.get(
        'https://back-dashboard.herokuapp.com/api/usermy/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT ' + tok,
        },
      );

      ///Getting token from FirebaseMessaging
      String z = await fbm.getToken();
      print('tok');
      print(z);
      final rs = await http.post(
        'https://back-dashboard.herokuapp.com/api/regadd/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT ' + tok,
        },
        body: jsonEncode(<String, String>{"reg_id": z}),
      );
      print(rs.body);
      var U = jsonDecode(resp.body);

      ///Differentiate between users if Professor or Not
      if (U['is_professor']) {
        print("Professor Here\n");
        prof = true;
        prefs.addBool('professor', true);
      } else {
        print("No professor Here\n");
        prof = false;
        prefs.addBool('professor', false);
      }

      ///Set LoggedIn to true
      prefs.addBool('loggedIn', true);
      loggedIn = true;
      return Future.value(true);
    }

    ///If Login is not successful, indicate that
    else {
      prefs.addBool('loggedIn', false);
      loggedIn = false;
      return Future.value(false);
    }
  }

  ///Widget containing the UI
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String username = "";
    String password = "";
    return Background(
      child: SingleChildScrollView(
        child: Column(
          ///Ensure Proper Alignment
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              ///Heading of the Page
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              ///A Nice Picture for enhanced UX
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),

            ///Input Field for Username
            RoundedInputField(
              hintText: "Your Username",
              onChanged: (String value) {
                username = value;
              },
            ),

            ///Input Field for Password
            RoundedPasswordField(
              onChanged: (String value) {
                password = value;
              },
            ),

            ///Button for Action of Login. Invokes login function and redirects to Courses-Homepage.
            RoundedButton(
              text: "LOGIN ",
              press: () {
                var beta = login(username, password);
                String eta = 'eta';
                print("\n\n");
                print(eta);
                beta.then((val) {
                  if (val) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => loggedIn
                                ? HomePage(
                                    prof: prof,
                                  )
                                : LoginScreen(),
                            settings: RouteSettings(
                              arguments: val,
                            )));
                  } else {}
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
