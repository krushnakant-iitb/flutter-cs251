import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///Parent Class for the State MessageTAForm
class MessageTAform extends StatefulWidget {
  final Function(String, String, bool) callback;
  final Function() depressor;
  MessageTAform({this.callback, this.depressor});
  @override
  MessageTAformState createState() => MessageTAformState();
}

///This Class holds the UI and functions for the MessageTA Form.
class MessageTAformState extends State<MessageTAform> {
  ///[z] is `true` if the priority of message is high, else it is [false].
  ///Default Initialisation is `false`.
  bool z = false;

  ///Key representing the Form.
  final _formKey = GlobalKey<FormState>();

  ///This is an interface between the app and the text input by the user.
  final controller = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  ///This function facilitates sending the message to TAs.
  ///Called when send button is tapped by the user.
  void t() {
    FocusScope.of(context).unfocus();
    widget.callback(controller.text, 'TA', this.z);
    controller.clear();
  }

  ///This Widget hold the Form to send the Message to TAs.
  ///It has a toggler to indicate the priority of the message.
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
                    padding: EdgeInsets.all(0),
                    color: Colors.black,
                    icon: Icon(Icons.arrow_downward_sharp),
                    onPressed: this.widget.depressor,
                  ),
                ],
              )),
          TextFormField(
            controller: this.controller,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.message),
              labelText: "Type your message for TAs",
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.send),
                    splashColor: Colors.blue,
                    tooltip: "post message",
                    onPressed: this.t,
                  ),
                  Switch(
                    value: z,
                    onChanged: (value) => {
                      setState(() {
                        this.z = value;
                      })
                    },
                    activeColor: Colors.red,
                    activeTrackColor: Colors.redAccent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
