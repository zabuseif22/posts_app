import 'package:dartz/dartz.dart';
import 'package:posts_app/core/errors/exception.dart';
import 'package:posts_app/core/errors/failures.dart';
import 'package:posts_app/features/posts/data/datasources/post_local_data_source.dart';
import 'package:posts_app/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:posts_app/features/posts/data/models/post_model.dart';
import 'package:posts_app/features/posts/domain/entites/post.dart';
import 'package:posts_app/features/posts/domain/repositores/post_repository.dart';

import '../../../../core/network/network_info.dart';

typedef DeleteOrUpdateOrAddPost = Future<Unit> Function();

class PostsRepositoryImp implements PostRepository {
  final PostRemoteDataSource postRemoteDataSource;
  final PostLocalDataSource postLocalDataSource;
  final NetworkInfo networkInfo;

  PostsRepositoryImp(
      {required this.postRemoteDataSource,
      required this.postLocalDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePost = await postRemoteDataSource.getAllPosts();
        postLocalDataSource.cachPosts(remotePost);
        return Right(remotePost);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPost = await postLocalDataSource.getCachePosts();
        return Right(localPost);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePost(Post post) async {
    final PostModel postModel =
        PostModel(id: post.id, title: post.title, body: post.body);
    return await _getMessage(() => postRemoteDataSource.updatePost(postModel));
  }

  @override
  Future<Either<Failure, Unit>> addPost(Post post) async {
    final PostModel postModel =
        PostModel( title: post.title, body: post.body);
    return await _getMessage(() => postRemoteDataSource.addPost(postModel));
  }

  @override
  Future<Either<Failure, Unit>> deletePost(int postId) async {
    return await _getMessage(() => postRemoteDataSource.deletePost(postId));
  }

  Future<Either<Failure, Unit>> _getMessage(
      DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost) async {
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost();
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
