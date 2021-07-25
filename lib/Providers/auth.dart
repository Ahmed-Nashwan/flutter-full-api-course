import 'dart:convert';

import 'package:ecommerce_max_app/Providers/HttpException.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  String user_id;
  DateTime _expiry_date;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null &&
        _expiry_date.isAfter(DateTime.now()) &&
        _expiry_date != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return user_id;
  }

  Future<void> signup(String email, String password) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDBYuIlJtfpTXRWrJ7-RrBV0ROGxe7_r_Q";

    try {
      var res = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final response = json.decode(res.body);
      if (response["error"] != null) {
        throw HttpException(response["error"]["message"]);
      }
    } catch (error) {
      throw error;
    }

    //   print(json.decode(res.body));
  }

  Future<bool> tryToLogin() async {
    final shared = await SharedPreferences.getInstance();
    if (!shared.containsKey("userData")) {
      print("return false empty userdata");
      return false;

    }
    final userData = json.decode(shared.get("userData")) as Map<String, dynamic>;
    final dateTime = _expiry_date = DateTime.parse(userData["expiryDate"]);
    if(dateTime.isBefore(DateTime.now())){
      print("return false dateTime is after");
      return false;
    }
    print("true");
    _token = userData["token"];
    user_id = userData["userId"];
    _expiry_date = dateTime;
    notifyListeners();
    return true;
  }



  Future<void> signin(String email, String password) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDBYuIlJtfpTXRWrJ7-RrBV0ROGxe7_r_Q";

    try {
      var res = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final response = json.decode(res.body);
      if (response["error"] != null) {
        throw HttpException(response["error"]["message"]);
      }
      _token = response["idToken"];
      user_id = response["localId"];
      _expiry_date = DateTime.now().add(
        Duration(
          seconds: int.parse(response["expiresIn"]),
        ),
      );
      notifyListeners();

      final shared = await SharedPreferences.getInstance();
      shared.setString(
          "userData",
          json.encode({
            'token': _token,
            'userId': user_id,
            'expiryDate': _expiry_date.toIso8601String(),
          }));
    } catch (error) {
      throw error;
    }

    //  print(json.decode(res.body));
  }

  Future<void> logout() async{
    user_id = null;
    _token = null;
    _expiry_date = null;
    notifyListeners();
    final pref = await  SharedPreferences.getInstance();

    pref.clear();
  }
}
