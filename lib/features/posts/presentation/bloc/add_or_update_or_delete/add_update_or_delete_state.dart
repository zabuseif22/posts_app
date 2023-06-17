part of 'add_update_or_delete_bloc.dart';

abstract class AddUpdateOrDeleteState extends Equatable {
  const AddUpdateOrDeleteState();
}

class AddUpdateOrDeleteInitial extends AddUpdateOrDeleteState {
  @override
  List<Object> get props => [];
}



class LoadingAddDeleteUpdateState extends AddUpdateOrDeleteState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ErrorAddDeleteUpdateState extends AddUpdateOrDeleteState {
  @override
  final String message;
  ErrorAddDeleteUpdateState({required this.message});

  List<Object?> get props => [message];
}

class MessageAddDeleteUpdateState extends AddUpdateOrDeleteState {
  @override
  final String message;
  MessageAddDeleteUpdateState({required this.message});

  List<Object?> get props => [message];
}
