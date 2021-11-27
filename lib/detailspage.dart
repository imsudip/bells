import 'package:bells/styles.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class DetailsPage extends StatefulWidget {
  DetailsPage({Key key}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: [
        VxBox()
            .linearGradient([orange, Vx.yellow400])
            .height(context.percentWidth * 50)
            .width(context.percentWidth * 50)
            .roundedSM
            .shadow5xl
            .make(),
        20.heightBox,
        Slider(value: 0, onChanged: (v) {}),
        [
          "start".text.color(Vx.gray300).textStyle(subtitle2).make(),
          "end".text.color(Vx.gray300).textStyle(subtitle2).make()
        ]
            .hStack(
                alignment: MainAxisAlignment.spaceBetween,
                axisSize: MainAxisSize.max)
            .px16(),
        30.heightBox,
        [
          Icon(
            EvaIcons.rewindLeftOutline,
            color: white,
            size: 32,
          ),
          28.widthBox,
          Icon(
            EvaIcons.arrowRight,
            color: black,
            size: 55,
          ).p8().box.roundedFull.color(blue).make(),
          28.widthBox,
          Icon(
            EvaIcons.rewindRightOutline,
            color: white,
            size: 32,
          ),
        ].hStack(),
        50.heightBox,
        "Apply Ringtone"
            .text
            .color(white)
            .textStyle(subtitle1)
            .bold
            .letterSpacing(1.2)
            .make()
            .px(28)
            .py12()
            .box
            .roundedLg
            .linearGradient([orange, Vx.yellow400]).make(),
        (context.mq.size.height * 0.22).heightBox,
      ].vStack(
          alignment: MainAxisAlignment.end,
          axisSize: MainAxisSize.max,
          crossAlignment: CrossAxisAlignment.center),
    );
  }
}
