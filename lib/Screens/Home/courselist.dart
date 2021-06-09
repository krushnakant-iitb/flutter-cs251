import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import '../../main.dart';
import './course.dart';
import 'coursestatus.dart';
import '../CourseHome/coursehome.dart';
import '../UserCourse/usercourse.dart';

///Gets the Status of the user wrt a course with courseid [id].
Future<Status> getStat(int id) async {
  String tok = await prefs.getString('token');
  final response = await http.get(
    'https://back-dashboard.herokuapp.com/api/user/' + id.toString() + '/abc/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'JWT ' + tok,
    },
  );
  if (response.statusCode == 200) {
    var V = jsonDecode(response.body);
    Status j = Status.fromJson(V);
    return j;
  } else {
    return null;
  }
}

///The parent Class for the State CourseListState.
class CourseList extends StatefulWidget {
  final bool prof;
  final List<Course> courses;
  final bool done;
  CourseList({this.courses, this.done, this.prof});
  @override
  CourseListState createState() => CourseListState();
}

///This class holds the UI and functions corresponding
///to the list of courses of the user.
class CourseListState extends State<CourseList> {
  ///This function redirects the user to the home page
  ///of a course with courseid [id].
  ///
  ///It appropriately judges the [Status] of the user
  ///wrt the course by calling the function [getStat].
  void doa(int id) {
    getStat(id).then((val) => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return CourseHomePage(
                  stat: val.status,
                  id: id,
                );
              },
            ),
          )
        });
  }

  ///This Widget lists the Courses vertically.
  ///
  ///The code and the name of the course are displayed.
  ///On tapping on a Course, it redirects to the course homepage.
  @override
  Widget build(BuildContext context) {
    return widget.done
        ? ListView.builder(
            itemCount: this.widget.courses.length,
            itemBuilder: (context, index) {
              var course = this.widget.courses[index];
              return InkWell(
                  onTap: () => {
                        getStat(course.id).then(
                          (val) => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CourseHomePage(
                                    stat: val.status,
                                    id: course.id,
                                  );
                                },
                              ),
                            ),
                          },
                        )
                      },
                  child: Card(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(course.name),
                            subtitle: Text(course.code),
                            trailing: RaisedButton(
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return UserCourseList(
                                        prof: this.widget.prof,
                                        id: course.id,
                                      );
                                    },
                                  ),
                                )
                              },
                              color: Colors.blue,
                              child: Text('members'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          )
        : Container();
  }
}
