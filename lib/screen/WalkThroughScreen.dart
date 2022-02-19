import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/screen/DashboardScreen.dart';
import 'package:recipe_app/screen/DashboardWebScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class WalkThroughScreen extends StatefulWidget {
  @override
  WalkThroughScreenState createState() => WalkThroughScreenState();
}

class WalkThroughScreenState extends State<WalkThroughScreen> {
  PageController pageController = PageController();

  int currentPage = 0;

  List<WalkThroughModelClass> list = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    list.add(WalkThroughModelClass(title: 'Find your Comfort\n Food here', subTitle: 'Here You Can find a chef or dish for every\n tasted and Color.Enjoy!', image: WalkThroughIMG1));
    list.add(WalkThroughModelClass(title: 'Ricetta is Where Your \n Comfort Food Lives', subTitle: 'Enjoy a fast and smooth food delivery at \n your doorstep', image: WalkThroughIMG2));
  }

  void redirect({bool skip = false}) async {
    await setValue(IS_FIRST_TIME, false);
    if (skip) {
      if (isWeb) {
        DashboardWebScreen().launch(context, isNewTask: true);
      } else {
        DashboardScreen().launch(context, isNewTask: true);
      }
    } else {
      if (currentPage == 1) {
        if (isWeb) {
          DashboardWebScreen().launch(context, isNewTask: true);
        } else {
          DashboardScreen().launch(context, isNewTask: true);
        }
      } else {
        pageController.animateToPage(currentPage + 1, duration: Duration(milliseconds: 300), curve: Curves.linear);
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            children: list.map((e) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonCachedNetworkImage(e.image, fit: BoxFit.cover, height: 250, width: 250).cornerRadiusWithClipRRect(20),
                  50.height,
                  Text(e.title!, style: boldTextStyle(size: 22), textAlign: TextAlign.center),
                  16.height,
                  Text(e.subTitle!, style: secondaryTextStyle(), textAlign: TextAlign.center),
                ],
              );
            }).toList(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 100,
            child: DotIndicator(
              indicatorColor: primaryColor,
              pageController: pageController,
              pages: list,
              unselectedIndicatorColor: grey,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton(
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(10)),
                  padding: EdgeInsets.all(12),
                  text: language!.skip,
                  textStyle: primaryTextStyle(),
                  onTap: () {
                    redirect(skip: true);
                  },
                ).visible(currentPage != 1),
                16.width.visible(currentPage != 1),
                AppButton(
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(10)),
                  padding: EdgeInsets.all(12),
                  color: primaryColor,
                  text: currentPage != 1 ? language!.next : language!.getStarted,
                  textStyle: boldTextStyle(color: white),
                  onTap: () {
                    redirect();
                  },
                ).expand()
              ],
            ).paddingOnly(left: 16, right: 16),
          ),
        ],
      ),
    );
  }
}
