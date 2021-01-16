import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  final bool isImage;
  final Color color;
  final double animationSize;
  LoadingWidget(
      {this.animationSize = 20,
      this.isImage = false,
      this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    if (isImage) {
      return SpinKitRipple(
        size: animationSize,
        color: color,
      );
    } else {
      return SpinKitWave(
        size: animationSize,
        color: this.color,
      );
    }
  }
}
