part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
}


class GetAllPostsEvent extends PostEvent{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}

class RefreshPostsEvent extends PostEvent{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}