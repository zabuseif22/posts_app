part of 'sim_card_cubit.dart';

abstract class SimCardState extends Equatable {
  const SimCardState();
}

class SimCardInitial extends SimCardState {
  @override
  List<Object> get props => [];
}

class LoadingSimCardState extends SimCardState {
  @override
  List<Object> get props => [];
}

class LoadedSimCardState extends SimCardState {
  final List<SimCard> list;

  const LoadedSimCardState({required this.list});

  @override
  List<Object> get props => [];
}

class ErrorSimCardState extends SimCardState {
  final String message;

  const ErrorSimCardState(this.message);

  @override
  List<Object> get props => [message];
}
