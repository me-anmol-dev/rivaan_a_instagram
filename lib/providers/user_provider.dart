import 'package:flutter/material.dart';
import 'package:rivaan_a_instagram/resources/auth_methods.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user = const User(
    uid: '',
    username: '',
    email: '',
    bio: '',
    followers: [],
    following: [],
    photoUrl: '',
  );

  // final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await AuthMethods().getUserDetails();
    _user = user;
    notifyListeners();
  }
}
