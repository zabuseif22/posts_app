import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import '../../../../core/util/current_location.dart';
import '../../../../core/util/geo_json_parser.dart';
import '../../data/models/MapModel.dart';
import '../../domain/usecases/get_map_all_info.dart';
part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final GetMapAllInfoUseCase getMapInfoUseCase;
  String? _myString = '';
  MapCubit({
    required this.getMapInfoUseCase,
  }) : super(MapInitial());

  get loadMapData async {
    emit(LoadingMapState());
    final result = await getMapInfoUseCase.call();
    result.fold((failure) {
      emit(ErrorMapState(message: failure.toString()));
    }, (success) {
      processData(success);
    });
  }

  // Getter
  String get myString {
    print('get--cubit-- ${_myString}');
    return _myString!;
  }

  // Setter
  set myString(String newValue) {
    _myString = newValue;
    print('set---- ${_myString}');
     emit(const LoadedMapState());
  }

  /// Call Methods
  Future<void> processData(String geoJson) async {
    /// Convert Json to Model
    var myGeoJson = await geoJsonParser(geoJson);

    /// Get Coordinates from Json Model
    var coordinate = getDataCoordinates(geoJson, myString);

    /// Get Current Location & Permission Access Location
    final Position currentLocation = await CrtLocation().getCurrentLocation();
    print("${currentLocation.latitude}  current-cubit--Location");

    /// Calculate Distance
    getDataCalculateDistance(coordinate, currentLocation, geoJson, myGeoJson);
  }

  void onTapMarkerFunction(Map<String, dynamic> map) {
    // print('onTapMarkerFunction:  $map');
  }

  ///Convert Json to Model & Set Data to Map
  geoJsonParser(String geoJson) {
    GeoJsonParser myGeoJson = GeoJsonParser(
        defaultMarkerColor: Colors.blueAccent,
        defaultPolygonBorderColor: Colors.pink,
        defaultPolygonFillColor: Colors.red.withOpacity(0.1));
    myGeoJson.setDefaultMarkerTapCallback(onTapMarkerFunction);
    myGeoJson.parseGeoJsonAsString(geoJson);

    return myGeoJson;
  }

  /// Get Coordinates form Model
  getDataCoordinates(String geoJson, String providerName) {
    final json = jsonDecode(geoJson);
    final geoJSONData = MapModel.fromJson(json);

    return checkCoordinatesForProvider(geoJSONData, providerName);
  }

  getDataCalculateDistance(List<List<double>> coordinates,
      Position currentLocation, String geoJson, myGeoJson) {
    double nearestDistance = double.infinity;
    double? nearestLatitude;
    double? nearestLongitude;
    double? latitude;
    double? longitude;
    double? distance;
    String distanceUnit = "KM";

    for (final coordinate in coordinates) {
      latitude = coordinate[1];
      longitude = coordinate[0];

      distance = CrtLocation().calculateDistance(currentLocation.latitude,
          currentLocation.longitude, latitude, longitude);

      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestLatitude = latitude;
        nearestLongitude = longitude;
        print(
            'nearestLatitude: $nearestLatitude nearestLongitude: $nearestLongitude');
      }
    }

    if (nearestDistance < 1) {
      nearestDistance *= 1000; // Convert to meters
      distanceUnit = "M";
    }
    /* if (kDebugMode) {
      print('----------Current Location----------:');
      print('----------Latitude----------: ${currentLocation.latitude}');
      print('----------Longitude----------: ${currentLocation.longitude}');
      print('----------Nearest Coordinates----------:');
      print('----------Latitude----------: $nearestLatitude');
      print('----------Longitude----------: $nearestLongitude');
      print('----------Distance----------: $nearestDistance : $distanceUnit');
    }*/

    //// Set On Location Change Here

    Position previousLocation;
    previousLocation = currentLocation;
    // Calculate distance between consecutive location updates

    // Emit distance value if it exceeds 1 meters
    //Location location = Location();
    //location.getLocation().then((value) {
    //currentLocation = value as Position;
    if (distance! >= 0.001) {
      if (distance < nearestDistance) {
        nearestDistance = distance;
        // emit(nearestDistance);
      }
      previousLocation = currentLocation;
    }

    emit(LoadedMapState(
        result: geoJson,
        myGeoJson: myGeoJson,
        currentLocation: currentLocation,
        nearestLatitude: nearestLatitude,
        nearestLongitude: nearestLongitude,
        nearestDistance: nearestDistance,
        distanceUnit: distanceUnit,
        previousLocation: previousLocation,
        selectedValue: myString));
    //});
  }

  checkCoordinatesForProvider(MapModel geoJSONData, String serviceProvider) {
    dynamic coordinates;
    print('serviceProvider $serviceProvider');
    final geometryList =
        geoJSONData.features.map((feature) => feature.geometry).toList();
    final propertiesList =
        geoJSONData.features.map((feature) => feature.properties).toList();
    for (var pro in propertiesList) {
      String name = pro.serviceProvider.toString();
      if (name.toLowerCase() == serviceProvider.toLowerCase()) {
        for (final geometry in geometryList) {
          coordinates = geometry.coordinates.first;
        }
      } else {
        for (final geometry in geometryList) {
          coordinates = geometry.coordinates.first;
        }
      }
    }

    return coordinates;
  }
}
