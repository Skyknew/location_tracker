import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_user_location/location_helper.dart';

void main() {
  runApp(const MyApp()); // Entry point of the app
}

/// The root widget of the Flutter app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner
      home: Banner(
        message:
            'FlexZ', // Displays a banner with the text "FlexZ" at the top-right
        location: BannerLocation.topEnd, // Position of the banner
        child: FinalView(), // Main screen of the app
      ),
    );
  }
}

/// The main screen of the app (StatefulWidget to handle state changes)
class FinalView extends StatefulWidget {
  const FinalView({super.key});

  @override
  State<FinalView> createState() => _FinalViewState();
}

/// State class for `FinalView`
class _FinalViewState extends State<FinalView> {
  final LocationHelper locationHelper =
      LocationHelper(); // Instance of the location helper class
  String userLocation = 'No data'; // Stores the location data
  bool _isLoading = true; // Tracks whether location is being fetched

  @override
  void initState() {
    super.initState();
    getLocation(); // Fetch the location when the screen loads
  }

  /// Fetches the user's location and updates the UI
  Future<void> getLocation() async {
    setState(() => _isLoading = true); // Show loading indicator

    final locationData =
        await locationHelper.getuserLocation(); // Fetch location

    if (locationData != null) {
      setState(() {
        // Format and display the location details
        userLocation =
            'Latitude: ${locationData['latitude']}, Longitude: ${locationData['longitude']}\n'
            'City: ${locationData['city']}, Country: ${locationData['country']}\n'
            'Address: ${locationData['address']}';

        _isLoading = false; // Hide loading indicator
      });
    } else {
      setState(() {
        userLocation = 'Location not found'; // Display error message
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Location'), // App bar title
      ),
      body: Center(
        child: _isLoading
            ? const CupertinoActivityIndicator() // Show a loading indicator while fetching location
            : Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center content vertically
                children: [
                  Text(userLocation,
                      textAlign: TextAlign.center), // Display location info
                  const SizedBox(height: 20), // Add spacing
                  ElevatedButton(
                    onPressed:
                        getLocation, // Fetch location when button is pressed
                    child: const Text('Refresh Location'), // Button text
                  ),
                ],
              ),
      ),
    );
  }
}
