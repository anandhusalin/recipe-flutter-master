import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/BaseResponseModel.dart';
import 'package:recipe_app/models/DishTypModel.dart';
import 'package:recipe_app/models/ForgotPasswordResponseModel.dart';
import 'package:recipe_app/models/LikeResponseModel.dart';
import 'package:recipe_app/models/LoginResponse.dart';
import 'package:recipe_app/models/RecipeBookMarkModel.dart';
import 'package:recipe_app/models/RecipeBookMarkResponse.dart';
import 'package:recipe_app/models/RecipeDashboardModel.dart';
import 'package:recipe_app/models/RecipeDetailModel.dart';
import 'package:recipe_app/models/RecipeIngredientsListModel.dart';
import 'package:recipe_app/models/RecipeIngredientsModel.dart';
import 'package:recipe_app/models/RecipeListModel.dart';
import 'package:recipe_app/models/RecipeModel.dart';
import 'package:recipe_app/models/RecipeRatingModel.dart';
import 'package:recipe_app/models/RecipeSliderModel.dart';
import 'package:recipe_app/models/RecipeStaticModel.dart';
import 'package:recipe_app/models/RecipeStepModel.dart';
import 'package:recipe_app/models/RecipeStepModelList.dart';
import 'package:recipe_app/network/NetworkUtils.dart';
import 'package:recipe_app/screen/DashboardScreen.dart';
import 'package:recipe_app/screen/DashboardWebScreen.dart';
import 'package:recipe_app/utils/Constants.dart';

//region Auth
Future<LoginResponse> signUpApi(Map request) async {
  Response response = await buildHttpResponse('register', request: request, method: HttpMethod.POST);

  if (!response.statusCode.isSuccessful()) {
    if (response.body.isJson()) {
      var json = jsonDecode(response.body);

      if (json.containsKey('code') && json['code'].toString().contains('invalid_username')) {
        throw 'invalid_username';
      }
    }
  }

  return await handleResponse(response).then((json) async {
    var loginResponse = LoginResponse.fromJson(json);

    await setValue(GENDER, loginResponse.userData!.gender.validate());
    await setValue(NAME, loginResponse.userData!.name.validate());
    await setValue(USER_ROLE_PREF, loginResponse.userData!.user_type.validate());
    await setValue(BIO, loginResponse.userData!.bio.validate());

    await appStore.setUserName(loginResponse.userData!.username.validate());
    await appStore.setRole(loginResponse.userData!.user_type.validate());
    await appStore.setToken(loginResponse.userData!.api_token.validate());
    await appStore.setUserID(loginResponse.userData!.id.validate());
    await appStore.setUserEmail(loginResponse.userData!.email.validate());
    await appStore.setLogin(true);

    await setValue(USER_PASSWORD, request['password']);

    return loginResponse;
  }).catchError((e) {
    log(e.toString());
    throw e.toString();
  });
}

Future<LoginResponse> logInApi(Map request, {bool isSocialLogin = false}) async {
  Response response = await buildHttpResponse(isSocialLogin ? 'social-login' : 'login', request: request, method: HttpMethod.POST);

  if (!response.statusCode.isSuccessful()) {
    if (response.body.isJson()) {
      var json = jsonDecode(response.body);

      if (json.containsKey('code') && json['code'].toString().contains('invalid_username')) {
        throw 'invalid_username';
      }
    }
  }

  return await handleResponse(response).then((json) async {
    var loginResponse = LoginResponse.fromJson(json);

    if (request['login_type'] == LoginTypeGoogle) {
      await setValue(USER_PHOTO_URL, request['image']);
    } else {
      await setValue(USER_PHOTO_URL, loginResponse.userData!.profile_image.validate());
    }

    await setValue(GENDER, loginResponse.userData!.gender.validate());
    await setValue(NAME, loginResponse.userData!.name.validate());
    await setValue(BIO, loginResponse.userData!.bio.validate());
    await setValue(DOB, loginResponse.userData!.dob.validate());

    await appStore.setUserName(loginResponse.userData!.username.validate());
    await appStore.setRole(loginResponse.userData!.user_type.validate());
    await appStore.setToken(loginResponse.userData!.api_token.validate());
    await appStore.setUserID(loginResponse.userData!.id.validate());
    await appStore.setUserEmail(loginResponse.userData!.email.validate());
    await appStore.setLogin(true);

    if (!isSocialLogin) await setValue(USER_PASSWORD, request['password']);
    await setValue(IS_SOCIAL_LOGIN, isSocialLogin.validate());

    LiveStream().emit(streamRefreshBookMark);

    return loginResponse;
  }).catchError((e) {
    throw e.toString();
  });
}

