import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:posts_app/core/errors/exception.dart';
import 'package:posts_app/features/posts/data/models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getCachePosts();
  Future<Unit> cachPosts(List<PostModel> postModel);
}

const String CASHED_POST = 'CASHED_POST';

class PostModelLocalDataSourceImp implements PostLocalDataSource {
  SharedPreferences sharedPreferences;
  String CASHED_POST = 'CASHED_POST';
  PostModelLocalDataSourceImp({required this.sharedPreferences});

  @override
  Future<Unit> cachPosts(List<PostModel> postModel) {
    final postModelToJason = postModel
        .map<Map<String, dynamic>>((postModel) => postModel.toJson())
        .toList();
    sharedPreferences.setString(CASHED_POST, json.encode(postModelToJason));
    return Future.value(unit);
  }

  @override
  Future<List<PostModel>> getCachePosts() {
    final jsonString = sharedPreferences.getString(CASHED_POST);
    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);

      List<PostModel> jasonToPostMode = decodeJsonData
          .map<PostModel>((jsonPostModel) => PostModel.fromJson(jsonPostModel))
          .toList();
      return Future.value(jasonToPostMode);
    } else {
      throw EmptyCacheException();
    }
  }
}
