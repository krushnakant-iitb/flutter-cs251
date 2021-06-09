import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/Screens/Home/home.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as secure;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'function.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'constants.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:oktoast/oktoast.dart';
import 'Screens/Home/home.dart';
import 'Screens/Home/acknowledgement.dart';
import 'Screens/Home/message-read.dart';
import 'package:flutter_dnd/flutter_dnd.dart';

///Variable to facilitate interaction with local storage.
final store = new secure.FlutterSecureStorage();

///The BASE URL of the backend.
final BASE = 'https://back-dashboard.herokuapp.com/';

///The JSON Web token corresponding the current user session
String token;

///To Indicate if a user is loggedIn or not
bool loggedIn;

///Variable to facilitate interaction with FirebaseMessaging for notifications.
final fbm = FirebaseMessaging();

///The interface for values stored in Local Storage of user's device
Prefs prefs = new Prefs();

///A Channel for communicating with platform plugins using asynchronous method calls.
const MethodChannel _channel = MethodChannel('com.example.flutter_auth/1');
Map<String, String> channelMap = {
  "id": "MESSAGES",
  "name": "MESSAGES",
  "description": "hi"
};

///To create a channel for Notifications.
void _createChannel() async {
  try {
    await _channel.invokeMethod('createNotificationChannel', channelMap);
    print("2 work");
  } on PlatformException catch (e) {
    print(e);
  }
}

///This function facilitates background notifications, and manages
///to surpass the DND/silent feature of the user's device
///depending upon the priority of the message.
Future<dynamic> _backgroundMessageHandler(Map<String, dynamic> message) async {
  int filter = await FlutterDnd.getCurrentInterruptionFilter();
  String filterName = FlutterDnd.getFilterName(filter);
  print("filtername = $filterName");
  print("filter = $filter");
  if (filter == 1) {
    print("_backgroundMessageHandler");
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      debugPrint("data here......");
      final dynamic priority = data['priority'];
      bool prior = (priority == "true") ? true : false;
      print(prior);
      if (prior == true) {
        FlutterRingtonePlayer.play(
          android: AndroidSounds.notification,
          ios: IosSounds.glass,
          looping: false, // Android only - API >= 28
          volume: 1.0, // Android only - API >= 28
          asAlarm: prior, // Android only - all APIs
        );
      }
      print("_backgroundMessageHandler data: $data");
    }
  }
}

///This function facilitates acknowledgement of a message by a user.
///Once acknowledged, the user's name is added to the [readby] list
///for the particular message.
Future<dynamic> ackn(int id) async {
  String username = await prefs.getString('username');
  String tok = await prefs.getString('token');
  final response = await http.post(
    'https://back-dashboard.herokuapp.com/api/readby/' + id.toString() + '/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'JWT ' + tok,
    },
    body: jsonEncode(
      <String, String>{"username": username},
    ),
  );
}

Future<void> _showMyDialog(context, String bod, bool pr, int id,
    {bool pr1 = true}) async {
  // int filter = await FlutterDnd.getCurrentInterruptionFilter();
  // if (filter != 1) return null;
  print("pr = ");
  print(pr);
  if (pr == true) {
    FlutterRingtonePlayer.play(
      android: AndroidSounds.notification,
      ios: IosSounds.glass,
      looping: false, // Android only - API >= 28
      volume: 1, // Android only - API >= 28
      asAlarm: true, // Android only - all APIs
    );
  } else {
    if (pr1 == true) FlutterRingtonePlayer.playNotification();
    // FlutterRingtonePlayer.stop();
  }
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('hi'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(bod),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Approve'),
            onPressed: () {
              if (pr) {
                FlutterRingtonePlayer.stop();
              }
              ackn(id).then((val) => {Phoenix.rebirth(context)});
            },
          ),
        ],
      );
    },
  );
}

///This function Sets a callback for receiving messages
///from the platform plugins on the notification channel.
///Appropriately notifies corresponding to priority of the message.
Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChannels.lifecycle.setMessageHandler((message) async {
    debugPrint('SystemChannel $message');
    if (message == AppLifecycleState.resumed.toString()) {
      print("hi");
      Phoenix.rebirth(Application.navKey.currentContext);
      List<Message> msg = await getUnreadMessage();
      if (msg.length != 0) {
        Navigator.push(
          Application.navKey.currentContext,
          MaterialPageRoute(
            builder: (context) {
              return AcknowledgementPage(messages: msg);
            },
          ),
        );
      }
    }
  });
  fbm.requestNotificationPermissions();
  fbm.getToken().then((val) => {print(val)});
  _createChannel();
  fbm.configure(
      onMessage: (msg) async {
        print('msg');
        print(msg);
        print(Application.navKey.currentContext.size.aspectRatio);
        print(Application.navKey.currentWidget);
        List<Message> msg1 = await getUnreadMessage();
        FlutterRingtonePlayer.playNotification();
        if (msg1.length != 0) {
          Navigator.push(
            Application.navKey.currentContext,
            MaterialPageRoute(
              builder: (context) {
                return AcknowledgementPage(messages: msg1);
              },
            ),
          );
        }
        return;
      },
      onBackgroundMessage: _backgroundMessageHandler,
      onLaunch: (msg) async {
        print('lnch');
        print(msg);
        var U = msg["data"];
        print(U);
        String p = msg["data"]["priority"];
        bool prior;
        if (p == "true") {
          prior = true;
        } else {
          prior = false;
        }
        // _showMyDialog(Application.navKey.currentContext, U["body"], prior);
        return;
      },
      onResume: (msg) async {
        print('rs');
        print(msg);
        var U = msg["data"];
        print(U);
        String p = msg["data"]["priority"];
        bool prior;
        if (p == "true") {
          prior = true;
        } else {
          prior = false;
        }
        // _showMyDialog(Application.navKey.currentContext, U["body"], prior, pr1:prior);
      });
  prefs.addBool('change', false);
  bool z = await checkLogin();
  bool p = await prefs.getBool('professor');
  if (z) {
    runApp(Phoenix(
      child: MyHomeApp(
        prof: p,
      ),
    ));
  } else {
    runApp(
      Phoenix(child: MyApp()),
    );
  }
}

///This widget is the root of the application.
///
///Initialises the State of the App,
///opens [LoginScreen()] if no past session exists
///
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("appkey = ");
    print(Application.navKey);

//  A non-null String must be provided to a Text widget.
// 'package:flutter/src/widgets/text.dart':
// Failed assertion: line 370 pos 10: 'data != null'
    return MaterialApp(
      navigatorKey: Application.navKey,
      debugShowCheckedModeBanner: false,
      title: "Flutter Auth",
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: new Scaffold(body: LoginScreen()),
    );
  }
}

class MyHomeApp extends StatelessWidget {
  // This widget is the root of your application.
  final prof;
  MyHomeApp({this.prof});
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        navigatorKey: Application.navKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: new Scaffold(body: HomePage(prof: prof)),
      ),
    );
  }
}

bool z = true;
