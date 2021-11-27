import 'package:auto_animated/auto_animated.dart';
import 'package:bells/business/ResponseModel.dart';
import 'package:bells/business/ringtoneService.dart';
import 'package:bells/detailspage.dart';
import 'package:bells/loadingpage.dart';
import 'package:bells/search_results.dart';
import 'package:bells/styles.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import "package:velocity_x/velocity_x.dart";
import 'business/ringtone.dart';
import 'components/cardPlayer.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RingtoneModel> ringtones = [];
  int page = 1;
  bool isloading = false;
  void getrintones() async {
    var a = await RingtoneService.getTrending(page);
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
    f = FocusNode();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible) {
          // if (sheetController.state.isExpanded)
          sheetController.collapse();
        } else {
          f.unfocus();
          //sheetController.show();
        }
      },
    );

    getrintones();
  }

  @override
  void dispose() {
    f.dispose();
    super.dispose();
  }

  FocusNode f;
  TextEditingController textEditingController = TextEditingController();
  SheetController sheetController = SheetController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteOrange,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: "Bells🔔"
            .text
            .color(black)
            .textStyle(appBarStyle)
            .semiBold
            .size(26)
            .make()
            .centered(),
      ),
      body: SlidingSheet(
        controller: sheetController,
        elevation: 10,
        cornerRadius: 32,
        color: white,
        shadowColor: orange.withOpacity(0.2),
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.65, 0.92],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: [
                    Expanded(
                        child: CupertinoTextField(
                      style: subtitle1,
                      focusNode: f,
                      controller: textEditingController,
                      placeholder: "Search..",
                      placeholderStyle: subtitle1.copyWith(color: Vx.gray500),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(30)),
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
                      context.nextPage(DetailsPage());
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
              "CATEGORIES"
                  .text
                  .color(black)
                  .textStyle(subtitle1)
                  .size(18)
                  .semiBold
                  .align(TextAlign.left)
                  .letterSpacing(2)
                  .make()
                  .py12()
                  .px(16),
              Container(
                height: context.percentHeight * 17,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      width: context.percentWidth * 35,
                      //height: 100,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: orange.withOpacity(0.2),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: Offset(0, 2),
                            )
                          ]),
                      child: Text(Resources.categories[index], style: subtitle1)
                          .centered(),
                    ).onTap(() {
                      context.nextPage(SearchResultsPage(
                        query: Resources.categories[index],
                        isCategoryPage: true,
                      ));
                    });
                  },
                  itemCount: Resources.categories.length,
                ),
              )
            ],
          ),
        ),
        builder: (context, state) {
          return
              // Container(
              //   height: 1000,
              // )
              _listBuilder(state);
        },
        listener: (state) {
          if (state.isAtBottom) {
            print("at end");
            setState(() {
              isloading = true;
            });
            getrintones();
          }
          // if (state.isExpanded) {
          //   if (f.hasFocus) {
          //     print(MediaQuery.of(context).viewInsets.bottom);
          //     sheetController.collapse();
          //   }
          // }
        },
        headerBuilder: (context, state) {
          return Container(
              width: double.infinity,
              child: "TRENDING"
                  .text
                  .color(black)
                  .textStyle(subtitle1)
                  .size(18)
                  .semiBold
                  .align(TextAlign.left)
                  .letterSpacing(2)
                  .make()
                  .py12()
                  .px(16)
                  .p4());
        },
      ),
    );
  }

  Widget _listBuilder(SheetState state) {
    return ringtones.isEmpty
        ? LoadingPage()
        : Container(
            color: white,
            height: (80.0 * ringtones.length) + (isloading ? 120 : 0),
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
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index, anim) => CardPlayer(
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
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          );
  }
}
