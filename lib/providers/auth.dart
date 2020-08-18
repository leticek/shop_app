import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirationTime;
  String _userId;
  Timer _authTimer;

  bool get isAuthorized {
    return token != null;
  }

  String get token {
    if (_expirationTime != null &&
        _expirationTime.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    if (_userId != null) {
      return _userId;
    }
    return null;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expirationTime = null;
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDpZd9LeLmyKXLPc5CYvKeJePVW621OZuE';
    try {
      final resp = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(resp.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expirationTime = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogOut();
      notifyListeners();
      final sharedPrefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expirationTime': _expirationTime.toIso8601String(),
      });
      sharedPrefs.setString('userData', userData);
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<bool> autoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final userData =
          json.decode(prefs.getString('userData')) as Map<String, dynamic>;
      final expirationDate = DateTime.parse(userData['expirationTime']);
      if (expirationDate.isAfter(DateTime.now())) {
        _token = userData['token'];
        _userId = userData['userId'];
        _expirationTime = userData['expirationTime'];
        _autoLogOut();
        notifyListeners();
        return true;
      }
      return false;
    }
    return false;
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    _authTimer = Timer(
        Duration(seconds: _expirationTime.difference(DateTime.now()).inSeconds),
        logOut);
  }
}
