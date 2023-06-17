part of 'map_cubit.dart';

abstract class MapState extends Equatable {
  const MapState();
}

class MapInitial extends MapState {
  @override
  List<Object> get props => [];
}

class LoadingMapState extends MapState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LoadedMapState extends MapState {
  final String ?result;
  final GeoJsonParser ?myGeoJson;
  final Position ?currentLocation;
  final double ?nearestDistance;
  final double? nearestLatitude;
  final double? nearestLongitude;
  final String ?distanceUnit;
  final Position? previousLocation;
  final String ? selectedValue;

  const LoadedMapState({
      this.result,
      this.myGeoJson,
      this.currentLocation,
      this.nearestDistance,
      this.nearestLongitude,
      this.nearestLatitude,
      this.distanceUnit,
      this.previousLocation,
      this.selectedValue
  });

  @override
  List<Object> get props => [];
}

class ErrorMapState extends MapState {
  final String message;

  const ErrorMapState({required this.message});

  @override
  List<Object> get props => [message];
}


