import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './message.dart';
import '../ReadBy/readby.dart';

///Parent Class for the State MessageList
class MessageList extends StatefulWidget {
  final List<Message> messages;
  final bool done;
  MessageList(this.messages, this.done);
  @override
  MessageListState createState() => MessageListState();
}

///This class holds the UI and functions corresponding to the list of Messages
///for a course.
class MessageListState extends State<MessageList> {
  ///This Widget lists the messages vertically.
  ///
  ///The text and sender of the message are displayed.
  ///On tapping on a message, it directs to the list
  ///of users who have read the message.
  @override
  Widget build(BuildContext context) {
    print(this.widget.messages);
    return widget.done
        ? ListView.builder(
            itemCount: this.widget.messages.length,
            itemBuilder: (context, index) {
              var message = this.widget.messages[index];
              return InkWell(
                onTap: () => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserList(message.id),
                    ),
                  )
                },
                child: Card(
                  child: ListTile(
                    title: Text(message.message),
                    subtitle: Text(message.from_username),
                  ),
                ),
              );
            },
          )
        : Container();
  }
}
