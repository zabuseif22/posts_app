import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:posts_app/core/messages/messages.dart';

import '../../../../../core/errors/errors.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entites/post.dart';
import '../../../domain/usecases/add_posts.dart';
import '../../../domain/usecases/delete_posts.dart';
import '../../../domain/usecases/update_posts.dart';

part 'add_update_or_delete_event.dart';
part 'add_update_or_delete_state.dart';

class AddUpdateOrDeleteBloc
    extends Bloc<AddUpdateOrDeleteEvent, AddUpdateOrDeleteState> {
  final AddPostUseCase addPost;
  final UpdatePostUseCase updatePost;
  final DeletePostUseCase deletePost;

  AddUpdateOrDeleteBloc(
      {required this.addPost,
      required this.updatePost,
      required this.deletePost})
      : super(AddUpdateOrDeleteInitial()) {
    on<AddUpdateOrDeleteEvent>((event, emit) async {
      if (event is AddPostEvent) {
        emit(LoadingAddDeleteUpdateState());
        final failuerOrDone = await addPost.call(event.post);
        emit(_mapAddDeleteUpdate(failuerOrDone, MESSAGE_ADD_SUCCESSFUL));
      } else if (event is UpdatePostEvent) {
        emit(LoadingAddDeleteUpdateState());
        final failuerOrDone = await updatePost.call(event.post);
        emit(_mapAddDeleteUpdate(failuerOrDone, MESSAGE_UPDATE_SUCCESSFUL));
      } else if (event is DeletePostEvent) {
        emit(LoadingAddDeleteUpdateState());
        final failuerOrDone = await deletePost(event.postId);
        emit(_mapAddDeleteUpdate(failuerOrDone, MESSAGE_DELETE_SUCCESSFUL));
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

  AddUpdateOrDeleteState _mapAddDeleteUpdate(
      Either<Failure, Unit> failuerOrDone, String message) {
    return failuerOrDone.fold(
        (l) => ErrorAddDeleteUpdateState(message: _mapFailuerToMessage(l)),
        (r) => (MessageAddDeleteUpdateState(message: message)));
  }
}