Future<void> logout(BuildContext context) async {
  await removeKey(USER_NAME);
  await removeKey(IS_LOGGED_IN);
  await removeKey(USER_ID);
  await removeKey(USER_EMAIL);
  await removeKey(API_TOKEN);
  await removeKey(USER_ROLE_PREF);
  await removeKey(USER_PHOTO_URL);
  await removeKey(GENDER);
  await removeKey(NAME);
  await removeKey(BIO);

  await appStore.setLogin(false);
  await appStore.setRole('');
  if (isWeb) {
    DashboardWebScreen().launch(context, isNewTask: true);
  } else {
    DashboardScreen().launch(context, isNewTask: true);
  }
}

Future<ChangePasswordResponseModel> changePassword(Map req) async {
  return ChangePasswordResponseModel.fromJson(await handleResponse(await buildHttpResponse('change-password', request: req, method: HttpMethod.POST)));
}

Future<ChangePasswordResponseModel> forgotPassword(Map req) async {
  return ChangePasswordResponseModel.fromJson(await handleResponse(await buildHttpResponse('forgot-password', request: req, method: HttpMethod.POST)));
}
//endregion

Future<DishTypModel> getDishTypeList({int? page}) async {
  return DishTypModel.fromJson(await handleResponse(await buildHttpResponse('category-list?page=$page', method: HttpMethod.GET)));
}

Future<RecipeStaticModel> getCousinList({String? type}) async {
  return RecipeStaticModel.fromJson(await handleResponse(await buildHttpResponse('category-list?type=$type', method: HttpMethod.GET)));
}

Future<BaseResponseModel> addIngredients(Map req) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-recipe-ingredients', request: req, method: HttpMethod.POST)));
}

Future<RecipeStepModel> addRecipeStep(Map req) async {
  return RecipeStepModel.fromJson(await handleResponse(await buildHttpResponse('save-recipe-steps', request: req, method: HttpMethod.POST)));
}

Future<RecipeIngredientsListModel> getIngredients({int? recipeId, int? page}) async {
  return RecipeIngredientsListModel.fromJson(await handleResponse(await buildHttpResponse('recipe-Ingredients-list?recipe_id=$recipeId&page=$page', method: HttpMethod.GET)));
}

Future<RecipeStaticModel> addCuisineData({int? page, String? type, String? keyword}) async {
  return RecipeStaticModel.fromJson(await handleResponse(await buildHttpResponse('static-data-list?type=$type&keyword=$keyword&page=$page', method: HttpMethod.GET)));
}

Future<BaseResponseModel> addUtensilData(Map req) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-utensils', request: req, method: HttpMethod.POST)));
}

Future<RecipeDashboardModel> getRecipeData() async {
  String userId = appStore.isLoggedIn ? 'user_id=${appStore.userId}' : '';
  return RecipeDashboardModel.fromJson(await handleResponse(await buildHttpResponse('dashboard-detail?$userId&status=1', method: HttpMethod.GET)));
}

Future<RecipeDetailModel> getRecipeDetailData({int? recipeID}) async {
  String userId = appStore.isLoggedIn ? '&user_id=${appStore.userId}' : '';
  return RecipeDetailModel.fromJson(await handleResponse(await buildHttpResponse('recipe-detail?recipe_id=$recipeID$userId', method: HttpMethod.GET)));
}

Future<RecipeListModel> getRecipeListData({int? status, int? page}) async {
  String userId = appStore.isLoggedIn ? '&user_id=${appStore.userId}' : '';
  return RecipeListModel.fromJson(await handleResponse(await buildHttpResponse('recipe-list?$userId&status=$status&page=$page', method: HttpMethod.GET)));
}

Future<RecipeRatingModel> addRating(Map req) async {
  return RecipeRatingModel.fromJson(await handleResponse(await buildHttpResponse('save-rating', request: req, method: HttpMethod.POST)));
}

Future<RecipeRatingModel> deleteRating(Map req) async {
  return RecipeRatingModel.fromJson(await handleResponse(await buildHttpResponse('delete-rating', request: req, method: HttpMethod.POST)));
}

Future<LikeResponseModel> addLike(Map req) async {
  return LikeResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-like', request: req, method: HttpMethod.POST)));
}

Future<LikeResponseModel> removeLike(Map req) async {
  return LikeResponseModel.fromJson(await handleResponse(await buildHttpResponse('delete-like', request: req, method: HttpMethod.POST)));
}

Future<RecipeBookMarkResponse> addBookMark(Map req) async {
  return RecipeBookMarkResponse.fromJson(await handleResponse(await buildHttpResponse('save-bookmark', request: req, method: HttpMethod.POST)));
}

