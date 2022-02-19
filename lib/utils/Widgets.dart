import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:recipe_app/components/ScaleImageWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/utils/Colors.dart';

InputDecoration buildInputDecoration(String name, {Widget? prefixIcon}) {
  return InputDecoration(
      hintText: name,
      hintStyle: primaryTextStyle(size: 18),
      isDense: true,
      counterText: "",
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      filled: true,
      fillColor: appStore.isDarkMode ? appButtonColorDark : Colors.white,
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(borderRadius: new BorderRadius.circular(10.0), borderSide: BorderSide.none));
}

Widget commonCachedNetworkImage(
  String? url, {
  double? height,
  double? width,
  BoxFit? fit,
  AlignmentGeometry? alignment,
  bool usePlaceholderIfUrlEmpty = true,
  double? radius,
  bool? isScaled = true,
}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return kIsWeb
        ? ScaleImageWidget(
            height: height,
            width: width,
            isScaleImage: isScaled,
            child: CachedNetworkImage(
              imageUrl: url!,
              fit: fit,
              alignment: alignment as Alignment? ?? Alignment.center,
              errorWidget: (_, s, d) {
                return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
              },
              placeholder: (_, s) {
                if (!usePlaceholderIfUrlEmpty) return SizedBox();
                return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
              },
            ),
          )
        : CachedNetworkImage(
            imageUrl: url!,
            fit: fit,
            height: height,
            width: width,
            alignment: alignment as Alignment? ?? Alignment.center,
            errorWidget: (_, s, d) {
              return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
            },
            placeholder: (_, s) {
              if (!usePlaceholderIfUrlEmpty) return SizedBox();
              return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
            },
          );
  } else {
    return Image.asset(url!, height: height, width: width, fit: fit, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Image.asset('images/placeholder.jpg', height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

InputDecoration inputDecorationRecipe({String? labelTextName, String? hintTextName}) {
  return InputDecoration(
    contentPadding: EdgeInsets.zero,
    labelText: labelTextName,
    hintText: hintTextName,
    labelStyle: secondaryTextStyle(),
    hintStyle: secondaryTextStyle(),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: viewLineColor),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: viewLineColor),
    ),
  );
}

Widget createRecipeTime({String? title, String? subTitle, String? time, Function()? onTap, required BuildContext context}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title!, style: boldTextStyle()),
          8.height,
          Text(subTitle!, style: secondaryTextStyle()),
        ],
      ).expand(),
      32.width,
      InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(border: Border.all(color: primaryColor), borderRadius: BorderRadius.circular(10), color: context.cardColor),
          child: Text(time!, style: primaryTextStyle()),
        ),
      )
    ],
  ).paddingOnly(top: 16, left: 16, right: 16);
}

Widget createRecipeWidget({String? title, double? width}) {
  return Container(
    width: width,
    color: Colors.amberAccent.withOpacity(0.3),
    padding: EdgeInsets.all(16),
    child: Text(title.validate(), style: primaryTextStyle()),
  );
}

Route createRoute({Widget? widget}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget!,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Widget addStepWidget({String? title, required BuildContext context}) {
  return Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(border: Border.all(color: primaryColor), borderRadius: BorderRadius.circular(5)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add, color: context.iconColor),
        8.width,
        Text(title!, style: primaryTextStyle()),
      ],
    ),
  );
}

Widget cookingTimeWidget({required BuildContext context, double? percentage, Color? color, String? title, String? subtitle, double? spanCount}) {
  if (title.validate().toInt() == 0) return SizedBox();

  return Column(
    children: [
      Container(
        width: spanCount,
        decoration: BoxDecoration(
          color: context.cardColor,
          border: Border.all(color: appStore.isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300),
          borderRadius: radius(),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.access_time_rounded, color: context.primaryColor),
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${title.validate()}', style: boldTextStyle()),
                Text(' min', style: boldTextStyle(size: 14)),
              ],
            ).fit(),
          ],
        ),
      ),
      20.height,
      Text(subtitle.validate(), style: primaryTextStyle()),
    ],
  );

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CircularPercentIndicator(
        animation: true,
        radius: 75.0,
        lineWidth: 2.0,
        percent: 1.0,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer, size: 14),
            4.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title!, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                4.width,
                Text('min', style: secondaryTextStyle()),
              ],
            ),
          ],
        ),
        progressColor: color,
      ),
      16.height,
      Text(subtitle!, style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center)
    ],
  );
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

Widget addImg({BuildContext? context, String? image, Function(File)? onFileSelected}) {
  return Container(
    height: context!.height() * 0.4,
    width: context.width(),
    decoration: BoxDecoration(border: Border.all(color: primaryColor), borderRadius: BorderRadius.circular(5), color: containerColor.withOpacity(0.3)),
    child: image.validate().isNotEmpty
        ? commonCachedNetworkImage(image, fit: BoxFit.cover, width: context.width())
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_outlined, size: 30, color: primaryColor),
              16.width,
              Text('Upload a final of\nyour dish now', style: primaryTextStyle(color: primaryColor)),
            ],
          ),
  );
}
