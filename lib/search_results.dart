import 'package:auto_animated/auto_animated.dart';
import 'package:bells/styles.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'business/ringtone.dart';
import 'business/ringtoneService.dart';
import 'components/cardPlayer.dart';
import 'loadingpage.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;
  final bool isCategoryPage;
  SearchResultsPage({Key key, this.query, this.isCategoryPage = false})
      : super(key: key);

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<RingtoneModel> ringtones = [];
  int page = 1;
  bool isloading = false;
  void getrintones() async {
    var a = await RingtoneService.getResults(widget.query, page);
    print(a.length);
    ringtones.addAll(a);
    setState(() {
      if (20 >= page) page++;
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getrintones();
  }

  @override
  void dispose() {
    f.dispose();
    super.dispose();
  }

  FocusNode f = FocusNode();
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteOrange,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            EvaIcons.arrowIosBackOutline,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: (widget.isCategoryPage ? widget.query : "Search Results")
            .text
            .color(black)
            .textStyle(appBarStyle)
            .semiBold
            .size(20)
            .make(),
      ),
      body: Column(children: <Widget>[
        if (!widget.isCategoryPage)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: [
                Expanded(
                    child: CupertinoTextField(
                  style: subtitle1,
                  focusNode: f,
                  controller: textEditingController,
                  placeholder: "Search again..",
                  placeholderStyle: subtitle1.copyWith(color: Vx.gray500),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                      color: white, borderRadius: BorderRadius.circular(30)),
                )),
                VxCircle(
                  radius: 44,
                  backgroundColor: orange,
                  child: Icon(
                    EvaIcons.search,
                    color: white,
                    size: 24,
                  ),
                ).onTap(() {
                  //context.nextPage(DetailsPage());
                }),
                3.widthBox
              ],
            ).capsule(
                height: 50,
                backgroundColor: white,
                shadows: [
                  BoxShadow(
                    color: orange.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
                border: Border.all(color: orange.withOpacity(0.2))),
          ),
        30.heightBox,
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: white,
                boxShadow: [
                  BoxShadow(
                    color: orange.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 0,
                  )
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              widget.isCategoryPage
                  ? 30.heightBox
                  : "Results for '${widget.query}'"
                      .text
                      .color(black)
                      .textStyle(subtitle1)
                      .size(15)
                      .align(TextAlign.left)
                      .letterSpacing(2)
                      .make()
                      .py12()
                      .px(16)
                      .p4(),
              Expanded(
                child: ringtones.isEmpty
                    ? LoadingPage()
                    : Container(
                        color: white,
                        height:
                            (80.0 * ringtones.length) + (isloading ? 120 : 0),
                        child: Column(
                          children: [
                            Expanded(
                              child: LiveList(
                                  addAutomaticKeepAlives: false,
                                  showItemInterval: Duration(milliseconds: 10),
                                  showItemDuration: Duration(milliseconds: 150),
                                  visibleFraction: 0.05,
                                  reAnimateOnVisibility: true,
                                  itemCount: ringtones.length,
                                  //physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index, anim) =>
                                      CardPlayer(
                                        r: ringtones[index],
                                        animation: anim,
                                      )),
                            ),
                            isloading
                                ? Container(
                                    height: 100,
                                    width: double.infinity,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                        backgroundColor: orange,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
              )
            ]),
          ),
        )
      ]),
    );
  }
}
