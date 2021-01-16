import 'package:flutter/material.dart';
import 'package:let_me_out/screens/components/loading_widget.dart';

class VerticalCard extends StatelessWidget {
  final String photo;

  const VerticalCard({this.photo});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 3),
      child: Card(
        shadowColor: Colors.grey,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
            width: MediaQuery.of(context).size.height/10,
            height:MediaQuery.of(context).size.height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                photo,
                fit: BoxFit.fitHeight,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: LoadingWidget(animationSize: 20, color: Colors.blue,isImage: true),
                  );
                },
              ),
            ),
        ),
      ),
    );
  }
}
