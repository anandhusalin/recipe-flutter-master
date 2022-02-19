import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/RecipeTabBarWidgetDraft.dart';
import 'package:recipe_app/components/RecipeTabBarWidgetPublish.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/screen/SettingScreen.dart';
import 'package:recipe_app/screen/auth/EditProfileScreen.dart';
import 'package:recipe_app/screen/user/BookMarkScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class ProfileFragment extends StatefulWidget {
  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  TabController? controller;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    LiveStream().on(streamRefreshRecipe, (val) {
      setState(() {});
    });
    LiveStream().on(streamRefreshRecipeData, (val) {
      setState(() {});
    });
    LiveStream().on(streamRefreshUnPublished, (val) {
      setState(() { });
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: appBarWidget(
          language!.profile,
          titleTextStyle: boldTextStyle(size: 20),
          showBack: false,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                SettingScreen().launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
              },
              icon: Icon(Icons.settings, color: context.iconColor),
            ).paddingOnly(right: 8),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonCachedNetworkImage(getStringAsync(USER_PHOTO_URL), fit: BoxFit.cover, height: 50, width: 50).cornerRadiusWithClipRRect(25),
                    16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        4.height,
                        Text(appStore.userName, style: boldTextStyle()),
                        Text(appStore.userEmail, style: primaryTextStyle(size: 14)),
                      ],
                    ).expand(),
                    IconButton(
                      onPressed: () {
                        EditProfileScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                      },
                      icon: Icon(Icons.edit, color: primaryColor),
                    ),
                  ],
                ).paddingOnly(left: 16, top: 16, right: 8),
                16.height,
              ],
            ),
          ),
        ),
        body: DefaultTabController(
          length: appStore.isAdmin || appStore.isDemoAdmin ? 2 : 1,
          initialIndex: 0,
          child: Column(
            children: [
              8.height,
              TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: primaryColor,
                labelPadding: EdgeInsets.all(8),
                indicatorPadding: EdgeInsets.symmetric(vertical: 8),
                indicator: TabIndicator(),
                tabs: [
                  if (appStore.isAdmin || appStore.isDemoAdmin) Text(language!.publish, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (appStore.isAdmin || appStore.isDemoAdmin) Text(language!.drafts, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (!appStore.isAdmin && !appStore.isDemoAdmin) Text(language!.bookmark, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              8.height,
              TabBarView(
                children: [
                  if (appStore.isAdmin || appStore.isDemoAdmin)
                    Responsive(
                      useFullWidth: false,
                      web: RecipeTabBarWidgetPublish(spanCount: 5),
                      mobile: RecipeTabBarWidgetPublish(spanCount: 2),
                      tablet: RecipeTabBarWidgetPublish(spanCount: 3),
                    ),
                  if (appStore.isAdmin || appStore.isDemoAdmin)
                    Responsive(
                      useFullWidth: false,
                      web: RecipeTabBarWidgetDraft(spanCount: 5),
                      mobile: RecipeTabBarWidgetDraft(spanCount: 2),
                      tablet: RecipeTabBarWidgetDraft(spanCount: 3),
                    ),
                  if (!appStore.isAdmin && !appStore.isDemoAdmin) BookMarkScreen(),
                ],
              ).expand(),
            ],
          ),
        ),
      ),
    );
  }
}
