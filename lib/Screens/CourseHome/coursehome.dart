import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import '../../main.dart';
import 'message.dart';
import 'messagelist.dart';
import 'addStud.dart';

import 'messagewrapper.dart';
import '../After-Login/logout.dart';

///This Function requests from the backend and returns
///the list of messages corresponding to the course with
///course_id [id]. It is called whenever
///[CourseHomePageState] is created.
Future<List<Message>> getMessage(int id) async {
  String tok = await prefs.getString('token');
  final response = await http.get(
    'https://back-dashboard.herokuapp.com/api/messages/' + id.toString() + '/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'JWT ' + tok,
    },
  );
  if (response.statusCode == 200) {
    var V = jsonDecode(response.body) as List;
    List<Message> cs = V.map((course) => Message.fromJson(course)).toList();
    print(cs);
    return cs;
  }
}

///Parent Class for the CoursehomePageState
class CourseHomePage extends StatefulWidget {
  String stat;
  final int id;
  CourseHomePage({this.stat, this.id});
  @override
  CourseHomePageState createState() => CourseHomePageState();
}

///This class hosts the UI and functions related to a course home page.
class CourseHomePageState extends State<CourseHomePage> {
  ///The List of all Messages of the Course.
  List<Message> messages;
  bool done = true;

  ///This function calls the method [addMessage] with same parameters,
  ///and the [message] is added to messagelist using the function [addm]
  void newCourse(String message, String to, bool z) {
    print('h');
    this.setState(() {
      addMessage(message, to, z).then((val) => {
            setState(() {
              print(val.from_username);
              addm(val, messages);
            })
          });
    });
  }

  ///This function sends the message with text [message] to the backend
  ///for it to be sent to desired users and returns a [Message] object.
  ///The parameter [to] indicates if the message is for TAs or students, while
  ///the boolean parameter [z] indicates the priority of the message.
  Future<Message> addMessage(String message, String to, bool z) async {
    String t;
    if (z) {
      t = "true";
    } else {
      t = "false";
    }
    String tok = await prefs.getString('token');
    final response = await http.post(
      'https://back-dashboard.herokuapp.com/api/messages/' +
          this.widget.id.toString() +
          '/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ' + tok,
      },
      body: jsonEncode(
          <String, String>{"to": to, "message": message, "prior": t}),
    );
    if (response.statusCode == 200) {
      var V = jsonDecode(response.body);
      Message j = Message.fromJson(V);
      String s = await prefs.getString('username');
      j.from_username = s;
      print(s);
      print(j.from_username);
      print(V);
      return j;
    } else {
      return null;
    }
  }

  ///This function adds the message [m], unless [m] is null, to the list of messages [msg].
  void addm(Message m, List<Message> msg) {
    if (m == null)
      return;
    else {
      msg.insert(0, m);
    }
  }

  ///Initialises the State of CourseHomePage with the messages of the course.
  @override
  void initState() {
    super.initState();
    getMessage(this.widget.id).then((val) => {
          setState(() {
            this.messages = val;
          })
        });
  }

  void t() async {
    print('in');
    bool ch = await prefs.getBool('change');
    print(ch);
    if (ch) {
      print('hi');
      getMessage(this.widget.id).then((val) => {
            setState(() {
              this.messages = val;
            })
          });
      ch = false;
    }
    prefs.addBool('change', false);
    ch = await prefs.getBool('change');
    print(ch);
  }

  ///The Widget holds the UI of the CourseHomePage.
  ///
  ///If there are no messages it returns a null container.
  ///Else, if the user is
  @override
  Widget build(BuildContext context) {
    print('2');
    print(this.done);
    print(this.messages);
    if (messages == null) {
      return Container();
    }
    return new Scaffold(
        appBar: bar(),
        body: Column(
          children: <Widget>[
            this.widget.stat != 'student'
                ? StudentAdd(
                    stat: this.widget.stat,
                    id: this.widget.id,
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
            Expanded(
              child: MessageList(this.messages, true),
            ),
            this.widget.stat != 'student'
                ? MessageWrapper(
                    callback: newCourse,
                    stat: this.widget.stat,
                  )
                : Container(
                    height: 0,
                  ),
          ],
        ));
  }
}

///Holds the title bar.
Widget bar() {
  return AppBar(
    title: Text("Course Home Page"),
    actions: [
      LogoutButton(),
    ],
  );
}
