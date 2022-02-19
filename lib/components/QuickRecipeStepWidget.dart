import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeStepModel.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Widgets.dart';

class QuickRecipeStepWidget extends StatefulWidget {
  final List<RecipeStepModel>? recipeStepData;

  QuickRecipeStepWidget({this.recipeStepData});

  @override
  QuickRecipeStepWidgetState createState() => QuickRecipeStepWidgetState();
}

class QuickRecipeStepWidgetState extends State<QuickRecipeStepWidget> {
  PageController controller = PageController();

  final flutterTts = FlutterTts();

  FocusNode focus = FocusNode();

  int currentIndex = 0;
  bool mIsSpeaking = false;
  bool mIsRotation = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setOrientationLandscape();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    initializeTts();

    controller.addListener(() {
      currentIndex = controller.page.validate().toInt();

      setState(() {});
    });
  }

  void initializeTts() {
    flutterTts.setStartHandler(() {
      mIsSpeaking = true;
      setState(() {});
    });
    flutterTts.setCompletionHandler(() {
      mIsSpeaking = false;

      if ((currentIndex + 1) != widget.recipeStepData!.length) {
        controller.nextPage(duration: 500.milliseconds, curve: Curves.linear);
        1.seconds.delay.then((value) {
          flutterTts.speak(widget.recipeStepData![currentIndex].description.validate());
        });
      }
      setState(() {});
    });
    flutterTts.setErrorHandler((message) {
      mIsSpeaking = false;
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    appStore.isDarkMode ? '' : setStatusBarColor(Colors.transparent, systemNavigationBarColor: white);
    flutterTts.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          AnimatedPadding(
            padding: !mIsRotation ? EdgeInsets.fromLTRB(8, context.statusBarHeight, 50, 0) : EdgeInsets.fromLTRB(8, 16, 16, 0),
            duration: Duration(milliseconds: 500),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DotIndicator(
                  indicatorColor: primaryColor,
                  unselectedIndicatorColor: appStore.isDarkMode ? white : Colors.black12,
                  pageController: controller,
                  pages: widget.recipeStepData!,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(0),
                  width: context.width(),
                  child: Text('${currentIndex + 1}/${widget.recipeStepData!.length.toString()}', style: boldTextStyle(size: 25, color: primaryColor)),
                ).expand(),
                //StopWatchTimerWidget(),
                Container(
                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)),
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(mIsSpeaking ? language!.stop : language!.speak),
                      IconButton(
                        onPressed: () {
                          if (mIsSpeaking) {
                            mIsSpeaking = false;
                            flutterTts.stop();
                            setState(() {});
                          } else {
                            mIsSpeaking = true;
                            flutterTts.speak(widget.recipeStepData![currentIndex].description.validate());
                            setState(() {});
                          }
                        },
                        icon: Icon(mIsSpeaking ? Icons.voice_over_off_outlined : Icons.record_voice_over_outlined, color: context.iconColor),
                      ),
                    ],
                  ),
                ).onTap(() {
                  if (mIsSpeaking) {
                    mIsSpeaking = false;
                    flutterTts.stop();
                    setState(() {});
                  } else {
                    mIsSpeaking = true;
                    flutterTts.speak(widget.recipeStepData![currentIndex].description.validate());
                    setState(() {});
                  }
                }),
              ],
            ),
          ),
          16.height,
          PageView.builder(
            controller: controller,
            itemCount: widget.recipeStepData!.length,
            onPageChanged: (index) {
              if (mIsSpeaking) {
                mIsSpeaking = false;
                flutterTts.stop();
                setState(() {});
              }
            },
            itemBuilder: (BuildContext context, int itemIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          widget.recipeStepData![itemIndex].description.validate(),
                          style: boldTextStyle(size: 22),
                          minFontSize: 8,
                          maxFontSize: 40,
                        ).expand(),
                        8.width,
                        commonCachedNetworkImage(
                          widget.recipeStepData![itemIndex].recipe_step_image.validate(),
                          width: context.width(),
                          fit: BoxFit.cover,
                          height: 180,
                        ).cornerRadiusWithClipRRect(10).expand(),
                      ],
                    ).expand()
                  ],
                ).onTap(() {
                  if (mIsRotation) {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                    mIsRotation = false;
                    setState(() {});
                  } else {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
                    mIsRotation = true;
                    setState(() {});
                  }
                }, highlightColor: context.cardColor),
              );
            },
          ).expand(),
        ],
      ),
    );
  }
}
