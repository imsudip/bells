import 'package:flutter/material.dart';
import 'package:bells/styles.dart';
import 'package:velocity_x/velocity_x.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.safePercentHeight * 75,
      child: Center(
        child: CircularProgressIndicator(
            backgroundColor: orange,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
      ),
    );
  }
}
