part of 'add_update_or_delete_bloc.dart';

abstract class AddUpdateOrDeleteEvent extends Equatable {
  const AddUpdateOrDeleteEvent();
}

class AddPostEvent extends AddUpdateOrDeleteEvent {
  @override
  final Post post;
  AddPostEvent({required this.post});

  List<Object?> get props => [post];
}

class UpdatePostEvent extends AddUpdateOrDeleteEvent {
  @override
  final Post post;
  UpdatePostEvent({required this.post});

  List<Object?> get props => [post];
}

class DeletePostEvent extends AddUpdateOrDeleteEvent {
  @override
  final int postId;

  DeletePostEvent({required this.postId});

  List<Object?> get props => [postId];
}
