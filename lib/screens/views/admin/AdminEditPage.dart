import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:let_me_out/enums/Common.dart';
import 'package:let_me_out/models/EventLocation.dart';
import 'package:let_me_out/models/MyEvent.dart';
import 'package:let_me_out/models/Ticket.dart';
import 'package:let_me_out/models/Venue.dart';
import 'package:let_me_out/screens/components/CustomDivider.dart';
import 'package:let_me_out/screens/components/loading_widget.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';
import 'package:let_me_out/view_models/EventUpdate_view_model.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class AdminEditPage extends StatefulWidget {
  final FirebaseFirestoreService firestoreService;
  final FirebaseAuthService baseAuthService;

  AdminEditPage({this.firestoreService, this.baseAuthService});

  @override
  _AdminEditPageState createState() => _AdminEditPageState();
}

class _AdminEditPageState extends State<AdminEditPage> {
  MyEvent event;

  String kGoogleApiKey;
  GoogleMapsPlaces _places;

  File _image;
  ImagePicker picker;
  GlobalKey<FormState> _formKey;
  GlobalKey<FormState> _ticketGKey;

  String _price;
  String _qty;

  String _title;
  String _subTitle;
  EventLocation _location;
  List<Venue> _venues;
  List<Ticket> _tickets;
  String _url;
  String dropdownValue;
  DateTime bestDate;
  Widget addBtn = Text('Update');

  @override
  void initState() {
    super.initState();

    kGoogleApiKey = "AIzaSyBoDFQkCzJkESpd2-HJMDPhtFB-hVoLo0U";
    _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

    picker = new ImagePicker();
    _formKey = new GlobalKey<FormState>();
    _ticketGKey = new GlobalKey<FormState>();
    _venues = new List<Venue>();
    _tickets = new List<Ticket>();

    event =
        Provider.of<EventUpdateViewModel>(context, listen: false).getEvent();
    this._title = event.title;
    this._subTitle = event.subTitle;
    this._venues = event.venue;
    this._tickets = event.tickets;
    this._url = event.url;
    dropdownValue = event.category;
  }

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
                      child: _image != null
                          ? ClipRRect(
                              child: Image.file(
                                _image,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            )
                          : ClipRRect(
                              child: Image.network(_url, fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(12),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(Icons.add_a_photo),
                      onPressed: _getAndShowImage,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _title,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.short_text),
                        hintText: 'Name of the event',
                        labelText: 'Name *',
                      ),
                      onSaved: (String value) {
                        setState(() {
                          _title = value;
                        });
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Name can not be empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      initialValue: _subTitle,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.short_text),
                        hintText: 'Short description about the event',
                        labelText: 'Description *',
                      ),
                      onSaved: (String value) {
                        setState(() {
                          _subTitle = value;
                        });
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Description can not be empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20,right: 20),
                      child: DropdownButton<String>(
                        iconDisabledColor: Colors.red,
                        iconEnabledColor: Colors.blue,
                        hint: Text("Select Event Category"),
                        isExpanded: true,
                        value: dropdownValue,
                        icon: Icon(Icons.category_rounded),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.blue),
                        underline: Container(
                          height: 2,
                          color: Colors.blue,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['Beach Party', 'Musical Show', 'Dog Show', 'Halloween Party','Exhibition','Holi Festival']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ListTile(
                title: Text("Add Venue & Date"),
                leading: Icon(Icons.watch_later_outlined),
                trailing: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    _pickDateTime();
                  },
                  color: Colors.blue,
                  iconSize: 40,
                ),
              ),
              for (var i in _venues)
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ListTile(
                        tileColor: Colors.lightBlueAccent,
                        title: Text(
                          "Date : ${i.date.toString().split(":")[0]} @ ${i.time}",
                          //date.toString().split(" ")[0] and time.format(context)
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
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() {
                              _venues.remove(i);
                            });
                          },
                          color: Colors.red,
                        ),
                      ),
                    ),
                    CustomDivider(
                      vertical: 2,
                    ),
                  ],
                ),
              SizedBox(
                height: 30,
              ),
              ListTile(
                title: Text("Add Tickets"),
                leading: Icon(Icons.watch_later_outlined),
                trailing: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    _pickTicketPrices();
                  },
                  color: Colors.blue,
                  iconSize: 40,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Wrap(
                children: [
                  for (var i in _tickets)
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            '${i.availableQty} tickets from Rs.${i.price}',
                            style: TextStyle(
                                letterSpacing: 2, color: Colors.black54),
                          ),
                          deleteIcon: Icon(Icons.cancel),
                          deleteIconColor: Colors.red,
                          onDeleted: () {
                            setState(() {
                              _tickets.remove(i);
                            });
                          },
                          padding: EdgeInsets.all(5),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                      ],
                    )
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
        Row(
          children: [
            FloatingActionButton.extended(
              heroTag: "btn1",
              elevation: 8,
              backgroundColor: Colors.green,
              label: addBtn,
              icon: Icon(Icons.upload_rounded),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  if (_venues.isNotEmpty) {
                    if (_tickets.isNotEmpty) {
                      _formKey.currentState.save();

                      setState(() {
                        addBtn = LoadingWidget();
                      });

                      for (Venue venue in _venues) {
                        if (bestDate == null) {
                          bestDate = DateTime.parse(venue.date);
                        } else {
                          DateTime datetime = DateTime.parse(venue.date);
                          print("best time -> $bestDate Venue Date -> $datetime");

                          if (bestDate.isBefore(datetime)) {
                            print("Explired date changed to -> ${datetime.toIso8601String()}");
                            bestDate = datetime;

                          }
                        }
                      }

                      MyEvent e = new MyEvent(
                          id: event.id,
                          title: _title.toUpperCase(),
                          subTitle: _subTitle.toUpperCase(),
                          tickets: _tickets,
                          venue: _venues,
                          url: _url,
                          authId: event.authId,
                          uploadedOn: event.uploadedOn,
                          category: dropdownValue,
                          expiredOn: bestDate.toIso8601String());
                      bool status =
                          await widget.firestoreService.updateEvent(e, _image);

                      if (!status) {
                        Toast.show("Image Upload Error", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      } else {
                        Toast.show("Event Edited successfully", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                        Provider.of<EventUpdateViewModel>(context,
                                listen: false)
                            .setExploreOrUpdate(ExploreOrUpdate.Explore);
                      }
                    } else {
                      Toast.show("Please add at least one ticket", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                    }
                  } else {
                    Toast.show("Please add at least one venue", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                  }
                  addBtn = Text('Update');
                }
              },
            ),
            SizedBox(
              width: 20,
            ),
            FloatingActionButton.extended(
              heroTag: "btn2",
              elevation: 8,
              backgroundColor: Colors.green,
              label: Text("Back"),
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                Provider.of<EventUpdateViewModel>(context, listen: false)
                    .setExploreOrUpdate(ExploreOrUpdate.Explore);
              },
            ),
          ],
        )
      ],
    );
  }

