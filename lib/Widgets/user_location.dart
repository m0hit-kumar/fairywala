// ignore_for_file: avoid_print

import 'package:geolocator/geolocator.dart';

class UserLocation {
  double latitude = 28.765;
  double longitude = -77.5673;

  UserLocation();

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<List<double>> getUserLocation() async {
    print('inside user location ');
    List<double> list = [];

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    } else {
      Position currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = currentLocation.latitude;
      longitude = currentLocation.longitude;
      print(' userloaction is --- $latitude $longitude');
      list.add(latitude);
      list.add(longitude);
      return list;
    }
  }
}
