import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:let_me_out/models/MyEvent.dart';
import 'package:let_me_out/models/Ticket.dart';
import 'package:let_me_out/screens/components/loading_widget.dart';
import 'package:let_me_out/screens/views/user/SingleEvent.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';
import 'package:let_me_out/view_models/SingleEvent_view_model.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

class HorizontalCard extends StatefulWidget {
  final FirebaseAuthService baseAuthService;
  final FirebaseFirestoreService firestoreService;
  final MyEvent myEvent;

  HorizontalCard({this.baseAuthService, this.firestoreService, this.myEvent});

  @override
  _HorizontalCardState createState() => _HorizontalCardState();
}

class _HorizontalCardState extends State<HorizontalCard> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    List<Ticket> AQTY = new List<Ticket>();
    return Stack(
      children: [
        InkWell(
          onTap: () async {
            setState(() {
              pressed = true;
            });
            AQTY = await widget.firestoreService.getAQTY(widget.myEvent);
            setState(() {
              pressed = false;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ChangeNotifierProvider<SingleEventViewModel>(
                  create: (context) => SingleEventViewModel(),
                  child: SingleEvent(
                    firestoreService: widget.firestoreService,
                    baseAuthService: widget.baseAuthService,
                    event: widget.myEvent,
                    AQTY: AQTY,
                  ),
                ),
              ),
            );
          },
          child: Card(
            color: Colors.white,
            borderOnForeground: true,
            shadowColor: Colors.grey,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 125,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 125,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12)),
                        child: Hero(
                          tag: widget.myEvent.url,
                          child: Image.network(
                            widget.myEvent.url,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: LoadingWidget(
                                    animationSize: 50,
                                    color: Colors.blue,
                                    isImage: true),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: ListTile(
                              dense: true,
                              title: Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  ReCase(widget.myEvent.title).sentenceCase,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                ReCase(widget.myEvent.subTitle).sentenceCase,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 3,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: ListTile(
                              dense: true,
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    color: Colors.green,
                                    size: 12,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      ReCase(widget.myEvent.venue.first
                                              .location.description)
                                          .sentenceCase,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.notifications_active_sharp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        pressed
            ? Positioned(
                right: (MediaQuery.of(context).size.width - 55) / 2,
                bottom: 55,
                child: LoadingWidget(
                  animationSize: 35,
                  color: Colors.blue,
                ))
            : Container(),
      ],
    );
  }
}