//---------------------------------------------------------------------------------------------------

  Future<void> _pickDateTime() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2025),
      helpText: "Pick date for your event",
      confirmText: "Pick",
    );

    if (date == null) {
      Toast.show("Please fill the date", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      return null;
    }

    final TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: "Pick time for your event",
      confirmText: "Pick",
    );

    if (time == null) {
      Toast.show("Please fill the time", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      return null;
    }

    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: Mode.fullscreen,
      components: [Component(Component.country, "lk")],
      hint: "Set the location please",
      overlayBorderRadius: BorderRadius.all(Radius.circular(10)),
    );

    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      _location = new EventLocation(
          lat: lat.toString(), lng: lng.toString(), description: p.description);

      setState(() {
        _venues.add(new Venue(
            date: date.toIso8601String(),
            time: time.format(context),
            location: _location));
      });
    } else {
      Toast.show("Location should not be empty", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
  }

  //------------------------------------------------------------------------------------

  Future<void> _getAndShowImage() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 10);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Toast.show("No Image Selected", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      }
    });
  }

  //--------------------------------------------------------------------------------------

  Future<void> _pickTicketPrices() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Form(
            key: _ticketGKey,
            child: SizedBox(
              height: 175,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (newValue) {
                      _price = newValue;
                    },
                    validator: (value) {
                      try {
                        if (value.isEmpty) {
                          return "Please enter the price";
                        } else {
                          double price = double.parse(value);
                          if (price <= 0) {
                            return "Price must be grater than or equals 0";
                          } else {
                            return null;
                          }
                        }
                      } catch (e) {
                        return "Unmatched Input";
                      }
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.attach_money),
                      hintText: 'Price',
                      labelText: 'Ticket Price *',
                    ),
                  ),
                  TextFormField(
                    onSaved: (newValue) {
                      _qty = newValue;
                    },
                    validator: (value) {
                      try {
                        if (value.isEmpty) {
                          return "Please enter the Quantity";
                        } else {
                          int qty = int.parse(value);
                          if (qty <= 0) {
                            return "Input a Real Quantity";
                          } else {
                            return null;
                          }
                        }
                      } catch (e) {
                        return "Unmatched Input";
                      }
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.sticky_note_2),
                      hintText: 'QTY',
                      labelText: 'Number of tickets*',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            new FloatingActionButton.extended(
              heroTag: "btn3",
              icon: Icon(Icons.sticky_note_2),
              label: Text("Add Ticket"),
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onPressed: () {
                if (_ticketGKey.currentState.validate()) {
                  _ticketGKey.currentState.save();
                  setState(() {
                    _tickets.add(new Ticket(price: _price, availableQty: _qty));
                  });
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      },
    );
  }
}
