import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///Parent Class for the State CourseForm.
///Used to create new Courses.
class CourseForm extends StatefulWidget {
  final Function(String, String) callback;
  final Function() depressor;
  CourseForm({this.callback, this.depressor});
  @override
  CourseFormState createState() => CourseFormState();
}

///This Class holds the UI and functions for the CourseForm,
///Used to create new Courses.
class CourseFormState extends State<CourseForm> {
  ///Key representing the Form.
  final _formKey = GlobalKey<FormState>();

  ///Input facilitator for course code.
  final controller_code = new TextEditingController();

  ///Input facilitator for course name.
  final controller_name = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller_code.dispose();
    controller_name.dispose();
  }

  ///This function facilitates creating the course.
  ///Called when the button is tapped by the user.
  void click() {
    FocusScope.of(context).unfocus();
    widget.callback(controller_name.text, controller_code.text);
    controller_code.clear();
    controller_name.clear();
  }

  ///This Widget holds the UI of the Form used to create a course.
  @override
  Widget build(BuildContext context) {
    return new Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.arrow_drop_down_sharp),
                  splashColor: Colors.blue,
                  tooltip: "close",
                  onPressed: widget.depressor,
                ),
              ],
            ),
          ),
          new TextFormField(
              controller: controller_name,
              validator: (value) {
                if (value.isEmpty) {
                  return 'CourseName empty';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "  Type in course name",
              )),
          new TextFormField(
              controller: controller_code,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Course Code empty';
                }
                if (value.length > 5) {
                  return 'Course code length limit 5';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "  Type in course code",
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  this.click();
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
