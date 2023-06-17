import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_number/sim_card.dart';

import '../../domain/usecases/get_map_all_info.dart';

part 'sim_card_state.dart';

class SimCardCubit extends Cubit<SimCardState> {
  final GetMapAllInfoUseCase getMapInfoUseCase;

  SimCardCubit({
    required this.getMapInfoUseCase,
  }) : super(SimCardInitial());

  void get loadSimCard async {


    final result = await getMapInfoUseCase.callSimCard();

    result.fold((failure) {
      emit(ErrorSimCardState(failure.toString()));


    }, (success) {
      emit(LoadedSimCardState(list: success));
    });
  }
}
