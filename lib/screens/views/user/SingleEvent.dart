import 'package:flutter/material.dart';
import 'package:let_me_out/models/MyEvent.dart';
import 'package:let_me_out/models/Ticket.dart';
import 'package:let_me_out/models/UserEvents.dart';
import 'package:let_me_out/screens/components/CustomDivider.dart';
import 'package:let_me_out/screens/components/loading_widget.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';
import 'package:let_me_out/view_models/SingleEvent_view_model.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class SingleEvent extends StatefulWidget {
  final FirebaseAuthService baseAuthService;
  final FirebaseFirestoreService firestoreService;
  final MyEvent event;
  final List<Ticket> AQTY;

  SingleEvent(
      {this.baseAuthService, this.firestoreService, this.event, this.AQTY});

  @override
  _SingleEventState createState() => _SingleEventState();
}

class _SingleEventState extends State<SingleEvent> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Card(
                    color: Colors.white,
                    borderOnForeground: false,
                    shadowColor: Colors.grey,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        child: Hero(

                          tag: widget.event.url,
                          child: Image.network(
                            widget.event.url,
                            fit: BoxFit.cover,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              for (var i in widget.event.venue)
                Stack(
                  children: [
                    Positioned(
                      right: (MediaQuery.of(context).size.width - 50) / 2,
                      child: loading
                          ? LoadingWidget(
                              animationSize: 50,
                              color: Colors.blue,
                            )
                          : Container(),
                    ),
                    Column(
                      children: [
                        CustomDivider(
                          vertical: 2,
                        ),
                        ClipRRect(
                          child: ListTile(
                            title: Text(
                              widget.event.title,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 2,
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.event.subTitle,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ClipRRect(
                          child: ListTile(
                            title: Text(
                              "Date : ${i.date.toString().split(":")[0].split("T00")[0]} @ ${i.time}",
                              style: TextStyle(
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 2,
                            ),
                            subtitle: Row(
                              children: [
                                Icon(Icons.location_pin),
                                Expanded(
                                  child: Text(
                                    i.location.description,
                                    style: TextStyle(
                                      fontSize: 11,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                          child: ListTile(
                            title: Text(
                              "Available Tickets",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                for (var i in widget.AQTY)
                                  int.parse(i.availableQty) != 0
                                      ? Text(
                                          "RS ${i.price} : ${i.availableQty}",
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        )
                                      : Container(),
                                SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        CustomDivider(
                          vertical: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              SizedBox(
                height: 30,
              ),
              Wrap(
                children: [
                  for (var i in widget.AQTY)
                    int.parse(i.availableQty) != 0
                        ? Consumer<SingleEventViewModel>(
                            builder: (context, value, child) {
                            return Column(
                              children: [
                                ListTile(
                                  leading: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (value.bought_tickets[
                                                int.parse(i.price)] !=
                                            null) {
                                          if (value.bought_tickets[
                                                  int.parse(i.price)] !=
                                              0) {
                                            Provider.of<SingleEventViewModel>(
                                                    context,
                                                    listen: false)
                                                .DECBoughtTickets(
                                                    int.parse(i.price));
                                          }
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.arrow_circle_down),
                                  ),
                                  title: Text(
                                    'Rs ${i.price} : ${value.bought_tickets[int.parse(i.price)] == null ? 0 : value.bought_tickets[int.parse(i.price)]} ',
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        color: Colors.black54),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (value.bought_tickets[
                                                int.parse(i.price)] !=
                                            null) {
                                          if (value.bought_tickets[
                                                  int.parse(i.price)] !=
                                              int.parse(i.availableQty)) {
                                            Provider.of<SingleEventViewModel>(
                                                    context,
                                                    listen: false)
                                                .INCBoughtTickets(
                                                    int.parse(i.price));
                                          }
                                        } else {
                                          Provider.of<SingleEventViewModel>(
                                                  context,
                                                  listen: false)
                                              .INCBoughtTicketsOnNull(
                                                  int.parse(i.price));
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.arrow_circle_up),
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                              ],
                            );
                          })
                        : Container()
                ],
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Consumer<SingleEventViewModel>(
          builder: (context, value, child) {
            return Text(
              "Total : ${value.total}",
              style: TextStyle(
                  fontSize: 25
              ),

            );
          },
        )
      ],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        elevation: 20,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.arrow_back,
              ),
              label: "Back"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.check_box_outlined,
              ),
              label: "Checkout"),
        ],
        currentIndex: 1,
        onTap: navigationTapped,
      )
    );
  }

  Future<void> navigationTapped(int clicked) async {
    Map<int, int> boughtTickets =
        Provider.of<SingleEventViewModel>(context, listen: false)
            .bought_tickets;

    if (clicked == 0) {
      Navigator.of(context).pop();
    } else if (clicked == 1) {
      bool validated = false;
      UserEvents userEvents = new UserEvents();
      List<Ticket> tickets = new List<Ticket>();

      boughtTickets.forEach((key, value) {
        if (value > 0) {
          validated = true;
        }
        Ticket ticket = new Ticket();
        ticket.price = key.toString();
        ticket.availableQty = value.toString();
        tickets.add(ticket);
      });

      if (!validated) {
        Toast.show("At least one ticket required ", context,
            duration: Toast.LENGTH_LONG);
        return 0;
      }

      userEvents.eventId = widget.event.id;
      userEvents.tickets = tickets;
      setState(() {
        loading = true;
      });
      await widget.firestoreService.addUserEvent(userEvents);
      setState(() {
        loading = false;
      });
      Toast.show("Ticket Added", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      Navigator.of(context).pop();
    }
  }
}
