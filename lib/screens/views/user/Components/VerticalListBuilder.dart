

import 'package:flutter/material.dart';
import 'package:let_me_out/screens/components/loading_widget.dart';

import 'VerticalCard.dart';

class VerticalListBuilder extends StatefulWidget {
  @override
  _VerticalListBuilderState createState() => _VerticalListBuilderState();
}

class _VerticalListBuilderState extends State<VerticalListBuilder> {
  List myList;
  int listLength = 10;
  ScrollController _scrollController = new ScrollController();


  @override
  void initState() {
    super.initState();
    myList = List.generate(10, (index) => "Item ${index + 1}");
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        print(_scrollController.position.pixels);
        _getMoreData();
      }
    });
   }

  void _getMoreData() {
    setState(() {
      for (int i = listLength; i < listLength + 10; i++) {
        myList.add("Item ${i + 1}");
      }
      listLength += 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return;
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (ctx, int) {
          if (myList.length == int + 1) {
            return LoadingWidget(
              animationSize: 30,
              color: Colors.blue,
            );
          } else {
            return Row(
              children: [
                SizedBox(width:4),
                VerticalCard(photo: "https://media.istockphoto.com/photos/couple-in-love-picture-id1069131934"),
                SizedBox(width:4),
              ],
            );
          }
        },
        itemCount: listLength,
      ),
    );
  }
}
