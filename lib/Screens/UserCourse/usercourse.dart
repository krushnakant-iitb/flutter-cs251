import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import '../../main.dart';
import '../ReadBy/user.dart';
import '../After-Login/logout.dart';
import '../../constants.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

///Returns a [List] of [User]s who have taken
///the course with user_id [id].
Future<List<User>> getUsers(int id) async {
  String tok = await prefs.getString('token');
  final response = await http.get(
    'https://back-dashboard.herokuapp.com/api/usercourse/' +
        id.toString() +
        '/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'JWT ' + tok,
    },
  );
  if (response.statusCode == 200) {
    var V = jsonDecode(response.body) as List;
    List<User> cs = V.map((course) => User.fromJson(course)).toList();
    print(cs);
    return cs;
  }
}

///Parent Class for the UserCourseListState.
class UserCourseList extends StatefulWidget {
  final bool prof;
  final int id;
  UserCourseList({this.prof, this.id});
  @override
  UserCourseListState createState() => UserCourseListState();
}

///This Class represents the UI for showing the list of Users who
///are associated with the course.
class UserCourseListState extends State<UserCourseList> {
  ///This variable contains the list of Users who
  ///are associated with the course.
  List<User> users;

  ///This variable is [false] until the method [getUsers] returns a response on init.
  bool done = false;

  ///Initialises the State, its [super], and calls [getReadBy] to get the list
  ///of Users who are associated with the course. Sets [done] to true.
  @override
  void initState() {
    super.initState();
    getUsers(this.widget.id).then((val) => {
          setState(() {
            this.users = val;
            done = true;
          })
        });
  }

  ///This function facilitates removing a user from a course.
  void del(String username) async {
    String tok = await prefs.getString('token');
    print(username);
    final response = await http.post(
      'https://back-dashboard.herokuapp.com/api/usercourse/' +
          this.widget.id.toString() +
          '/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ' + tok,
      },
      body: jsonEncode(
        <String, String>{"username": username},
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      Phoenix.rebirth(Application.navKey.currentContext);
    }
  }

  ///This Widget holds the list of users' usernames.
  ///Returns empty [container] until [getUsers] returns the list.
  ///Also provides a button to delete a user from the course, if
  ///the user is a professor.
  @override
  Widget build(BuildContext context) {
    print(this.users);
    return done
        ? this.users.length != 0
            ? Scaffold(
                appBar: AppBar(
                  title: Text("List of Users"),
                  actions: [
                    LogoutButton(),
                  ],
                ),
                body: ListView.builder(
                  itemCount: this.users.length,
                  itemBuilder: (context, index) {
                    var message = this.users[index];
                    return Card(
                      child: ListTile(
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(message.username),
                            ),
                            this.widget.prof
                                ? RaisedButton(
                                    child: Text("delete"),
                                    onPressed: () => {del(message.username)},
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : Container()
        : Container();
  }
}
