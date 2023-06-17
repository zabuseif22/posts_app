import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:posts_app/features/map/presentation/cubit/propart_cubit.dart';
import 'package:posts_app/features/posts/presentation/widgets/loading_widget.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import '../../../../core/util/geo_json_parser.dart';
import '../cubit/map_cubit.dart';
import '../cubit/map_zoom_cubit.dart';
import 'compass_widget.dart';

class MapWidget extends StatefulWidget {
  MapWidget(
      {required this.nearestLatitude,
      required this.currentLocation,
      required this.nearestLongitude,
      required this.myGeoJson,
      Key? key})
      : super(key: key);
  double nearestLatitude;
  Position currentLocation;
  double nearestLongitude;
  GeoJsonParser myGeoJson;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  // final MapController _mapController = MapController();
  Location location = Location();
  double rotationAngle = 0.0;
  Timer? timer;
  MapZoomPanBehavior? _zoomPanBehavior;
  MapShapeSource? _shapeSource;
  late MapShapeSource _sublayerSource;
  MapShapeLayerController? _shapeLayerController;

  @override
  void initState() {
    super.initState();
    syncFusionInitaliz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingWidgets(),
      body: BlocBuilder<PropartCubit, PropartState>(
        builder: (context, state) {
          if (state is LoadedListMapState) {
            return SfMaps(
              layers: [

                MapShapeLayer(
                  source: _shapeSource!,
                  zoomPanBehavior: _zoomPanBehavior,
                  showDataLabels: true,
                  initialMarkersCount: 1,
                  sublayers: [
                    /*   MapShapeSublayer(
                            source: _sublayerSource,
                            showDataLabels: true,
                            color: Colors.blue[100],
                            strokeWidth: 2,
                            strokeColor: Colors.blue[800],
                            dataLabelSettings: const MapDataLabelSettings(
                              overflowMode: MapLabelOverflow.ellipsis,
                              textStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                 ),
                            ),

                          ),*/
                    MapCircleLayer(
                      circles: List<MapCircle>.generate(
                        1,
                            (int index) {
                          return MapCircle(
                            radius: 30,
                            color: Colors.white.withOpacity(0.2),
                            strokeColor: Colors.blue,
                            center: MapLatLng(
                                widget.currentLocation.latitude,
                                widget.currentLocation.longitude),
                          );
                        },
                      ).toSet(),
                    ),
                    /*  MapPolygonLayer(
                            color: Colors.blue.withOpacity(0.7),
                            strokeColor: Colors.blue,

                            polygons: List<MapPolygon>.generate(
                              state.listProp.length,
                                  (int index) {
                                return  MapPolygon(
                                  points: [
                                    MapLatLng(
                                     state.listProp[index].coordinates.latitude,
                                     state.listProp[index].coordinates.longitude,
                                    ),

                                  ],
                                );
                              },
                            ).toSet(),
                          ),*/
                    MapCircleLayer(
                      circles: List<MapCircle>.generate(
                        state.listProp.length,
                            (int index) {
                          if (state.listProp[index].name
                              .toString()
                              .toLowerCase() ==
                              context.read<MapCubit>().myString) {
                            return MapCircle(
                                radius: 1,
                                onTap: (){
                                  print( state.listProp[index].name);
                                },
                                color: Colors.white.withOpacity(0.2),
                                strokeColor: Colors.orange,
                                center: state.listProp[index].name
                                    .toString()
                                    .toLowerCase() ==
                                    context.read<MapCubit>().myString
                                    ? MapLatLng(
                                  state.listProp[index].coordinates
                                      .latitude,
                                  state.listProp[index].coordinates
                                      .longitude,
                                )
                                    : MapLatLng(
                                  state.listProp[index].coordinates
                                      .latitude,
                                  state.listProp[index].coordinates
                                      .longitude,
                                ));
                          }else{
                            return const MapCircle(center: MapLatLng(
                              0.0,0.0,
                            ));
                          }
                        },
                      ).toSet(),
                    ),
                    /*  MapPolylineLayer(
                            color: Colors.blue.withOpacity(0.7),

                            polylines: List<MapPolyline>.generate(
                              state.listProp.length,
                                  (int index) {
                                return MapPolyline(
                                  points:  [
                                    MapLatLng(
                                        widget.currentLocation.latitude,
                                        widget.currentLocation.longitude
                                    ),
                                    MapLatLng(
                                        widget.nearestLatitude, widget.nearestLongitude
                                    )


                                  ],
                                );
                              },
                            ).toSet(),
                          ),*/
                  ],
                  markerBuilder: (BuildContext context, int index) {
                    return MapMarker(
                        latitude: widget.currentLocation.latitude,
                        longitude: widget.currentLocation.longitude,
                        child: CompassWidget(
                            currentLocation: widget.currentLocation,
                            nearestLatitude: widget.nearestLatitude,
                            nearestLongitude:
                            widget.nearestLongitude) //CompassWidget(),
                    );
                  },
                ),
              ],
            );
          }
          return const LoadingWidget();
        },
      ),
    );
  }

  Widget floatingWidgets() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () {

            if (_zoomPanBehavior!.zoomLevel < 15) {
              _zoomPanBehavior!.zoomLevel += 1;
            }
          },
          child: const Icon(Icons.add),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
            onPressed: () {

              if (_zoomPanBehavior!.zoomLevel > 3) {
                _zoomPanBehavior!.zoomLevel -= 1;
              }
            },
            child: const Icon(Icons.remove)),
        const SizedBox(height: 10),
        BlocBuilder<MapCubit, MapState>(builder: (context, state) {
          if (state is LoadedMapState) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: FloatingActionButton(
                    onPressed: () {

                    },
                    child: const Icon(Icons.fullscreen),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () => moveToCurrentLocation()

                  ,
                  child: const Icon(Icons.my_location),
                ),
              ],
            );
          }
          return const Text('');
        })
      ],
    );
  }

  void moveToCurrentLocation() {
    final latLng = MapLatLng(
        widget.currentLocation.latitude, widget.currentLocation.longitude);
    _zoomPanBehavior!.zoomLevel = 12;
    _zoomPanBehavior!.focalLatLng = latLng;
  }

  void syncFusionInitaliz() {
    _shapeLayerController = MapShapeLayerController();
    _zoomPanBehavior = MapZoomPanBehavior()
      ..enableDoubleTapZooming = true
      ..maxZoomLevel = 15
      ..minZoomLevel = 2
      ..enablePinching = true;
    _shapeSource = const MapShapeSource.asset(
      'assets/base.json',
      shapeDataField: 'name',
    );
    _sublayerSource = const MapShapeSource.asset(
      'assets/geomap.geojson',
      shapeDataField: 'ServiceProvider',
      //shapeDataField: 'ServiceProvider',
    );
  }
}
