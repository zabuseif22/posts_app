part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();
}

class PostInitial extends PostState {
  @override
  List<Object> get props => [];
}

class LoadingPostsState extends PostState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LoadedPostState extends PostState {
  @override
  List<Post> posts;
  LoadedPostState({required this.posts});

  List<Object?> get props => [posts];

}

class ErrorPostsState extends PostState{

  @override

  final String message ;
  ErrorPostsState({required this.message});


  List<Object?> get props => [message];

}
