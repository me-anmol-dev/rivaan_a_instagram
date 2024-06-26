import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivaan_a_instagram/utilities/color.dart';
import 'package:rivaan_a_instagram/utilities/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  // void navigationTapped(int page) {
  //   pageController.jumpToPage(page);
  // }
  //
  // void onPageChanged(int page) {
  //   setState(() => _page = page);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (page) {
          setState(() => _page = page);
        },
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems,
        // List of widgets
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (int page) {
          setState(() => pageController.jumpToPage(page));
        },
        currentIndex: _page,
        backgroundColor: mobileBackgroundColor,
        activeColor: primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.home,
              color: _page == 0 ? primaryColor : secondaryColor,
            ),
            label: 'Home',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.search,
              color: _page == 1 ? primaryColor : secondaryColor,
            ),
            label: 'Search',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.add_circled,
              color: _page == 2 ? primaryColor : secondaryColor,
            ),
            label: 'Add',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.heart,
              color: _page == 3 ? primaryColor : secondaryColor,
            ),
            label: 'Favourite',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.person,
              color: _page == 4 ? primaryColor : secondaryColor,
            ),
            label: 'People',
            backgroundColor: primaryColor,
          ),
        ],
      ),
    );
  }
}
