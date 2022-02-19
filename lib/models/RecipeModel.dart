import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:recipe_app/models/RecipeStepModel.dart';
import 'package:recipe_app/utils/Widgets.dart';

import 'RecipeDetailModel.dart';
import 'package:nb_utils/nb_utils.dart';

class RecipeModel {
  String? bakingTime;
  String? cuisine;
  String? difficulty;
  String? dish_type;
  String? recipe_image;
  String? portionType;
  int? portionUnit;
  String? preparationTime;
  String? restingTime;
  int? status;
  String? title;
  int? user_id;
  int? id;
  int? bookmarkId;

  int? is_bookmark;
  int? is_like;
  var total_rating;
  int? total_review;
  int? like_count;

  //Local
  List<Ingredient>? ingredients;
  List<RecipeStepModel>? steps;

  File? recipeFile;
  int? totalLike;
  Uint8List? fileBytes;

  Widget recipeImageWidget() {
    return commonCachedNetworkImage(
      recipe_image.validate(),
      fit: BoxFit.cover,
      height: 250,
    ).cornerRadiusWithClipRRect(10);
  }

  RecipeModel({
    this.bakingTime,
    this.cuisine,
    this.difficulty,
    this.dish_type,
    this.recipe_image,
    this.portionType,
    this.portionUnit,
    this.preparationTime,
    this.restingTime,
    this.status,
    this.title,
    this.user_id,
    this.id,
    this.is_bookmark,
    this.ingredients,
    this.is_like,
    this.total_rating,
    this.total_review,
    this.like_count,
    this.recipeFile,
    this.totalLike,
    this.bookmarkId,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      bakingTime: json['baking_time'],
      cuisine: json['cuisine'],
      difficulty: json['difficulty'],
      dish_type: json['dish_type'],
      recipe_image: json['recipe_image'],
      portionType: json['portion_type'],
      portionUnit: json['portion_unit'],
      preparationTime: json['preparation_time'],
      restingTime: json['resting_time'],
      status: json['status'],
      title: json['title'],
      user_id: json['user_id'],
      id: json['id'],
      ingredients: json['ingredients'] != null ? (json['ingredients'] as List).map((i) => Ingredient.fromJson(i)).toList() : null,
      is_bookmark: json['is_bookmark'],
      is_like: json['is_like'],
      total_rating: json['total_rating'],
      total_review: json['total_review'],
      like_count: json['like_count'],
      bookmarkId: json['bookmark_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['baking_time'] = this.bakingTime;
    data['difficulty'] = this.difficulty;
    data['recipe_image'] = this.recipe_image;
    data['portion_type'] = this.portionType;
    data['portion_unit'] = this.portionUnit;
    data['preparation_time'] = this.preparationTime;
    data['resting_time'] = this.restingTime;
    data['status'] = this.status;
    data['title'] = this.title;
    data['user_id'] = this.user_id;
    data['cuisine'] = this.cuisine;
    data['dish_type'] = this.dish_type;
    data['id'] = this.id;
    data['is_bookmark'] = this.is_bookmark;
    data['is_like'] = this.is_like;
    data['total_rating'] = this.total_rating;
    data['total_review'] = this.total_review;
    data['like_count'] = this.like_count;
    data['bookmark_id'] = this.bookmarkId;
    if (this.ingredients != null) {
      data['ingredients'] = this.ingredients!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
