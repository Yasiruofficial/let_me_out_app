import 'package:flutter/material.dart';
import 'package:let_me_out/models/MyEvent.dart';
import 'package:let_me_out/screens/components/loading_widget.dart';
import 'package:let_me_out/screens/views/user/Components/CategoryBuilder.dart';
import 'package:let_me_out/screens/views/user/Components/HorizontalListBuilder.dart';
import 'package:let_me_out/screens/views/user/Components/VerticalListBuilder.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';
import 'package:let_me_out/view_models/HomeUpdateViewModel.dart';
import 'package:provider/provider.dart';

import '../../components/loading_widget.dart';

class Home extends StatefulWidget {
  final FirebaseAuthService baseAuthService;
  final FirebaseFirestoreService firestoreService;

  Home({this.baseAuthService, this.firestoreService});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    Provider.of<HomeUpdateViewModel>(context,listen: false).get50Events(widget.firestoreService);
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
                      Expanded(
                          flex: 1,
                          child: Consumer<HomeUpdateViewModel>(
                            builder: (context, value, child) {
                              return CategoryBuilder(firestoreService: widget.firestoreService,selected: value.selected,);
                            },
                          ),
                      ),
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
                        child: Consumer<HomeUpdateViewModel>(
                          builder: (context, value, child) {
                            if(value.loading == true){
                              return LoadingWidget(color: Colors.blue,animationSize: 50);
                            }
                            else{
                              return HorizontalListBuilder(
                                firestoreService: widget.firestoreService,
                                baseAuthService: widget.baseAuthService,
                                myEvents: value.myEvents,
                              );
                            }
                          },

                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
