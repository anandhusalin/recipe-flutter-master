import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/FixSizedBox.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode bioFocus = FocusNode();
  FocusNode dateFocus = FocusNode();

  XFile? image;
  Uint8List? profileImg;

  late DateTime userDateOfBirth;

  int groupValue = 0;

  List name = ['Male', 'Female'];
  String? gender;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    nameController.text = getStringAsync(NAME).validate();
    userNameController.text = appStore.userName.validate();
    emailNameController.text = appStore.userEmail.validate();
    bioController.text = getStringAsync(BIO).validate();
    userDateOfBirth = DateTime.now();
    dateController.text = getStringAsync(DOB).validate();
    gender = getStringAsync(GENDER).isNotEmpty ? getStringAsync(GENDER).validate() : '';
  }

  Future getImage() async {
    if (isWeb) {
      getImageWeb();
    } else {
      image = null;
      image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);

      setState(() {});
    }
  }

  Widget profileImage() {
    image = null;
    if (image != null) {
      return Image.file(File(image!.path), height: 100, width: 100, fit: BoxFit.cover, alignment: Alignment.center).cornerRadiusWithClipRRect(100).center();
    } else {
      return commonCachedNetworkImage(getStringAsync(USER_PHOTO_URL), fit: BoxFit.cover, height: 100, width: 100).cornerRadiusWithClipRRect(100).center();
    }
  }

  void getImageWeb() async {
    image = null;
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImg = await image!.readAsBytes();
    }
    setState(() {});
  }

  recipeImageWidget() {
    if (image != null) {
      return Column(
        children: [
          Image.network(image!.path, width: 100, height: 100, fit: BoxFit.cover, alignment: Alignment.center).cornerRadiusWithClipRRect(50).center(),
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
      return commonCachedNetworkImage(getStringAsync(USER_PHOTO_URL), fit: BoxFit.cover, height: 100, width: 100).cornerRadiusWithClipRRect(100).center();;
    }
  }

  pickDate() async {
    DateTime? time = await showDatePicker(
        context: context,
        initialDate: userDateOfBirth,
        firstDate: DateTime(DateTime
            .now()
            .year - 5),
        lastDate: DateTime(DateTime
            .now()
            .year + 5)
        builder: (BuildContext context, Widget ? child)
    {
      return Theme(data: appStore.isDarkMode ? ThemeData.dark() : ThemeData.light(), child: child!)
    });
    if (time != null) {
    setState(() {
    userDateOfBirth = time;
    dateController.text = DateFormat('yyyy-MM-dd').format(userDateOfBirth);
    });
    }
  }

  submit() async {
    await updateProfile(
      fileWeb: profileImg,
      file: File(image!.path.validate()),
      name: nameController.text.trim().validate(),
      userName: userNameController.text.trim().validate(),
      userEmail: emailNameController.text.trim().validate(),
      bio: bioController.text.trim().validate(),
      dob: dateController.text.trim().validate(),
      gender: gender.validate(),
    ).then((value) {
      toast(language!.profileUpdateSuccessfully);
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
    finish(context);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb ? null : appBarWidget(language!.editProfile, elevation: 0),
      body: FixSizedBox(
        maxWidth: kIsWeb ? null : context.width(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(kIsWeb)
                ...[Text(language!.editProfile, style: boldTextStyle(size: 24)).paddingBottom(16), Divider(), 16.height],
              Stack(
                children: [
                  isWeb ? recipeImageWidget() : profileImage(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 50, left: 80),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: grey.withOpacity(0.3)),
                      child: IconButton(
                        onPressed: () {
                          getImage();
                        },
                        icon: Icon(Icons.edit, color: context.iconColor),
                      ),
                    ).visible(!getBoolAsync(IS_SOCIAL_LOGIN)),
                  )
                ],
              ),
              16.height,
              AppTextField(
                controller: userNameController,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecorationRecipe(hintTextName: language!.userName, labelTextName: language!.userName),
              ),
              16.height,
              AppTextField(
                controller: nameController,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecorationRecipe(hintTextName: language!.name, labelTextName: language!.name),
              ),
              16.height,
              AppTextField(
                controller: emailNameController,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecorationRecipe(hintTextName: language!.email, labelTextName: language!.email),
              ),
              16.height,
              AppTextField(
                controller: bioController,
                minLines: 3,
                maxLines: 3,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecorationRecipe(hintTextName: language!.bio, labelTextName: language!.bio).copyWith(
                  alignLabelWithHint: true,
                ),
              ),
              16.height,
              AppTextField(
                readOnly: true,
                controller: dateController,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecorationRecipe(hintTextName: language!.dateOfBirth, labelTextName: language!.dateOfBirth),
                onTap: () {
                  pickDate();
                },
              ),
              16.height,
              Text(language!.gender, style: primaryTextStyle()),
              Column(
                  children: name.map((e) {
                    return ListTile(
                      title: Text(e, style: primaryTextStyle()),
                      leading: Radio<String>(
                        onChanged: (String? val) {
                          gender = val!;
                          setState(() {});
                        },
                        value: name[name.indexOf(e)],
                        groupValue: gender,
                      ),
                    );
                  }).toList()),
              16.height,
              AppButton(
                text: language!.save,
                textStyle: boldTextStyle(color: white),
                onTap: () {
                  if (appStore.isDemoAdmin) {
                    snackBar(context, title: language!.demoUserMsg);
                  } else {
                    if (image != null) {
                      submit();
                    } else {
                      snackBar(context, title: language!.pleaseSelectYourProfileImage);
                    }
                  }
                },
                width: context.width(),
                color: primaryColor,
              ).visible(!getBoolAsync(IS_SOCIAL_LOGIN)),
            ],
          ),
        ),
      ),
    );
  }
}
