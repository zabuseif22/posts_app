import 'package:dartz/dartz.dart';
import 'package:posts_app/features/posts/domain/repositores/post_repository.dart';

import '../../../../core/errors/failures.dart';
import '../entites/post.dart';

class GetAllPostUseCase {
  late final PostRepository postRepository;

  GetAllPostUseCase(this.postRepository);

  Future<Either<Failure, List<Post>>> call() async {
    return await postRepository.getAllPosts();
  }
}
