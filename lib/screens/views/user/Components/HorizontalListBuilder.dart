import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:let_me_out/models/MyEvent.dart';
import 'package:let_me_out/screens/views/user/Components/HorizontalCard.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';

class HorizontalListBuilder extends StatefulWidget {

  final FirebaseAuthService baseAuthService;
  final FirebaseFirestoreService firestoreService;
  final List<MyEvent> myEvents;

  HorizontalListBuilder({this.baseAuthService, this.firestoreService, this.myEvents});



  @override
  _HorizontalListBuilderState createState() => _HorizontalListBuilderState();
}

class _HorizontalListBuilderState extends State<HorizontalListBuilder> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
      return ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, int) {
          return HorizontalCard(
            baseAuthService: widget.baseAuthService,
            firestoreService: widget.firestoreService,
            myEvent: widget.myEvents[int],
          );
        },
        itemCount: widget.myEvents.length,
      );
  }
}
