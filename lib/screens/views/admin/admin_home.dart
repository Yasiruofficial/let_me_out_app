import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';

import '../../../models/AppUser.dart';
import '../../../models/MyEvent.dart';
import '../../components/loading_widget.dart';

class AdminHome extends StatefulWidget {
  final FirebaseFirestoreService firestoreService;
  final FirebaseAuthService baseAuthService;

  AdminHome({this.firestoreService, this.baseAuthService});

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  List<MyEvent> myEvents;
  List<String> chartDropdownItemsArray;
  List<List<double>> chartsArray;
  List<double> profitList;
  int itemCount=0;
  bool alreadyLoaded = false;
  int actualChart = 0;
  String actualDropdown;

  Future<void> getDetails() async {

    if(!alreadyLoaded){

      chartDropdownItemsArray = List<String>();
      chartsArray = List<List<double>>();
      profitList = List<double>();

      AppUser user = await widget.baseAuthService.getCurrentUser();
      myEvents = await widget.firestoreService.getAdminEventsById(user.uid);

      for(var i in myEvents){
        itemCount++;
        chartDropdownItemsArray.add(i.title);
        List<double> templist = new List<double>();
        for(int i = 0; i<25; i++){
          var random = new Random();
          double tempDouble = double.parse(random.nextInt(2000).toString());
          if(tempDouble == 0){
            templist.add(1);
          }
          else{
            templist.add(tempDouble) ;
          }

        }
        chartsArray.add(templist);

        double profit  = await widget.firestoreService.getProfitByEventID(i.id);
        profitList.add(profit);

      }
      alreadyLoaded = true;
      actualDropdown = chartDropdownItemsArray[0];
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getDetails(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            if(alreadyLoaded){
              return Opacity(
                opacity: 0,
              );
            }else{
              return LoadingWidget(color: Colors.blue,animationSize: 50);
            }
          }
          else{

            return StaggeredGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: <Widget>[
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Total Events',
                                  style: TextStyle(color: Colors.blueAccent)),
                              Text(itemCount.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34.0))
                            ],
                          ),
                          Material(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(24.0),
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Icon(Icons.event_available,
                                        color: Colors.white, size: 30.0),
                                  )))
                        ]),
                  ),
                ),
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Material(
                              color: Colors.teal,
                              shape: CircleBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.settings_applications,
                                    color: Colors.white, size: 30.0),
                              )),
                          Padding(padding: EdgeInsets.only(bottom: 16.0)),
                          Text('General',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.0)),
                          Text('Edit',
                              style: TextStyle(color: Colors.black45)),
                        ]),
                  ),
                ),
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Material(
                              color: Colors.amber,
                              shape: CircleBorder(),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(Icons.chat,
                                    color: Colors.white, size: 30.0),
                              )),
                          Padding(padding: EdgeInsets.only(bottom: 16.0)),
                          Text('Inbox',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.0)),
                          Text('Chat ', style: TextStyle(color: Colors.black45)),
                        ]),
                  ),
                ),
                _buildTile(
                  Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              DropdownButton(
                                  isDense: true,
                                  value: actualDropdown,
                                  onChanged: (String value) => setState(() {
                                    actualDropdown = value;
                                    actualChart = chartDropdownItemsArray.indexOf(value);
                                  }),
                                  items: chartDropdownItemsArray.map((String title) {
                                    return DropdownMenuItem(
                                      value: title,
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width-150,
                                        child: Text(title,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.0)),
                                      ),
                                    );
                                  }).toList())
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 4.0)),
                          SizedBox(
                            height: 20,
                          ),
                          Sparkline(
                            data: chartsArray[actualChart],
                            lineWidth: 5.0,
                            lineColor: Colors.greenAccent,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _buildTile(
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Total Profit from tickets',
                                              style: TextStyle(color: Colors.redAccent)),
                                          Text("Rs"+profitList[actualChart].toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 34.0))
                                        ],
                                      ),
                                      Material(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(24.0),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Icon(Icons.event,
                                                color: Colors.white, size: 30.0),
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                              onTap: () {

                              }
                          )
                        ],
                      )),
                ),

              ],
              staggeredTiles: [
                StaggeredTile.extent(2, 110.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(2, 350.0),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Color(0x802196F3),
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }
}
