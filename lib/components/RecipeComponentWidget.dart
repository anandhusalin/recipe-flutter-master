import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/models/RecipeModel.dart';
import 'package:recipe_app/utils/Common.dart';

import '../main.dart';

class RecipeComponentWidget extends StatefulWidget {
  final RecipeModel? recipeModel;
  final Widget? widgetData;
  final int spanCount;

  RecipeComponentWidget({this.recipeModel, this.widgetData, this.spanCount = 2});

  @override
  RecipeComponentWidgetState createState() => RecipeComponentWidgetState();
}

class RecipeComponentWidgetState extends State<RecipeComponentWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width() / widget.spanCount - 24,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          widget.recipeModel!.recipeImageWidget(),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: gradientDecoration()),
            padding: EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: glassBoxDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.recipeModel!.title.validate(),
                            style: boldTextStyle(color: black, size: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ).expand(flex: 4),
                           widget.widgetData.expand(),
                        ],
                      ),
                      8.height,
                      Row(
                        children: [
                          Text('${stringToMin(widget.recipeModel!.preparationTime.validate())} min', style: secondaryTextStyle(color: black)).fit(),
                          4.width,
                          Container(width: 1, height: 15, color: Colors.grey),
                          4.width,
                          Text(
                            '${widget.recipeModel!.portionUnit.toString().validate()} ${widget.recipeModel!.portionType.validate()}',
                            style: secondaryTextStyle(color: black),
                          ).fit(),
                        ],
                      ).fit(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
