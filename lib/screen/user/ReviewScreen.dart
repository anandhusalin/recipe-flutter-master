import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/FixSizedBox.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeRatingModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class ReviewScreen extends StatefulWidget {
  final int? recipeId;
  final RecipeRatingModel? recipeRatingModel;
  final String? title;
  final String? img;
  final bool? mIsLastPage;

  ReviewScreen({this.recipeId, this.recipeRatingModel, this.img, this.title, this.mIsLastPage = false});

  static String tag = '/ReviewScreen';

  @override
  ReviewScreenState createState() => ReviewScreenState();
}

class ReviewScreenState extends State<ReviewScreen> {
  TextEditingController ratingController = TextEditingController();

  double? rating = 0.0;
  bool mISUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    mISUpdate = widget.recipeRatingModel != null;
    if (mISUpdate) {
      rating = widget.recipeRatingModel!.rating.toDouble() ?? 0.0;
      ratingController.text = widget.recipeRatingModel!.review!;
    }
  }

  Future<void> save() async {
    appStore.setLoading(true);
    Map req = {
      if (mISUpdate) 'id': widget.recipeRatingModel!.id,
      'recipe_id': widget.recipeId,
      'user_id': appStore.userId,
      'rating': rating,
      'review': ratingController.text.trim(),
    };

    await addRating(req).then((value) {
      toast(language!.ratingHasBeenSaveSuccessfully);
      LiveStream().emit(streamRefreshRecipeData, '');
      finish(context);
      if (widget.mIsLastPage == true) finish(context);
      appStore.setLoading(false);
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb ? null : appBarWidget(language!.review),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: FixSizedBox(
              maxWidth: kIsWeb ? null : context.width(),
              child: Column(
                children: [
                  if (kIsWeb) Text(language!.review, style: boldTextStyle(size: 24)).paddingBottom(16),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      commonCachedNetworkImage(
                        widget.img,
                        fit: BoxFit.cover,
                        height: context.height() * 0.25,
                        width: context.width(),
                      ).cornerRadiusWithClipRRect(10),
                      Container(
                        margin: EdgeInsets.all(8),
                        width: context.width(),
                        decoration: glassBoxDecoration(),
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: glassBoxDecoration(),
                              child: Text(
                                widget.title!.validate(),
                                style: boldTextStyle(color: black),
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  16.height,
                  Text(language!.recipeReview, style: boldTextStyle()),
                  8.height,
                  Divider(),
                  8.height,
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(25)),
                    child: commonCachedNetworkImage(getStringAsync(USER_PHOTO_URL), fit: BoxFit.cover, height: 50, width: 50).cornerRadiusWithClipRRect(25).center(),
                  ),
                  Text(appStore.userName.validate(), style: boldTextStyle()).paddingOnly(top: 16),
                  8.height,
                  RatingBarWidget(
                    size: 30,
                    rating: rating!,
                    onRatingChanged: (aRating) {
                      rating = aRating;
                    },
                  ),
                  16.height,
                  AppTextField(
                    controller: ratingController,
                    textFieldType: TextFieldType.ADDRESS,
                    decoration: inputDecorationRecipe(hintTextName: 'Write here...').copyWith(
                      contentPadding: EdgeInsets.all(8),
                      fillColor: context.cardColor,
                      filled: true,
                    ),
                    maxLines: 4,
                    minLines: 4,
                  ),
                  16.height,
                  AppButton(
                    text: language!.submitReview,
                    textStyle: boldTextStyle(color: white),
                    width: context.width(),
                    color: primaryColor,
                    onTap: () {
                      if (appStore.isDemoAdmin) {
                        snackBar(context, title: language!.demoUserMsg);
                      } else {
                        if (ratingController.text.isEmpty) {
                          return snackBar(context, title: language!.pleaseSubmitYourReview);
                        } else {
                          save();
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          Observer(builder: (_) => Loader().visible(appStore.isLoader)),
        ],
      ),
    );
  }
}
