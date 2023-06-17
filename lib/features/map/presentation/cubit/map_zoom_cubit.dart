import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'map_zoom_state.dart';

class MapZoomCubit extends Cubit<MapZoomState> {
  MapZoomCubit() : super(MapZoomState(1.0));

  double zoomIn() {
    if (state.zoomLevel < 18.0) {
      emit(MapZoomState(state.zoomLevel + 1.0));

      print('${state.zoomLevel}  zoom in ');
    }
    return state.zoomLevel;
  }

  double zoomOut() {

    if (state.zoomLevel > 3.0) {

      emit(MapZoomState(state.zoomLevel- 1.0));
      
    }

    print('${state.zoomLevel}  zoom out ');
    return state.zoomLevel;
  }
}
