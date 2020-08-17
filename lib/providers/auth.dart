import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirationTime;
  String _userId;

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
      notifyListeners();
    } on Exception catch (e) {
      throw e;
    }
  }
}
