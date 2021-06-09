import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import '../../main.dart';

class StudentAdd extends StatefulWidget {
  final String stat;
  final int id;
  StudentAdd({this.id, this.stat});
  @override
  StudentAddState createState() => StudentAddState();
}

///This class hosts the UI and functions to add a student/TA to a course.
class StudentAddState extends State<StudentAdd> {
  final _formKey = GlobalKey<FormState>();
  final controller = new TextEditingController();

  ///This Function allows adding of a Student to the course.
  ///Its takes the student name from the input field (TextEditingController)
  ///from the class and hence no parameter is required.
  void addStud() async {
    print('h');
    FocusScope.of(context).unfocus();
    String tok = await prefs.getString('token');
    print('https://back-dashboard.herokuapp.com/api/user/' +
        this.widget.id.toString() +
        '/' +
        controller.text +
        '/');
    final response = await http.post(
      'https://back-dashboard.herokuapp.com/api/user/' +
          this.widget.id.toString() +
          '/' +
          controller.text +
          '/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ' + tok,
      },
      body: jsonEncode(<String, String>{"status": 'student'}),
    );
    print(response.body);
    if (response.statusCode == 201) {
      controller.clear();
    }
  }

  ///This Function allows adding of a TA to the course.
  ///Its takes the name from the input field (TextEditingController) common to the class
  ///and hence no parameter.
  void addTA() async {
    print('h');
    FocusScope.of(context).unfocus();
    String tok = await prefs.getString('token');
    print('https://back-dashboard.herokuapp.com/api/user/' +
        this.widget.id.toString() +
        '/' +
        controller.text +
        '/');
    final response = await http.post(
      'https://back-dashboard.herokuapp.com/api/user/' +
          this.widget.id.toString() +
          '/' +
          controller.text +
          '/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ' + tok,
      },
      body: jsonEncode(<String, String>{"status": 'TA'}),
    );
    print(response.body);
    if (response.statusCode == 201) {
      controller.clear();
    }
  }

  ///This Widget provides a form with an input field, where name should be written.
  ///If the user is a professor, he can add the user with that name as a TA or as a student.
  ///If the user is a TA, he can add the user with that name as a student for the course.
  @override
  Widget build(BuildContext context) {
    return new Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: '  type username',
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    this.widget.stat == 'professor'
                        ? ElevatedButton(
                            child: Text('TA'),
                            onPressed: addTA,
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                    ElevatedButton(
                      onPressed: addStud,
                      child: Text('Student'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
