import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class RecipeStepOneWidget extends StatefulWidget {
  final bool? mIsUpdate;

  RecipeStepOneWidget({this.mIsUpdate});

  @override
  RecipeStepOneWidgetState createState() => RecipeStepOneWidgetState();
}

class RecipeStepOneWidgetState extends State<RecipeStepOneWidget> {
  TextEditingController recipeController = TextEditingController();

  FocusNode nameFocus = FocusNode();

  bool mIsUpdate = false;

  XFile? image;
  String? recipeImage;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    mIsUpdate = widget.mIsUpdate.validate();

    if (mIsUpdate) {
      recipeController.text = newRecipeModel!.title!;
      recipeImage = newRecipeModel!.recipe_image.validate();
    }

    setState(() {});
  }

  Future getImage() async {
    if (isWeb) {
      getImageWeb();
    } else {
      image = null;
      image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);

      if (image != null) {
        newRecipeModel!.recipeFile = File(image!.path.validate());
        setState(() {});
      }
    }
  }

  void getImageWeb() async {
    image = null;
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      Uint8List recipeImage = await image!.readAsBytes();
      newRecipeModel!.fileBytes = recipeImage;
    }
    setState(() {});
  }

  recipeImageWidget() {
    if (image != null) {
      return Column(
        children: [
          Image.network(image!.path, width: 150, height: 150).cornerRadiusWithClipRRect(16),
          8.height,
          TextButton(
            onPressed: () async {
              getImage();
            },
            child: Text(language!.changeImage),
          )
        ],
      );
    } else {
      if (mIsUpdate) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonCachedNetworkImage(recipeImage.validate(), fit: BoxFit.cover, height: 150, width: 150).cornerRadiusWithClipRRect(16),
            8.height,
            TextButton(
              onPressed: () async {
                getImage();
              },
              child: Text(language!.changeImage),
            )
          ],
        );
      } else {
        return Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              decoration: boxDecorationWithRoundedCorners(
                border: Border.all(color: primaryColor),
                backgroundColor: Color(0xFFFAF5F0),
              ),
              child: Column(
                children: [
                  Icon(Icons.camera_alt_outlined, size: 26, color: primaryColor),
                  16.height,
                  Text(
                    'Upload a photo for \n this step',
                    style: primaryTextStyle(size: 14, color: primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ).onTap(() {
                getImage();
              }),
            ),
          ],
        );
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildImageWidget() {
      if (image != null) {
        return Column(
          children: [
            Image.file(
              File(image!.path),
              height: context.height() * 0.4,
              width: context.width(),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ).cornerRadiusWithClipRRect(5),
            TextButton(
              onPressed: () {
                getImage();
              },
              child: Text(language!.changeImage, style: secondaryTextStyle()),
            )
          ],
        );
      } else {
        return addImg(
          context: context,
          image: newRecipeModel != null ? newRecipeModel!.recipe_image.validate() : '',
        ).onTap(() {
          getImage();
        });
      }
    }

    return Container(
      color: context.cardColor,
      height: context.height(),
      width: context.width(),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                createRecipeWidget(title: 'We\'re excited to see your recipe! Let\'s start with the basics...', width: context.width()),
                16.height,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language!.nameYourRecipe, style: boldTextStyle()),
                    AppTextField(
                      controller: recipeController,
                      focus: nameFocus,
                      maxLength: 55,
                      textFieldType: TextFieldType.NAME,
                      decoration: inputDecorationRecipe(hintTextName: language!.egVegetarian),
                      onChanged: (s) {
                        newRecipeModel!.title = s.trim();
                      },
                    ),
                    16.height,
                    Text(language!.addRecipePhoto, style: boldTextStyle()),
                    8.height,
                    isWeb ? recipeImageWidget() : _buildImageWidget(),
                  ],
                ).paddingOnly(left: 16, right: 16),
              ],
            ),
          ).expand(),
          AppButton(
            width: context.width(),
            color: primaryColor,
            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Text(language!.next, style: boldTextStyle(color: white)),
            onTap: () {
              hideKeyboard(context);
              if (recipeController.text.isEmpty) {
                context.requestFocus(nameFocus);
                return snackBar(context, title: language!.pleaseEnterRecipeName);
              } else if (image == null && !widget.mIsUpdate!) {
                getImage();
                return snackBar(context, title: language!.pleaseRecipeImage);
              } else {
                LiveStream().emit(streamNewRecipePageChange, 1);
              }
            },
          ).paddingAll(8),
        ],
      ),
    );
  }
}
