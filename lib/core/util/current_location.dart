import 'dart:math';

import 'package:geolocator/geolocator.dart' as geoloc;
import 'package:location/location.dart';

class CrtLocation {
  getCurrentLocation() async {
    final location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    geoloc.Position currentPosition =
        await geoloc.Geolocator.getCurrentPosition(
      desiredAccuracy: geoloc.LocationAccuracy.high,
    );

    return currentPosition;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Radius of the Earth in kilometers

    // Convert latitude and longitude to radians
    double lat1Rad = lat1 * (pi / 180);
    double lon1Rad = lon1 * (pi / 180);
    double lat2Rad = lat2 * (pi / 180);
    double lon2Rad = lon2 * (pi / 180);

    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * asin(sqrt(a));

    double distance = earthRadius * c;
    return distance;
  }

  double calculateBearing(
      double startLat, double startLng, double endLat, double endLng) {
    double startLatRad = startLat * pi / 180;
    double startLngRad = startLng * pi / 180;
    double endLatRad = endLat * pi / 180;
    double endLngRad = endLng * pi / 180;

    double dLng = endLngRad - startLngRad;

    double y = sin(dLng) * cos(endLatRad);
    double x = cos(startLatRad) * sin(endLatRad) -
        sin(startLatRad) * cos(endLatRad) * cos(dLng);

    double bearingRad = atan2(y, x);
    double bearingDeg = bearingRad * 180 / pi;

    // Adjust the bearing value to be between 0 and 360 degrees
    double bearing360 = (bearingDeg + 360) % 360;

    return bearing360;
  }



}
