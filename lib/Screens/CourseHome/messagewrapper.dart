import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'messageAllform.dart';
import 'messageTAform.dart';

///Parent Class for the MessageWrapperState
class MessageWrapper extends StatefulWidget {
  final Function(String, String, bool) callback;
  final String stat;
  MessageWrapper({this.stat, this.callback});
  @override
  MessageWrapperState createState() => MessageWrapperState();
}

///This class acts as a Wrapper for a Message Form.
class MessageWrapperState extends State<MessageWrapper> {
  ///[activeTA] is true if the message is to be sent only to TAs.
  bool activeTA = false;

  ///[activeAll] is true if the message is to be sent to all, TAs and Students.
  ///At one time, only one of [activeTA] and [activeAll] can be true.
  bool activeAll = false;

  ///Sets [activeTA] to true, and [activeAll] to false.
  void activatorTA() {
    setState(() {
      activeTA = true;
      activeAll = false;
    });
  }

  ///Sets [activeAll] to true, and [activeTA] to false.
  void activatorAll() {
    setState(() {
      activeAll = true;
      activeTA = false;
    });
  }

  ///The depressor.
  ///Sets both [activeTA] and [activeAll] to false.
  ///Keeps the Message form wrapped.
  void dp() {
    setState(() {
      activeAll = false;
      activeTA = false;
    });
  }

  ///This Widget is just keeps the message form wrapped if both [activeTA] and [activeAll] are false.
  ///It builds the [MessageTAform] if [activeTA] is true,
  ///else if [activeAll] is true, it builds [MessageAllform].
  @override
  Widget build(BuildContext context) {
    return activeTA
        ? MessageTAform(
            callback: this.widget.callback,
            depressor: dp,
          )
        : activeAll
            ? MessageAllform(
                callback: this.widget.callback,
                depressor: dp,
              )
            : up();
  }

  ///This Widget keeps the messageForm Wrapped.
  ///
  ///
  ///It holds the UI for the Message Form Toggler, i.e.
  ///the option to send the message to TA or All.
  ///Iff user is a professor, it shows both options, else
  ///if a TA, only "All" option is shown.
  Widget up() {
    return Container(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            this.widget.stat == 'professor'
                ? Column(children: <Widget>[
                    IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.arrow_drop_up_sharp),
                      splashColor: Colors.blue,
                      tooltip: "open TA",
                      onPressed: this.activatorTA,
                    ),
                    Text('TA')
                  ])
                : Container(
                    height: 0,
                    width: 0,
                  ),
            Column(children: <Widget>[
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.arrow_drop_up_sharp),
                splashColor: Colors.blue,
                tooltip: "open All",
                onPressed: this.activatorAll,
              ),
              Text('All')
            ]),
          ],
        ));
  }
}
