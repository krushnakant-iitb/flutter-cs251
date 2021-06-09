///@nodoc

import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);

class Application {
  static final navKey = new GlobalKey<NavigatorState>();
}

Object r;
bool change = false;

class AppBuilder extends StatefulWidget {
  final Function(BuildContext) builder;

  const AppBuilder({Key key, this.builder}) : super(key: key);

  @override
  AppBuilderState createState() => new AppBuilderState();

  static AppBuilderState of(BuildContext context) {
    return context.findAncestorStateOfType<AppBuilderState>();
  }
}

class AppBuilderState extends State<AppBuilder> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  void rebuild() {
    setState(() {});
  }
}

class TestNote extends StatelessWidget {
  final String body;
  TestNote({this.body});
  @override
  Widget build(BuildContext context) {
    return Text(body);
  }
}
