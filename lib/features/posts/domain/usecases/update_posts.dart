import 'package:dartz/dartz.dart';
import 'package:posts_app/core/errors/failures.dart';
import 'package:posts_app/features/posts/domain/repositores/post_repository.dart';

import '../entites/post.dart';

class UpdatePostUseCase {
  late final PostRepository postRepository;

  UpdatePostUseCase(this.postRepository);

  Future<Either<Failure, Unit>> call(Post post) async {
    return await postRepository.updatePost(post);
  }
}
