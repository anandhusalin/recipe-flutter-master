import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/RecipeComponentWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeModel.dart';
import 'package:recipe_app/screen/auth/SignInScreen.dart';
import 'package:recipe_app/screen/recipe/RecipeDetailMobileScreen.dart';
import 'package:recipe_app/screen/recipe/RecipeDetailWebScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';

class LatestRecipeWidget extends StatefulWidget {
  final List<RecipeModel> recipes;
  final int spanCount;

  LatestRecipeWidget(this.recipes, {this.spanCount = 2});

  @override
  LatestRecipeWidgetState createState() => LatestRecipeWidgetState();
}

class LatestRecipeWidgetState extends State<LatestRecipeWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    LiveStream().on(streamRefreshToDo, (s) {
      setState(() {});
    });
    LiveStream().on(streamRefreshRecipeData, (s) {
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 16,
      spacing: 16,
      children: widget.recipes.validate().map((e) {
        return RecipeComponentWidget(
          recipeModel: e,
          spanCount: widget.spanCount,
          widgetData: IconButton(
            padding: EdgeInsets.only(bottom: 16),
            icon: Icon(
              e.is_bookmark == 0 ? Icons.bookmark_border_rounded : Icons.bookmark,
              color: black,
              size: 20,
            ),
            visualDensity: VisualDensity.compact,
            onPressed: () async {
              if (appStore.isDemoAdmin) {
                snackBar(context, title: language!.demoUserMsg);
              } else {
                if (!getBoolAsync(IS_LOGGED_IN)) {
                  SignInScreen().launch(context);
                } else {
                  if (e.is_bookmark.validate() == 0) {
                    e.is_bookmark = 1;
                  } else {
                    e.is_bookmark = 0;
                  }
                  setState(() {});

                  addBookMarkData(e.id!, context, e.is_bookmark!).then((value) {
                    LiveStream().emit(streamRefreshBookMark, streamRefreshBookMark);
                  }).catchError((error) {
                    if (e.is_bookmark == 0) {
                      e.is_bookmark = 1;
                    } else {
                      e.is_bookmark = 0;
                    }

                    setState(() {});
                    toast(error.toString());
                  });
                }
              }
            },
          ).visible(!appStore.isAdmin && !appStore.isDemoAdmin),
        ).onTap(() async {
          RecipeModel? res = kIsWeb
              ? await RecipeDetailWebScreen(recipeID: e.id, recipe: e).launch(context, pageRouteAnimation: PageRouteAnimation.Slide)
              : await RecipeDetailMobileScreen(recipeID: e.id, recipe: e).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
          if (res != null) {
            e = res;
            setState(() {});
          }
        }, highlightColor: appStore.isDarkMode ? scaffoldColorDark : context.cardColor);
      }).toList(),
    ).paddingOnly(left: 16, right: 16);
  }
}
