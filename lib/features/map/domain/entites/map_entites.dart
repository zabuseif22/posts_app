import 'package:equatable/equatable.dart';
import '../../data/models/MapModel.dart';
import 'package:latlong2/latlong.dart';
class MapEn extends Equatable {
  @override
  final LatLng  geometry;
  final Properties properties;

  MapEn({required this.geometry, required this.properties});

  List<Object?> get props => [geometry, properties];
}
