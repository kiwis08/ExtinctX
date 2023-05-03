import 'package:flutter/material.dart';

class LoginState extends ChangeNotifier {
  LoginState(this._loggedIn);

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  set loggedIn(bool value) {
    _loggedIn = value;
    notifyListeners();
  }
}
