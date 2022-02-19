import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/EmptyWidget.dart';
import 'package:recipe_app/components/FixSizedBox.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeDetailModel.dart';
import 'package:recipe_app/models/RecipeRatingModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/auth/SignInScreen.dart';
import 'package:recipe_app/screen/user/ReviewScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Widgets.dart';

class RecipeCommentScreen extends StatefulWidget {
  final List<RecipeRatingModel>? ratingData;
  final RecipeDetailModel? recipeDetail;

  RecipeCommentScreen({this.ratingData, this.recipeDetail});

  @override
  RecipeCommentScreenState createState() => RecipeCommentScreenState();
}

class RecipeCommentScreenState extends State<RecipeCommentScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void addComment() async {
    if (appStore.isLoggedIn) {
      await ReviewScreen(
        recipeId: widget.recipeDetail!.recipes!.id,
        recipeRatingModel: widget.recipeDetail!.user_rating,
        img: widget.recipeDetail!.recipes!.recipe_image,
        title: widget.recipeDetail!.recipes!.title,
        mIsLastPage: true,
      ).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
    } else {
      SignInScreen().launch(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb ? null : appBarWidget(language!.comments, elevation: 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: FixSizedBox(
          maxWidth: kIsWeb ? null : context.width(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (kIsWeb) ...[
                Row(
                  children: [
                    Text(language!.comments, style: boldTextStyle(size: 24)).expand(),
                    IconButton(
                        onPressed: () {
                          addComment();
                        },
                        icon: Icon(Icons.add)),
                  ],
                ),
                Divider(),
              ],
              widget.ratingData!.isNotEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: widget.ratingData!.map((e) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(border: Border.all(color: appStore.isDarkMode ? scaffoldSecondaryDark : Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              e.profile_image!.isNotEmpty
                                  ? commonCachedNetworkImage(e.profile_image, fit: BoxFit.cover, height: 35, width: 35).cornerRadiusWithClipRRect(5)
                                  : Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: boxDecorationRoundedWithShadow(10, backgroundColor: goldenRod),
                                      height: 50,
                                      width: 50,
                                      child: Text(e.username!.substring(0, 1).toUpperCase(), style: boldTextStyle(color: white), textAlign: TextAlign.center),
                                    ),
                              8.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(e.username!, style: boldTextStyle(size: 14)).expand(),
                                      RatingBarWidget(
                                        onRatingChanged: (v) {
                                          //
                                        },
                                        size: 15,
                                        rating: e.rating.toDouble(),
                                        disable: true,
                                        activeColor: primaryColor,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(e.review!, style: primaryTextStyle()).expand(),
                                      Icon(Icons.delete, color: context.iconColor).onTap(() async {
                                        await showConfirmDialogCustom(
                                          context,
                                          title: language!.doYouDeleteYourRating,
                                          primaryColor: primaryColor,
                                          positiveText: language!.delete,
                                          negativeText: language!.cancel,
                                          onAccept: (c) {
                                            Map req = {
                                              'id': e.id,
                                            };
                                            deleteRating(req).then((value) {
                                              snackBar(context, title: language!.ratingDeletedSuccessfully);
                                              finish(context);
                                            }).catchError((error) {
                                              log(error);
                                            });
                                          },
                                          dialogType: DialogType.DELETE,
                                        );
                                      }).visible(e.user_id == appStore.userId),
                                    ],
                                  ),
                                ],
                              ).expand()
                            ],
                          ),
                        ).onTap(() async {
                          if (appStore.isLoggedIn) {
                            if (e.user_id == appStore.userId) {
                              await ReviewScreen(
                                recipeId: widget.recipeDetail!.recipes!.id,
                                recipeRatingModel: widget.recipeDetail!.user_rating,
                                img: widget.recipeDetail!.recipes!.recipe_image,
                                title: widget.recipeDetail!.recipes!.title,
                                mIsLastPage: true,
                              ).launch(
                                context,
                                pageRouteAnimation: PageRouteAnimation.SlideBottomTop,
                              );
                            }
                          } else {
                            SignInScreen().launch(context);
                          }
                        }, highlightColor: Colors.transparent, hoverColor: Colors.transparent, splashColor: Colors.transparent);
                      }).toList(),
                    )
                  : Container(height: context.height() * 0.7, child: EmptyWidget(title: language!.noComments)),
            ],
          ),
        ),
      ),
      floatingActionButton: kIsWeb
          ? null
          : FloatingActionButton(
              backgroundColor: context.cardColor,
              child: Icon(Icons.add, color: context.iconColor),
              onPressed: () async {
                addComment();
              },
            ),
    );
  }
}
