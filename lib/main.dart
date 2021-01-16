import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:let_me_out/screens/LandingPage.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';
import 'package:let_me_out/view_models/LandingPage_view_model.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:provider/provider.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "letmeout",
      home: ChangeNotifierProvider<LandingPageViewModel>(
        create: (context) => LandingPageViewModel(),
        child: LandingPage(
          baseAuthService: new FirebaseAuthService(),
          firestoreService: new FirebaseFirestoreService(),
        ),
      ),
    );
  }


}

