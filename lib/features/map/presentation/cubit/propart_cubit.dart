import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:posts_app/features/map/domain/entites/map_entites.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import '../../../../core/util/custom_point.dart';
import '../../domain/usecases/get_map_all_info.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
part 'propart_state.dart';

class PropartCubit extends Cubit<PropartState> {
  final GetMapAllInfoUseCase getMapInfoUseCase;

  PropartCubit({
    required this.getMapInfoUseCase,
  }) : super(const PropartInitial());

  void get loadMapDataListProp async {
    emit(LoadingprState());
    final result = await getMapInfoUseCase.callProp();

    result.fold((failure) {
      emit(ErrorPropState(message: failure.toString()));
    }, (success) {
      emit(LoadedListMapState(
        listProp: getDataFeature(success),
      ));
    });
  }

  List<Point> getDataFeature(List<MapEn> success) {
    return success.map((data) {
      return Point(
        data.properties.serviceProvider.toString(),
        MapLatLng(data.geometry.latitude, data.geometry.longitude),
      );
    }).toList();
  }
}
