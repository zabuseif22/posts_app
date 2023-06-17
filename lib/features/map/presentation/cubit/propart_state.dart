part of 'propart_cubit.dart';

abstract class PropartState extends Equatable {

  const PropartState();
}

class PropartInitial extends PropartState {

  const PropartInitial();
  @override
  List<Object> get props => [];
}

class LoadedListMapState extends PropartState {
  final List<Point> listProp;

  LoadedListMapState({required this.listProp});

  @override
  // TODO: implement props
  List<Object?> get props => [listProp];
}
class LoadingprState extends PropartState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
class ErrorPropState extends PropartState {
  final String message;

  const ErrorPropState({required this.message});

  @override
  List<Object> get props => [message];
}
