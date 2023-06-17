import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mobile_number/mobile_number.dart';
import 'package:posts_app/features/map/data/models/MapModel.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entites/map_entites.dart';

// data/geojson_data_source.dart
abstract class GeoJsonDataSource {
  Future<String> getGeoJsonDataAssets();
  Future<List<MapEn>> getGeoJsonDataProp();
  Future<List<SimCard>> getSimCardType();
}

// data/geojson_data_source_impl.dart
class GeoJsonDataSourceImpl implements GeoJsonDataSource {
  late BuildContext context;
  @override
  Future<String> getGeoJsonDataAssets() async {
    final geoJsonString = await rootBundle.loadString('assets/geomap.geojson');

    return geoJsonString;
  }

  @override
  Future<List<MapEn>> getGeoJsonDataProp() async {
    final geoJsonString = await rootBundle.loadString('assets/geomap.geojson');
    Map<String, dynamic> geoJSON = json.decode(geoJsonString);
    List<MapEn> listMap = [];
    final geoJSONData = MapModel.fromJson(geoJSON);
    listMap = geoJSONData.features
        .expand((fe) => fe.geometry.coordinates.first.map((ge) => MapEn(
              geometry: LatLng(ge[1], ge[0]),
              properties: fe.properties,
            )))
        .toList();

    return Future.value(listMap);
  }

  @override
  Future<List<SimCard>> getSimCardType() async {




    List<SimCard> simCards = await MobileNumber.getSimCards!;
    for (SimCard simCard in simCards) {
      if (kDebugMode) {
        print('Sim Card Info:');
        print('Carrier Name: ${simCard.carrierName}');
        print('Country Iso: ${simCard.countryIso}');
        print('Display Name: ${simCard.displayName}');

        print('Slot Index: ${simCard.slotIndex}');

        print('Is Data countryIso: ${simCard.countryIso}');
        print('Is Data countryPhonePrefix: ${simCard.countryPhonePrefix}');

        print('---');
      }
    }
    return Future.value(simCards);
  }
}
