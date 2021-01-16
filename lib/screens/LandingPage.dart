import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:let_me_out/screens/LoginPage.dart';
import 'package:let_me_out/screens/SignUp.dart';
import 'package:let_me_out/screens/views/admin/admin_MainPage.dart';
import 'package:let_me_out/screens/views/user/MainPage.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';
import 'package:let_me_out/view_models/LandingPage_view_model.dart';
import 'package:let_me_out/enums/AuthOption.dart';
import 'package:let_me_out/models/AppUser.dart';
import 'package:let_me_out/screens/components/loading_widget.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  AppUser appuser;
  final FirebaseFirestoreService firestoreService;
  final FirebaseAuthService baseAuthService;
  LandingPage({this.baseAuthService, this.firestoreService});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    Future<void> _checkUser() async {
      appuser = Provider.of<LandingPageViewModel>(context, listen: false).getUser;
      if (appuser == null) {
        appuser = await baseAuthService.getCurrentUser();
        if (appuser != null) {
          Provider.of<LandingPageViewModel>(context, listen: false)
              .updatedUser(appuser);
        }
      }
    }

    return Consumer<LandingPageViewModel>(
      builder: (context, landingPageNotifier, child) {
        return FutureBuilder(
          future: _checkUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                child: LoadingWidget(
                  animationSize: 50,
                  color: Colors.blue,
                ),
                color: Colors.white,
              );
            } else {
              if (landingPageNotifier.getUser == null) {
                if (landingPageNotifier.getAuthOption == AuthOption.sign_in) {
                  return LoginPage(baseAuthService: baseAuthService);
                } else {
                  return SignUpPage(
                      firestoreService: firestoreService,
                      baseAuthService: baseAuthService);
                }
              } else {
                if (appuser.isAdmin == true) {
                  return AdminMainPage(
                    firestoreService: firestoreService,
                    baseAuthService: baseAuthService,
                  );
                } else {
                  return MainPage(
                    firestoreService: firestoreService,
                    baseAuthService: baseAuthService,
                  );
                }
              }
            }
          },
        );
      },
    );
  }
}
