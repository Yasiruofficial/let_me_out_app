import 'package:flutter/material.dart';
import 'package:let_me_out/enums/Common.dart';
import 'package:let_me_out/screens/views/admin/AdminEditPage.dart';
import 'package:let_me_out/screens/views/admin/admin_explore.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';
import 'package:let_me_out/view_models/EventUpdate_view_model.dart';
import 'package:provider/provider.dart';

class EventUpdateProvider extends StatelessWidget {

  final FirebaseFirestoreService firestoreService;
  final FirebaseAuthService baseAuthService;

  const EventUpdateProvider({this.firestoreService, this.baseAuthService});


  @override
  Widget build(BuildContext context) {
    print("Event Update provider building");
    return Consumer<EventUpdateViewModel>(
      builder: (context, value, child) {
        if(value.option == ExploreOrUpdate.Explore){
          return AdminExplore(
            baseAuthService: baseAuthService,firestoreService: firestoreService,
          );
        }
        else{
          return AdminEditPage(
            firestoreService: firestoreService,baseAuthService: baseAuthService,
          );
        }
      },
    );
  }
}
