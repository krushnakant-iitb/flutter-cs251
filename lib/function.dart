import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

///This Class facilitates interface for values stored in Local Storage of user's device
class Prefs {
  ///Sets the integer [i] to the key [key].
  void addInt(String key, int i) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, i);
  }

  ///Gets the integer value referred to by [key].
  Future<int> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int ans = prefs.getInt(key);
    return ans;
  }

  ///Sets the string [val] to the key [key].
  void addString(String key, String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, val);
  }

  ///Gets the String value referred to by [key].
  Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString(key) + '1');
    return prefs.getString(key);
  }

  ///Sets the boolean value [b] to the key [key].
  void addBool(String key, bool b) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, b);
  }

  ///Gets the boolean value referred to by [key].
  Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
}

///Checks if user has already logged in earlier sometime.
///If no, returns false.
///Else checks if login token is expired, if yes, clears the data.
///If no, returns true.
Future<bool> checkLogin() async {
  var z = await prefs.getBool('loggedIn');
  SharedPreferences p = await SharedPreferences.getInstance();
  if (z != null) {
    if (z) {
      String tok = await prefs.getString('token');
      DateTime d = JwtDecoder.getExpirationDate(tok);
      if (d.isAfter(DateTime.now())) {
        return true;
      } else {
        p.clear();
        return false;
      }
    } else {
      p.clear();
      return false;
    }
  } else {
    p.clear();
    return false;
  }
}
