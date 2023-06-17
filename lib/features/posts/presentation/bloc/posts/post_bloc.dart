import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:posts_app/core/errors/failures.dart';
import 'package:posts_app/features/posts/domain/entites/post.dart';
import 'package:posts_app/features/posts/domain/usecases/get_all_posts.dart';

import '../../../../../core/errors/errors.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetAllPostUseCase getAllPost;
  PostBloc({required this.getAllPost}) : super(PostInitial()) {
    on<PostEvent>((event, emit) async {
      if (event is GetAllPostsEvent) {
        emit(LoadingPostsState());
        final posts = await getAllPost.call();
        emit(_mapPostStateOrFailure(posts));
      } else if (event is RefreshPostsEvent) {
        final posts = await getAllPost.call();
        emit(_mapPostStateOrFailure(posts));
      }
    });
  }

  String _mapFailuerToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_ERROR_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_ERROR_MESSAGE;

      case OfflineFailure:
        return OFFLIN_ERROR_MESSAGE;

      default:
        return UNEXPCTION_ERROR_MESSAGE;
    }
  }

  PostState _mapPostStateOrFailure(Either<Failure, List<Post>> either) {
    return either.fold(
        (failure) => ErrorPostsState(message: _mapFailuerToMessage(failure)),
        (posts) => LoadedPostState(posts: posts));
  }
}