Future<RecipeBookMarkResponse> removeBookMark(Map req) async {
  return RecipeBookMarkResponse.fromJson(await handleResponse(await buildHttpResponse('delete-bookmark', request: req, method: HttpMethod.POST)));
}

Future<RecipeModel> deleteRecipe(req) async {
  return RecipeModel.fromJson(await handleResponse(await buildHttpResponse('delete-recipe', request: req, method: HttpMethod.POST)));
}

Future<RecipeBookMarkModel> getBookMarkData({int? perPage, int? page}) async {
  return RecipeBookMarkModel.fromJson(await handleResponse(await buildHttpResponse('get-user-bookmark?user_id=${appStore.userId}&page=$page', method: HttpMethod.GET)));
}

Future<RecipeStepModelList> getRecipeStepModel({int? page, int? recipeID}) async {
  return RecipeStepModelList.fromJson(await handleResponse(await buildHttpResponse('recipe-steps-list?recipe_id=$recipeID&page=$page', method: HttpMethod.GET)));
}

Future<RecipeIngredientsModel> deleteIngredients(req) async {
  return RecipeIngredientsModel.fromJson(await handleResponse(await buildHttpResponse('delete-recipe-ingredients', request: req, method: HttpMethod.POST)));
}

Future<RecipeStepModel> deleteStep(req) async {
  return RecipeStepModel.fromJson(await handleResponse(await buildHttpResponse('delete-recipe-steps', request: req, method: HttpMethod.POST)));
}

Future<RecipeListModel> recipeSearchData({int? page, String? keyword}) async {
  return RecipeListModel.fromJson(await handleResponse(await buildHttpResponse('recipe-list?page=$page&keyword=$keyword&status=1', method: HttpMethod.GET)));
}

Future<void> addDishTypeList(Map req) async {
  await handleResponse(await buildHttpResponse('save-category', request: req, method: HttpMethod.POST));
}

Future<void> deleteDishTypeList(Map req) async {
  return await handleResponse(await buildHttpResponse('delete-category', request: req, method: HttpMethod.POST));
}

Future<void> addCuisine(Map req) async {
  return await handleResponse(await buildHttpResponse('save-static-data', request: req, method: HttpMethod.POST));
}

Future<void> deleteCuisine(Map req) async {
  return await handleResponse(await buildHttpResponse('delete-static-data', request: req, method: HttpMethod.POST));
}

Future<MultipartRequest> getMultiPartRequest(String endPoint, {String? baseUrl}) async {
  String url = '${baseUrl ?? buildBaseUrl(endPoint).toString()}';
  log(url);
  return MultipartRequest('POST', Uri.parse(url));
}

Future<RecipeSliderModel> getSliderData({int? page}) async {
  return RecipeSliderModel.fromJson(await handleResponse(await buildHttpResponse('slider-list?page=$page', method: HttpMethod.GET)));
}

Future<RecipeSliderModel> removeSliderData(Map req) async {
  return RecipeSliderModel.fromJson(await handleResponse(await buildHttpResponse('delete-slider', request: req, method: HttpMethod.POST)));
}

