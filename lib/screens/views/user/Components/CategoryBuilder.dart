import 'package:flutter/material.dart';

class CategoryBuilder extends StatefulWidget {
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
                  onTap: (){},
                  child: Chip(
                    label: Text('Beach Party'),
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child: Chip(
                    label: Text('Musical Show'),
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child: Chip(
                    label: Text('Dog Show'),
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child: Chip(
                    label: Text('Halloween Party'),
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child: Chip(
                    label: Text('Exhibition'),
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child: Chip(
                    label: Text('Holi Festival'),
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
