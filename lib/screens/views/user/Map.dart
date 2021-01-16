import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:let_me_out/models/MyEvent.dart';
import 'package:let_me_out/models/Venue.dart';
import 'package:let_me_out/screens/components/loading_widget.dart';
import 'package:let_me_out/screens/views/user/Components/HorizontalCard.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';
import 'package:let_me_out/view_models/MapUpdate_view_model.dart';
import 'package:provider/provider.dart';


class Map extends StatefulWidget {
  final FirebaseAuthService baseAuthService;
  final FirebaseFirestoreService firestoreService;

  Map({this.baseAuthService, this.firestoreService});

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {

  Set<Marker> markers = new Set<Marker>();
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder(
        future: _getMarkers(),
        builder: (context, snapshot) {
          print('snapshot.connectionState : ' + snapshot.connectionState.toString());
          if (snapshot.connectionState != ConnectionState.done) {
            return LoadingWidget(
              animationSize: 50,
              color: Colors.blue,
            );
          } else {
            return Stack(
              children: [
                GoogleMap(
                  onTap: (argument) {
                    Provider.of<MapUpdateViewModel>(context, listen: false)
                        .updateClick(false, null);
                  },
                  markers: markers,
                  mapType: MapType.normal,
                  initialCameraPosition:
                      CameraPosition(zoom: 10, target: markers.first.position),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    Provider.of<MapUpdateViewModel>(context,listen: false).updateMapFullyLoarded();
                  },

                ),
                Consumer<MapUpdateViewModel>(
                  builder: (context, value, child) {
                    if(value.mapFullyLoarded == true){
                      if (value.isMarkerSelected) {
                        MyEvent curruntEvent = value.event;

                        return Positioned(
                            top: 20,
                            right: 15,
                            left: 15,
                            child: HorizontalCard(
                              firestoreService: widget.firestoreService,
                              baseAuthService: widget.baseAuthService,
                              myEvent: curruntEvent ,
                            )
                        );
                      } else {
                        return Container();
                      }
                    }
                    else{
                      return LoadingWidget(animationSize: 50,color: Colors.blue,);
                    }
                  },
                )
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> _getMarkers() async {
    int count = 1;
    List<MyEvent> events =
        await widget.firestoreService.getAllAvailableEvents();
    for (MyEvent event in events) {
      for (Venue venue in event.venue) {
        print("Venue Count is -> $count");
        markers.add(
          new Marker(
            markerId: MarkerId(count.toString()),
            position: LatLng(double.parse(venue.location.lat),
                double.parse(venue.location.lng)),
            onTap: () {
              Provider.of<MapUpdateViewModel>(context, listen: false)
                  .updateClick(true, event);
            },
          ),
        );
        count++;
      }
    }
  }
}
