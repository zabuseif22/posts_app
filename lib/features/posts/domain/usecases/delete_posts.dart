import 'package:dartz/dartz.dart';
import 'package:posts_app/core/errors/failures.dart';
import 'package:posts_app/features/posts/domain/repositores/post_repository.dart';

class DeletePostUseCase {
  late final PostRepository postRepository;

  DeletePostUseCase(this.postRepository);

  Future<Either<Failure, Unit>> call(int postId) async {
    return await postRepository.deletePost(postId);
  }
}
