import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import '../../main.dart';
import 'course.dart';
import '../After-Login/logout.dart';
import 'courselist.dart';
import '../../constants.dart';
import 'message-read.dart';
import 'acknowledgement.dart';
import 'coursewrapper.dart';

///Returns a List of Courses taken/offered by the user.
Future<List<Course>> getCourse() async {
  String tok = await prefs.getString('token');
  final response = await http.get(
    'https://back-dashboard.herokuapp.com/api/courses/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'JWT ' + tok,
    },
  );
  if (response.statusCode == 200) {
    var V = jsonDecode(response.body) as List;
    List<Course> cs = V.map((course) => Course.fromJson(course)).toList();
    return cs;
  }
}

///Returns a List of messages not read by the user
Future<List<Message>> getUnreadMessage() async {
  String tok = await prefs.getString('token');
  final response = await http.get(
    'https://back-dashboard.herokuapp.com/api/unread/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'JWT ' + tok,
    },
  );
  if (response.statusCode == 200) {
    var V = jsonDecode(response.body) as List;
    List<Message> cs = V.map((message) => Message.fromJson(message)).toList();
    return cs;
  } else
    return null;
}

///Parent Class for HomePage State.
class HomePage extends StatefulWidget {
  bool prof;
  HomePage({this.prof});
  @override
  _HomePageState createState() => _HomePageState();
}

///Class holding the Widget for list of Courses, and unread messages.
class _HomePageState extends State<HomePage> {
  List<Course> courses;
  List<Message> unreadMessages;
  bool done = false;

  void newCourse(String name, String code) {
    this.setState(() {
      addCourse(name, code).then((val) => {addc(courses, val)});
    });
  }

  void addc(List<Course> l, Course c) {
    if (c == null) {
      return;
    }
    if (c.name == '1' && c.code == '1') {
      return;
    } else {
      l.add(c);
    }
  }

  Future<Course> addCourse(String name, String code) async {
    String tok = await prefs.getString('token');
    final response = await http.post(
      'https://back-dashboard.herokuapp.com/api/courses/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ' + tok,
      },
      body: jsonEncode(<String, String>{"name": name, "code": code}),
    );
    print(name);
    print(code);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201) {
      var V = jsonDecode(response.body);
      Course j = Course.fromJson(V);
      return j;
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getCourse().then((val) {
      setState(() {
        this.courses = val;
        se(val);
      });
    });
    getUnreadMessage().then((val) {
      if (val.length != 0) {
        print("in");
        Navigator.push(
          Application.navKey.currentContext,
          MaterialPageRoute(
            builder: (context) {
              return AcknowledgementPage(messages: val);
            },
          ),
        );
      }
    });
  }

  void se(List<Course> l) {
    setState(() {
      this.courses = l;
      done = true;
    });
  }

  void t() async {
    bool ch = await prefs.getBool('change');
    if (ch) {
      getCourse().then((val) {
        setState(() {
          this.courses = val;
          se(val);
        });
      });
      ch = false;
    }
    prefs.addBool('change', ch);
  }

  @override
  Widget build(BuildContext context) {
    //getCourse().then((value) => {se(value)});
    print("1");
    print(this.courses);
    if (courses == null) {
      return Container();
    } else {
      print('2');
      if (!this.done) print('3');
      print(this.done);

      return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
            appBar: bar(),
            body: Column(children: <Widget>[
              Expanded(
                  child: CourseList(
                courses: this.courses,
                done: this.done,
                prof: this.widget.prof,
              )),
              widget.prof
                  ? CourseWrapper(
                      callback: newCourse,
                    )
                  : Container(height: 0),
            ])),
      );
    }
  }

  Widget bar() {
    return AppBar(
      title: Text("Courses"),
      actions: [
        LogoutButton(),
      ],
      leading: new IconButton(
        icon: new Icon(Icons.ac_unit),
        onPressed: null,
      ),
    );
  }
}
