import 'dart:io';

import 'package:recipe_app/models/RecipeUtensilsModel.dart';

class RecipeStepModel {
  String? description;
  int? id;
  String? recipe_step_image;
  String? ingredient_used_id;
  String? media_link;
  int? recipe_id;
  List<StepUtensil>? utensil;

  //Local
  File? stepImage;

  RecipeStepModel({this.description, this.id, this.recipe_step_image, this.ingredient_used_id, this.media_link, this.recipe_id, this.utensil});

  factory RecipeStepModel.fromJson(Map<String, dynamic> json) {
    return RecipeStepModel(
      description: json['description'],
      id: json['id'],
      recipe_step_image: json['recipe_step_image'],
      ingredient_used_id: json['ingredient_used_id'],
      media_link: json['media_link'],
      recipe_id: json['recipe_id'],
      utensil: json['utensil'] != null ? (json['utensil'] as List).map((i) => StepUtensil.fromJson(i)).toList() : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['id'] = this.id;
    data['recipe_step_image'] = this.recipe_step_image;
    data['ingredient_used_id'] = this.ingredient_used_id;
    data['media_link'] = this.media_link;
    data['recipe_id'] = this.recipe_id;
    data['utensil'] = this.utensil;
    return data;
  }
}