Future sendMultiPartRequest(MultipartRequest multiPartRequest, {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  multiPartRequest.headers.addAll(buildHeaderTokens());

  await multiPartRequest.send().then((res) {
    log(res.statusCode);
    res.stream.transform(utf8.decoder).listen((value) {
      log(value);
      onSuccess?.call(jsonDecode(value));
    });
  }).catchError((error) {
    onError?.call(error.toString());
  });
}

/// Add Recipe Step Data
Future<int> addStepData({String? description, String? ingredientUseId, File? file, int? recipeId, int? id, Uint8List? recipeStepWeb}) async {
  int? stepId;
  MultipartRequest multiPartRequest = await getMultiPartRequest('save-recipe-steps');

  multiPartRequest.fields['recipe_id'] = recipeId.toString();
  multiPartRequest.fields['description'] = description.validate();
  multiPartRequest.fields['ingredient_used_id'] = ingredientUseId.validate();
  if (id != -1) {
    multiPartRequest.fields['id'] = id.toString();
  }
  if (isWeb) {
    if (recipeStepWeb != null) {
      multiPartRequest.files.add(MultipartFile.fromBytes('recipe_step_image', recipeStepWeb, filename: '.jpg'));
    }
  } else {
    if (file != null) {
      multiPartRequest.files.add(await MultipartFile.fromPath('recipe_step_image', file.path));
    }
  }

  await sendMultiPartRequest(
    multiPartRequest,
    onSuccess: (data) async {
      stepId = data["step_id"];
    },
    onError: (error) {
      toast(error.toString(), print: true);
    },
  );

  await Future.delayed(Duration.zero);

  return stepId.validate();
}

/// Add Recipe Data
Future<int> addUpdateRecipeData({int? id, File? file, int? status}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('save-recipe');

  if (newRecipeModel != null) {
    multiPartRequest.fields['title'] = newRecipeModel!.title.validate();
    multiPartRequest.fields['portion_unit'] = newRecipeModel!.portionUnit.validate().toString();
    multiPartRequest.fields['portion_type'] = newRecipeModel!.portionType.validate().toString();
    multiPartRequest.fields['difficulty'] = newRecipeModel!.difficulty.validate();
    multiPartRequest.fields['preparation_time'] = newRecipeModel!.preparationTime.validate().toString();
    multiPartRequest.fields['baking_time'] = newRecipeModel!.bakingTime.validate().toString();
    multiPartRequest.fields['resting_time'] = newRecipeModel!.restingTime.validate().toString();
    multiPartRequest.fields['dish_type'] = newRecipeModel!.dish_type.validate().toString();
    multiPartRequest.fields['cuisine'] = newRecipeModel!.cuisine.validate().toString();
    multiPartRequest.fields['status'] = status.validate().toString();
    multiPartRequest.fields['user_id'] = appStore.userId.toString();
  }
  if (id != -1) {
    multiPartRequest.fields['id'] = id.toString();
  }
  if (isWeb) {
    if (newRecipeModel!.fileBytes != null) {
      multiPartRequest.files.add(MultipartFile.fromBytes('recipe_image', newRecipeModel!.fileBytes!, filename: '.jpg'));
    }
  } else {
    if (file != null) multiPartRequest.files.add(await MultipartFile.fromPath('recipe_image', file.path));
  }

  await sendMultiPartRequest(
    multiPartRequest,
    onSuccess: (data) async {
      id = data["recipe_id"];

      log(data);
    },
    onError: (error) {
      toast(error.toString());
    },
  );

  await Future.delayed(Duration.zero);

  return id.validate();
}

/// Profile Update
Future updateProfile({String? userName, String? name, String? userEmail, String? bio, String? gender, String? dob, File? file, Uint8List? fileWeb}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('update-profile');
  multiPartRequest.fields['name'] = name!;
  multiPartRequest.fields['username'] = userName ?? appStore.userName;
  multiPartRequest.fields['email'] = userEmail ?? appStore.userEmail;
  multiPartRequest.fields['bio'] = bio!;
  multiPartRequest.fields['gender'] = gender!;
  multiPartRequest.fields['dob'] = dob!;
  if (isWeb) {
    multiPartRequest.files.add(MultipartFile.fromBytes('profile_image', fileWeb!, filename: '.jpg'));
  } else {
    if (file != null) multiPartRequest.files.add(await MultipartFile.fromPath('profile_image', file.path));
  }

  await sendMultiPartRequest(multiPartRequest, onSuccess: (data) async {
    if (data != null) {
      LoginResponse res = LoginResponse.fromJson(data);
      await setValue(NAME, res.userData!.name.validate());
      await setValue(USER_PHOTO_URL, res.userData!.profile_image.validate());
      await setValue(GENDER, res.userData!.gender.validate());
      await setValue(DOB, res.userData!.dob.validate());
      await setValue(BIO, res.userData!.bio.validate());

      await appStore.setUserName(res.userData!.username.validate());
      await appStore.setUserEmail(res.userData!.email.validate());
    }
  }, onError: (error) {
    toast(error.toString());
  });
}

/// Add  update Slider Data
Future<void> addSliderData({String? title, String? category, String? description, File? file, int? typeId, int? id, String? typeName, Uint8List? imageWeb}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('save-slider');

  multiPartRequest.fields['title'] = title.validate();
  multiPartRequest.fields['type'] = category.validate();
  multiPartRequest.fields['type_id'] = typeId.toString().validate();
  multiPartRequest.fields['description'] = description.validate();
  multiPartRequest.fields['status'] = 1.toString().validate();

  if (id != -1) {
    multiPartRequest.fields['id'] = id.toString();
  }

  if (isWeb) {
    if (imageWeb != null) {
      multiPartRequest.files.add(MultipartFile.fromBytes('slider_image', imageWeb, filename: '.jpg'));
    }
  } else {
    if (file != null) {
      multiPartRequest.files.add(await MultipartFile.fromPath('slider_image', file.path));
    }
  }

  return await sendMultiPartRequest(
    multiPartRequest,
    onSuccess: (data) async {
      return language!.addSliderSucessfully;
    },
    onError: (error) {
      log(error.toString());
      throw error.toString();
    },
  );

  //await Future.delayed(Duration.zero);
}
