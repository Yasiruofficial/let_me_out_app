import 'package:flutter/material.dart';
import 'package:let_me_out/models/AppUser.dart';
import 'package:let_me_out/models/MyEvent.dart';
import 'package:let_me_out/screens/components/loading_widget.dart';
import 'package:let_me_out/screens/views/admin/Components/HorizontalListBuilderAdmin.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';

class AdminExplore extends StatefulWidget {
  final FirebaseFirestoreService firestoreService;
  final FirebaseAuthService baseAuthService;

  AdminExplore({this.firestoreService, this.baseAuthService});
  @override
  _AdminExploreState createState() => _AdminExploreState();
}

class _AdminExploreState extends State<AdminExplore> {
  List<MyEvent> myEvents;

  Future<void> getEvents() async {
    AppUser user = await widget.baseAuthService.getCurrentUser();
    myEvents = await widget.firestoreService.getAdminEventsById(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingWidget(
              color: Colors.blue,
              animationSize: 50,
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 12),
              child: HorizontalListBuilderAdmin(
                  baseAuthService: widget.baseAuthService,
                  firestoreService: widget.firestoreService,
                  myEvents: myEvents),
            );
          }
        },
      ),
    );
  }
}
