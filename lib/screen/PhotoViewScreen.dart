import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatefulWidget {
  final String? img;

  PhotoViewScreen({this.img});

  @override
  PhotoViewScreenState createState() => PhotoViewScreenState();
}

class PhotoViewScreenState extends State<PhotoViewScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(black);
  }

  @override
  void dispose() {
    setStatusBarColor(Colors.transparent, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(
        children: [
          Container(
            width: context.width(),
            child: PhotoView(
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 30.0,
                  height: 30.0,
                  child: CircularProgressIndicator(
                    backgroundColor: black,
                    value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                  ),
                ),
              ),
              maxScale: PhotoViewComputedScale.contained,
              minScale: PhotoViewComputedScale.contained,
              imageProvider: NetworkImage(widget.img!),
            ),
          ),
          SafeArea(child: BackButton(color: white)),
        ],
      ),
    );
  }
}
