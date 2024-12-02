import 'package:flutter/material.dart';

class Userprovider with ChangeNotifier{
  String _userid = '';
  String _username = '';
  String _email = '';
  int _notifications = 0;

  String get userid => _userid;
  String get username => _username;
  String get email => _email;
  int get notifications => _notifications; 

  void setUserid(String userid){
    _userid = userid;
    notifyListeners();
  }

  void setNotifications(int notifications){
    _notifications = notifications;
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

}