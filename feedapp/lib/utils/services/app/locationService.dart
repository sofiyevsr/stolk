import 'package:stolk/utils/error.dart';
import 'package:location/location.dart';

class LocationService {
  final _location = Location();

  Future<void> initialize() async {
    await _requestNecessaryServices();
    final hasPermission = await _checkPermissions();
    if (!hasPermission) {
      throw CustomError(message: "permission.location_fail");
    }
  }

  Future<LocationData> getCurrentLocation() {
    return _location.getLocation();
  }

  Stream<LocationData> getPositionStream() {
    return _location.onLocationChanged;
  }

  Future<bool> _checkPermissions() async {
    final permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      final lastPermission = await _location.requestPermission();
      if (lastPermission == PermissionStatus.denied ||
          lastPermission == PermissionStatus.deniedForever) {
        return false;
      }
    } else if (permission == PermissionStatus.deniedForever) {
      return false;
    }
    return true;
  }

  Future<bool> _requestNecessaryServices() async {
    final locationServiceEnabled = await _location.serviceEnabled();
    if (locationServiceEnabled == false) {
      // should open settings?
      // await Geolocator.openLocationSettings();
      final lastLocationRequest = await _location.requestService();
      if (lastLocationRequest == true) {
        return true;
      }
      return false;
    }
    return true;
  }
}
