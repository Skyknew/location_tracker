import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationHelper {
  /// Request location permission and return user location with city and country
  Future<Map<String,dynamic>?> getuserLocation() async{
    bool serviceEnabled;
    LocationPermission permission;

    //Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null; // Location Service is not enabled !
    }

    //check  location permission 
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        return null; // Location Permission denied
      }
    }

    if (permission == LocationPermission.deniedForever){
      print('Location permissions are permanently denied.');
      return null; //Permission are permanently denied
    }

    // Get user location 

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

        //convert coordinates to city and country
        List<Placemark> placemarks = await placemarkFromCoordinates(
         position.latitude ,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];

        

          return {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'city': place.locality ?? 'Unknown',
            'country': place.country ?? 'Unknown',
            'address':'${place.street}, ${place.locality}, ${place.country}',
          };
        } 
        print('No placemarks found.');
        return null;

    } catch (e) {
      print('Error getting location: $e');
    } 
    return null;
  }
}