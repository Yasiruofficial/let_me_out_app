import 'package:geolocator/geolocator.dart';

class GeoLocatorService {

  Future<Position> determinePosition() async {

    print("Loading 1");

    LocationPermission permission;

    print("Loading 2");

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }
    print("Loading 3");

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    print("Loading 4");

    Position currentPosition =  await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      forceAndroidLocationManager: true
    );

    print("currentPosition is -> ${currentPosition}");

    return currentPosition;


  }

}
