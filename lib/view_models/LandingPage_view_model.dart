import 'package:flutter/foundation.dart';
import 'package:let_me_out/enums/AuthOption.dart';
import 'package:let_me_out/models/AppUser.dart';

class LandingPageViewModel extends ChangeNotifier {

  AuthOption _authOption = AuthOption.sign_in;
  AuthOption get getAuthOption=> _authOption;

  AppUser _user;
  AppUser get getUser => _user;

  void updatedUser(AppUser user) {
    _user = user;
    notifyListeners();
  }

  void updatedAuthOption(AuthOption authOption) {
    _authOption = authOption;
    notifyListeners();
  }

}

