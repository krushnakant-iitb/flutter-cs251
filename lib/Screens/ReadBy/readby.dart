import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import '../../main.dart';
import 'user.dart';
import '../After-Login/logout.dart';

///This function returs a `list` of `user`s who have read the message with message_id [id]
Future<List<User>> getReadBy(int id) async {
  String tok = await prefs.getString('token');
  final response = await http.get(
    'https://back-dashboard.herokuapp.com/api/readby/' + id.toString() + '/',
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

///Parent Class for the UserListState.
class UserList extends StatefulWidget {
  final int id;
  UserList(this.id);
  @override
  UserListState createState() => UserListState();
}

///This Class represents the UI for showing the list of Users who
///have read the message.
class UserListState extends State<UserList> {
  ///This variable contains the list of Users who have read the message.
  List<User> users;

  ///This variable is `false` until [getReadBy] returns a response on init.
  bool done = false;

  ///Initialises the State, its `super`, and calls [getReadBy()] to get the list
  ///of Users who have read the message. Sets [done] to true.
  @override
  void initState() {
    super.initState();
    getReadBy(this.widget.id).then((val) => {
          setState(() {
            this.users = val;
            done = true;
          })
        });
  }

  ///This Widget holds the list of those users' usernames
  ///who have read the message.
  ///Returns empty `container` until [getReadBy()] returns the list.
  @override
  Widget build(BuildContext context) {
    print(this.users);
    return done
        ? this.users.length != 0
            ? Scaffold(
                appBar: AppBar(
                  title: Text("Message Read by"),
                  actions: [
                    LogoutButton(),
                  ],
                ),
                body: ListView.builder(
                  itemCount: this.users.length,
                  itemBuilder: (context, index) {
                    var user = this.users[index];
                    return Card(
                      child: ListTile(
                        title: Text(user.username),
                      ),
                    );
                  },
                ),
              )
            : Container()
        : Container();
  }
}
