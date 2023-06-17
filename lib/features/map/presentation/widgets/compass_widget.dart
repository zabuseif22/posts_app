import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

import '../../../../core/util/current_location.dart';

class CompassWidget extends StatefulWidget {
  var nearestLatitude;
  var currentLocation;
  var nearestLongitude;
  CompassWidget(
      {required this.nearestLatitude,
      required this.currentLocation,
      required this.nearestLongitude,
      Key? key})
      : super(key: key);

  @override
  State<CompassWidget> createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<CompassWidget> {
  double _currentHeading = 0;

  @override
  void initState() {
    super.initState();
    FlutterCompass.events!.listen((event) {
      _currentHeading = event.heading!;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Transform.rotate(
            angle: pi /
                180 *
                calculateBearingToNearestLocation(
                    widget.currentLocation.latitude,
                    widget.currentLocation.longitude,
                    widget.nearestLatitude,
                    widget.nearestLongitude),
            child: Stack(
              children: const [
                Icon(
                  Icons.send_sharp,

                  size: 30,
                  color: Colors.orange,
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }

  double calculateBearingToNearestLocation(double currentLat, double currentLon,
      double nearestLat, double nearestLon) {
    double bearing = CrtLocation()
        .calculateBearing(currentLat, currentLon, nearestLat, nearestLon);
    double adjustedBearing = (bearing - _currentHeading + 360) % 360;
    return adjustedBearing;
  }
}
