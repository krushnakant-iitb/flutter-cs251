import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import '../../main.dart';
import 'message-read.dart';
import '../../constants.dart';

///The Parent class for the State AcknowledgementPageState.
class AcknowledgementPage extends StatefulWidget {
  final List<Message> messages;
  AcknowledgementPage({this.messages});
  @override
  AcknowledgementPageState createState() => AcknowledgementPageState();
}

///This Class Facilitates the UI and functions
///for acknowledgement of a message by a user.
class AcknowledgementPageState extends State<AcknowledgementPage> {
  ///This function facilitates acknowledgement of a message by a user.
  ///Once acknowledged, the user's name is added to the [readby] list
  ///for the particular message.
  void acknowledge() async {
    String tok = await prefs.getString('token');
    print(tok);
    String username = await prefs.getString('username');
    print("username = ");
    print(username + '1');
    print("len = ");
    print(this.widget.messages.length);
    for (var i = 0; i < this.widget.messages.length; ++i) {
      print("i = :");
      print(i);
      final response = await http.post(
        'https://back-dashboard.herokuapp.com/api/readby/' +
            this.widget.messages[i].id.toString() +
            '/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT ' + tok,
        },
        body: jsonEncode(
          <String, String>{"username": username},
        ),
      );
    }
    Navigator.pop(Application.navKey.currentContext);
  }

  ///This Widget holds the acknowledge button for a message,
  ///which on pressed invokes the [acknowledge()] function.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MessageList(this.widget.messages),
        RaisedButton(
          child: Text('Acknowledge'),
          onPressed: () => acknowledge(),
        )
      ],
    );
  }
}

///Parent class for state MessageListState
///It holds the List of messages to be acknowledged by the user.
class MessageList extends StatefulWidget {
  final List<Message> messages;
  MessageList(this.messages);
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    print(this.widget.messages);
    return Expanded(
        child: ListView.builder(
      itemCount: this.widget.messages.length,
      itemBuilder: (context, index) {
        var message = this.widget.messages[index];

        return Card(
          child: ListTile(
            subtitle: Text(message.message == null ? "" : message.message),
            title:
                Text(message.course_name == null ? " " : message.course_name),
          ),
        );
      },
    ));
  }
}
