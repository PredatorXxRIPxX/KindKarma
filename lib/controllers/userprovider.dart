import 'package:flutter/material.dart';

class Userprovider with ChangeNotifier{
  String _userid = '';
  String _username = '';
  String _email = '';
  String _password = '';

  String get userid => _userid;
  String get username => _username;
  String get email => _email;
  String get password => _password;

  void setUserid(String userid){
    _userid = userid;
    notifyListeners();
  }

  void setUsername(String username){
    _username = username;
    notifyListeners();
  }

  void setEmail(String email){
    _email = email;
    notifyListeners();
  }

  void setPassword(String password){
    _password = password;
    notifyListeners();
  }

}