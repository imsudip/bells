import 'package:bells/homepage.dart';
import 'package:bells/styles.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';

import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:velocity_x/velocity_x.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  int selectedTab = 0;
  List<Widget> screens = [
    HomePage(),
    Container(),
    Container(),
  ];
  TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller =
        new TabController(length: 3, vsync: this, initialIndex: selectedTab);
    _controller.addListener(_handleSelected);
  }

  void _handleSelected() {
    setState(() {
      selectedTab = _controller.index;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: TabBarView(
                controller: _controller,
                children: List.generate(3, (index) => screens[index])),
          ),
          // Positioned(top: 106, left: 0, right: 0, child: _tabBar())
          // Positioned(top: 10, left: 16, right: 16, child: _bottomAppBar())
        ],
      ),
    );
  }

  Widget _tabBar() {
    return TabBar(
      controller: _controller,
      tabs: [
        Tab(
          text: 'Home',
        ),
        Tab(
          text: 'Home',
        ),
        Tab(
          text: 'Home',
        ),
      ],
    );
  }

  Container _bottomAppBar() {
    return Container(
      height: kBottomNavigationBarHeight + 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: orange.withOpacity(0.3)),
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: DotNavigationBar(
                margin: EdgeInsets.symmetric(horizontal: 32, vertical: 5),
                itemPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                currentIndex: selectedTab,
                onTap: (i) {
                  setState(() {
                    _controller.animateTo(i,
                        duration: Duration(milliseconds: 400));
                  });
                },
                unselectedItemColor: Vx.gray500,
                // dotIndicatorColor: Colors.black,
                items: [
                  /// Home
                  DotNavigationBarItem(
                    icon: selectedTab == 0
                        ? Icon(EvaIcons.home)
                        : Icon(EvaIcons.homeOutline),
                    selectedColor: orange,
                  ),
                  DotNavigationBarItem(
                    icon: selectedTab == 1
                        ? Icon(EvaIcons.grid)
                        : Icon(EvaIcons.gridOutline),
                    selectedColor: orange,
                  ),
                  DotNavigationBarItem(
                    icon: selectedTab == 2
                        ? Icon(EvaIcons.heart)
                        : Icon(EvaIcons.heartOutline),
                    selectedColor: orange,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
