import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/fragment/HomeFragment.dart';
import 'package:recipe_app/fragment/ProfileFragment.dart';
import 'package:recipe_app/fragment/SearchFragment.dart';
import 'package:recipe_app/fragment/ShoppingListFragment.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/AppModel.dart';
import 'package:recipe_app/screen/auth/SignInScreen.dart';
import 'package:recipe_app/screen/newRecipe/NewRecipeScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/DataProvider.dart';
import 'package:recipe_app/utils/Widgets.dart';

class DashboardScreen extends StatefulWidget {
  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  List<AppModel> list = getAllData();

  UniqueKey indexStackKey = UniqueKey();

  int maxSwitch = 20;
  int currentSwitchCount = 0;
  int currentIndex = 0;

  int value = 0;
  DateTime? currentBackPressTime;

  List<Widget> page = [
    HomeFragment(),
    SearchFragment(),
    if (appStore.isAdmin || appStore.isDemoAdmin) SizedBox(),
    ShoppingListFragment(),
    ProfileFragment(),
  ];

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() => init());
  }

  Future<void> init() async {
    await 1.seconds.delay;
    //region System Mode
    if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
      appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
    }

    window.onPlatformBrightnessChanged = () async {
      if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
        appStore.setDarkMode(context.platformBrightness() == Brightness.light);
      }
    };
    //endregion
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          toast('Press back again to exit app');
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        body: IndexedStack(
          key: indexStackKey,
          index: value,
          children: page,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: value,
          selectedItemColor: primaryColor,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) {
            if (index != 1) {
              hideKeyboard(context);
            }
            if (index == 2 && (!appStore.isAdmin || !appStore.isDemoAdmin)) {
              //toast(NotAuthorisedMsg);
            }
            if ((index == 2 || index == 3 || index == 4) && (!getBoolAsync(IS_LOGGED_IN))) {
              SignInScreen().launch(context);
            } else {
              currentSwitchCount++;

              if (currentSwitchCount > maxSwitch) {
                indexStackKey = UniqueKey();
                currentSwitchCount = 0;
              }

              if ((appStore.isAdmin || appStore.isDemoAdmin) && index == 2) {
                Navigator.of(context).push(createRoute(widget: NewRecipeScreen()));
              } else {
                value = index;
              }
              setState(() {});
            }
          },
          items: [
            BottomNavigationBarItem(icon: Image.asset('images/ic_home.png', width: 20), label: '', activeIcon: Image.asset('images/ic_home_active.png', width: 20)),
            BottomNavigationBarItem(icon: Image.asset('images/ic_search.png', width: 16), label: '', activeIcon: Image.asset('images/ic_search_active.png', width: 20)),
            if (appStore.isAdmin || appStore.isDemoAdmin)
              BottomNavigationBarItem(icon: Image.asset('images/ic_add.png', width: 20), label: '', activeIcon: Image.asset('images/ic_add.png', width: 20)),
            BottomNavigationBarItem(icon: Image.asset('images/ic_shopping.png', width: 20), label: '', activeIcon: Image.asset('images/ic_shopping_active.png', width: 20)),
            BottomNavigationBarItem(icon: Image.asset('images/ic_profile.png', width: 20), label: '', activeIcon: Image.asset('images/ic_profile_active.png', width: 16)),
          ],
        ),
      ),
    );
  }
}
