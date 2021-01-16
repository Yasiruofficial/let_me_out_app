import 'package:flutter/material.dart';
import 'package:let_me_out/models/MyEvent.dart';
import 'package:let_me_out/screens/views/admin/Components/HorizontalCardAdmin.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';

class HorizontalListBuilderAdmin extends StatefulWidget {
  final List<MyEvent> myEvents;
  final FirebaseFirestoreService firestoreService;
  final FirebaseAuthService baseAuthService;
  HorizontalListBuilderAdmin({this.firestoreService, this.baseAuthService,this.myEvents});


  @override
  _HorizontalListBuilderAdminState createState() => _HorizontalListBuilderAdminState();
}

class _HorizontalListBuilderAdminState extends State<HorizontalListBuilderAdmin> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Card Builder building....");
      return ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, int) {
          return Container(
            child: HorizontalCardAdmin(
              baseAuthService: widget.baseAuthService,
              firestoreService: widget.firestoreService,
              myEvent: widget.myEvents[int],
            ),
          );
        },
        itemCount: widget.myEvents.length,
      );
  }
}
