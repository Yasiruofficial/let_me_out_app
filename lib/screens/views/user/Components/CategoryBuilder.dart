import 'package:flutter/material.dart';
import 'package:let_me_out/view_models/HomeUpdateViewModel.dart';
import 'package:provider/provider.dart';

import '../../../../services/FirebaseFirestoreService.dart';

class CategoryBuilder extends StatefulWidget {

  final FirebaseFirestoreService firestoreService;
  int selected;

  CategoryBuilder({this.firestoreService,this.selected});

  @override
  _CategoryBuilderState createState() => _CategoryBuilderState();
}

class _CategoryBuilderState extends State<CategoryBuilder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int duration = 400;
    Curve curves =  Curves.easeInQuad;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return;
      },
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (ctx, int) {
          return Padding(
            padding: EdgeInsets.only(left: 3,right: 3),
            child: Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: <Widget>[
                InkWell(
                  onTap: (){
                    Provider.of<HomeUpdateViewModel>(context,listen: false).get50EventsNew(widget.firestoreService);
                  },
                  child: AnimatedContainer(
                    padding: EdgeInsets.all(10),
                    duration: Duration(milliseconds: duration),
                    curve: curves,
                    child: Text('All',style: TextStyle(
                        color: widget.selected==0?Colors.white:Colors.black
                    ),),
                    decoration: BoxDecoration(
                      color: widget.selected==0?Colors.green:Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Provider.of<HomeUpdateViewModel>(context,listen: false).getCustomEvents(widget.firestoreService, "Beach Party",1);
                  },
                  child: AnimatedContainer(
                    padding: EdgeInsets.all(10),
                    duration: Duration(milliseconds: duration),
                    curve: curves,
                    child: Text('Beach Party',style: TextStyle(
                      color: widget.selected==1?Colors.white:Colors.black
                    ),),
                    decoration: BoxDecoration(
                      color: widget.selected==1?Colors.green:Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Provider.of<HomeUpdateViewModel>(context,listen: false).getCustomEvents(widget.firestoreService, "Musical Show",2);
                  },
                  child: AnimatedContainer(
                    padding: EdgeInsets.all(10),
                    duration: Duration(milliseconds: duration),
                    curve: curves,
                    child: Text('Musical Show',style: TextStyle(
                        color: widget.selected==2?Colors.white:Colors.black
                    ),),
                    decoration: BoxDecoration(
                      color: widget.selected==2?Colors.green:Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Provider.of<HomeUpdateViewModel>(context,listen: false).getCustomEvents(widget.firestoreService, "Dog Show",3);
                  },
                  child: AnimatedContainer(
                    padding: EdgeInsets.all(10),
                    duration: Duration(milliseconds: duration),
                    curve: curves,
                    child: Text('Dog Show',style: TextStyle(
                        color: widget.selected==3?Colors.white:Colors.black
                    ),),
                    decoration: BoxDecoration(
                      color: widget.selected==3?Colors.green:Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Provider.of<HomeUpdateViewModel>(context,listen: false).getCustomEvents(widget.firestoreService, "Halloween Party",4);
                  },
                  child: AnimatedContainer(
                    padding: EdgeInsets.all(10),
                    duration: Duration(milliseconds: duration),
                    curve: curves,
                    child: Text('Halloween Party',style: TextStyle(
                        color: widget.selected==4?Colors.white:Colors.black
                    ),),
                    decoration: BoxDecoration(
                      color: widget.selected==4?Colors.green:Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Provider.of<HomeUpdateViewModel>(context,listen: false).getCustomEvents(widget.firestoreService, "Exhibition",5);
                  },
                  child: AnimatedContainer(
                    padding: EdgeInsets.all(10),
                    duration: Duration(milliseconds: duration),
                    curve: curves,
                    child: Text('Exhibition',style: TextStyle(
                        color: widget.selected==5?Colors.white:Colors.black
                    ),),
                    decoration: BoxDecoration(
                      color: widget.selected==5?Colors.green:Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Provider.of<HomeUpdateViewModel>(context,listen: false).getCustomEvents(widget.firestoreService, "Holi Festival",6);
                  },
                  child: AnimatedContainer(
                    padding: EdgeInsets.all(10),
                    duration: Duration(milliseconds: duration),
                    curve: curves,
                    child: Text('Holi Festival',style: TextStyle(
                        color: widget.selected==6?Colors.white:Colors.black
                    ),),
                    decoration: BoxDecoration(
                      color: widget.selected==6?Colors.green:Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: 1,
      ),
    );
  }
}
