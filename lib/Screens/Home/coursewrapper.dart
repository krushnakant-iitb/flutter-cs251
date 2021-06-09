import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'courseform.dart';

///The Parent Class of the State CourseWrapperState.
class CourseWrapper extends StatefulWidget {
  final Function(String, String) callback;
  CourseWrapper({this.callback});
  @override
  CourseWrapperState createState() => CourseWrapperState();
}

///This Class keeps the CourseForm Wrapped under the hood until
///the "up-arrow" button is pressed.
class CourseWrapperState extends State<CourseWrapper> {
  ///Indicates if the form should be wrapped or not.
  bool active = false;

  ///The Builder, returns CourseForm if [active] is true.
  ///Else just returns a button with "up-arrow".
  @override
  Widget build(BuildContext context) {
    return active
        ? CourseForm(
            callback: widget.callback,
            depressor: this.deactivator,
          )
        : up();
  }

  ///Sets the state of [active] to true.
  void activator() {
    setState(() {
      this.active = true;
    });
  }

  ///sets the state of [active] to false.
  void deactivator() {
    setState(() {
      this.active = false;
    });
  }

  ///Returns a button with up-arrow, which onPressed,
  ///invokes [activator()] and prompts [build()]
  ///to return a CourseForm.
  Widget up() {
    return Container(
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            alignment: Alignment.center,
            padding: EdgeInsets.all(0),
            icon: Icon(Icons.arrow_drop_up_sharp),
            splashColor: Colors.blue,
            tooltip: "open",
            onPressed: this.activator,
          ),
        ],
      ),
    );
  }
}
