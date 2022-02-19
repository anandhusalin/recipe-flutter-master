import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/MyRecipeWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';

class RecipeTabBarWidgetDraft extends StatefulWidget {
  final int spanCount;

  RecipeTabBarWidgetDraft({this.spanCount = 2});

  @override
  RecipeTabBarWidgetDraftState createState() => RecipeTabBarWidgetDraftState();
}

class RecipeTabBarWidgetDraftState extends State<RecipeTabBarWidgetDraft> with AutomaticKeepAliveClientMixin<RecipeTabBarWidgetDraft> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    LiveStream().on(streamRefreshRecipeData, (v) {
      setState(() {});
    });
    LiveStream().on(streamRefreshRecipe, (v) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    LiveStream().dispose(streamRefreshRecipeData);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        MyRecipeWidget(
          spanCount: widget.spanCount,
          popMenuList: [
            PopupMenuItem(child: Text(language!.publish, style: primaryTextStyle()), value: 1),
            PopupMenuItem(child: Text(language!.delete, style: primaryTextStyle()), value: 2),
          ],
          status: 0,
          onTap: (val, data) async {
            if (val == 1) {
              newRecipeModel = data;
              newRecipeModel!.status = 1;
              appStore.setLoading(true);
              await addUpdateRecipeData(status: newRecipeModel!.status = 1, id: data.id).then((value) {
                LiveStream().emit(streamRefreshRecipe);
                snackBar(context, title: language!.publishSuccessfully);
                setState(() {});
              }).then((value) {
                appStore.setLoading(false);
              }).catchError((error){
                log(error);
                appStore.setLoading(false);
              });

            } else if (val == 2) {
              Map req = {
                'id': data.id,
              };
              await showConfirmDialogCustom(context, primaryColor: primaryColor, title: language!.deleteThisRecipe, onAccept: (c) {
                appStore.setLoading(true);
                deleteRecipe(req).then((value) {
                  LiveStream().emit(streamRefreshRecipe);

                  snackBar(context, title: language!.deletedRecipeSuccessfully);
                  appStore.setLoading(false);
                }).catchError((error) {
                  log(error);
                  appStore.setLoading(false);
                });

              });
            }
          },
        ),
        Loader().visible(appStore.isLoader)
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
