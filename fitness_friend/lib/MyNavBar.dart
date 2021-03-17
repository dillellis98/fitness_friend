import 'package:fitnessfriend/FoodLog.dart';
import 'package:fitnessfriend/ProfilePage.dart';
import 'package:fitnessfriend/WorkoutPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'LogoPage.dart';
import 'database_helper.dart';

class MyNavBar extends StatefulWidget {
  final int uid;

  MyNavBar(
      this.uid
      );
  @override
  _MyNavBarState createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  int bottomSelectedIndex = 1;


  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(FontAwesomeIcons.dumbbell),
          title: new Text('Work Out')
      ),
      BottomNavigationBarItem(
        icon: new Icon(FontAwesomeIcons.home),
        title: new Text('Home'),
      ),
      BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.user),
          title: Text('Profile')
      )
    ];
  }

  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        WorkoutPage(widget.uid),
        FoodLog(widget.uid),
        ProfilePage(widget.uid)
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomSelectedIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        items: buildBottomNavBarItems(),
      ),
    );
  }
}


