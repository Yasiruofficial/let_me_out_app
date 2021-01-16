import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';

class AdminHome extends StatefulWidget {
  final FirebaseFirestoreService firestoreService;
  final FirebaseAuthService baseAuthService;

  AdminHome({this.firestoreService, this.baseAuthService});

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final List<List<double>> charts = [
    [1, 3, 2, 4],
    [1, 3, 2, 4, 5],
    [1, 3, 2, 4, 5, 6]
  ];

  static final List<String> chartDropdownItems = [
    'Last 7 days',
    'Last month',
    'Last year'
  ];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StaggeredGridView.count(
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
                        Text('45',
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
                          child: Icon(Icons.notifications_active,
                              color: Colors.white, size: 30.0),
                        )),
                    Padding(padding: EdgeInsets.only(bottom: 16.0)),
                    Text('Alerts',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 24.0)),
                    Text('Active ', style: TextStyle(color: Colors.black45)),
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Revenue',
                                style: TextStyle(color: Colors.green)),
                            Text('\$450',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 34.0)),
                          ],
                        ),
                        DropdownButton(
                            isDense: true,
                            value: actualDropdown,
                            onChanged: (String value) => setState(() {
                                  actualDropdown = value;
                                  actualChart = chartDropdownItems
                                      .indexOf(value); // Refresh the chart
                                }),
                            items: chartDropdownItems.map((String title) {
                              return DropdownMenuItem(
                                value: title,
                                child: Text(title,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0)),
                              );
                            }).toList())
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 4.0)),
                    Sparkline(
                      data: charts[actualChart],
                      lineWidth: 5.0,
                      lineColor: Colors.greenAccent,
                    )
                  ],
                )),
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
                        Text('All Events',
                            style: TextStyle(color: Colors.redAccent)),
                        Text('92',
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
                          child: Icon(Icons.event_available,
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
        staggeredTiles: [
          StaggeredTile.extent(2, 110.0),
          StaggeredTile.extent(1, 180.0),
          StaggeredTile.extent(1, 180.0),
          StaggeredTile.extent(2, 220.0),
          StaggeredTile.extent(2, 110.0),
        ],
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
