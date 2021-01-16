import 'package:flutter/material.dart';
import 'package:let_me_out/models/MyEvent.dart';
import 'package:let_me_out/screens/components/loading_widget.dart';
import 'package:let_me_out/screens/views/user/Components/CategoryBuilder.dart';
import 'package:let_me_out/screens/views/user/Components/HorizontalListBuilder.dart';
import 'package:let_me_out/screens/views/user/Components/VerticalListBuilder.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';

class Home extends StatefulWidget {
  final FirebaseAuthService baseAuthService;
  final FirebaseFirestoreService firestoreService;

  Home({this.baseAuthService, this.firestoreService});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<MyEvent> myEvents;

  Future<void> getEvents() async {
    myEvents = await widget.firestoreService.getAvailableRecent50Events();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget(
            animationSize: 50,
            color: Colors.blue,
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(left: 12, right: 10, top: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 25,
                        child: Text(
                          'Events near you 📌',
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                      Expanded(flex: 1, child: VerticalListBuilder()),
                    ],
                  ),
                ),
                SizedBox(
                  height: 75,
                  // flex: thisHeight <= 700? 8: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 25,
                        child: Text(
                          'Categories 🧭',
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                      Expanded(flex: 1, child: CategoryBuilder()),
                    ],
                  ),
                ),
                Expanded(
                  flex: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 25,
                        child: Text(
                          'Events may you like 🙊',
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: HorizontalListBuilder(
                          firestoreService: widget.firestoreService,
                          baseAuthService: widget.baseAuthService,
                          myEvents: myEvents,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
