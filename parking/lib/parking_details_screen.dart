import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // For Google Maps
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase client

class ParkingDetailsScreen extends StatefulWidget {
  final String parkingName;
  final String description;
  final String watchmanName;
  final String layout;
  final String spotSize;
  final String accessibility;
  final String lighting;

  final double latitude;
  final double longitude;
  final GoogleMapController mapController; // Controller passed from HomePage
  final Function onShowMapPressed;
  final String upiid; // UPI ID
  final int contactnumber; // Contact number
  final bool isAvailable; // Availability status

  ParkingDetailsScreen({
    required this.parkingName,
    required this.description,
    required this.watchmanName,
    required this.layout,
    required this.spotSize,
    required this.accessibility,
    required this.lighting,
    required this.latitude,
    required this.longitude,
    required this.mapController, // Receive the map controller
    required this.onShowMapPressed,
    required this.upiid,
    required this.contactnumber,
    required this.isAvailable, // Pass the availability status
  });

  @override
  _ParkingDetailsScreenState createState() => _ParkingDetailsScreenState();
}

class _ParkingDetailsScreenState extends State<ParkingDetailsScreen> {
  late String spotSize;

  @override
  void initState() {
    super.initState();
    spotSize = widget.spotSize;
  }

  // Function to update the availability in Supabase
  Future<void> _updateAvailability(bool available) async {
    final response =
        await Supabase.instance.client.from('parking_spots').update({
      'available': available,
    }).eq('parking_name', widget.parkingName);

    if (response.error == null) {
      print(
          "Parking spot availability updated successfully!"); // Debug: Success
    } else {
      print(
          "Error updating availability: ${response.error!.message}"); // Debug: Error
    }
  }

  Future<void> reduceSpotSize(String parkingSpotId) async {
    try {
      print('Starting to reduce spot size for parking spot: $parkingSpotId');

      // Fetch the current spot size from the 'parking_spots' table
      final response = await Supabase.instance.client
          .from('parking_spots')
          .select('spot_size')
          .eq('parking_name',
              parkingSpotId) // Ensure you use the correct column name for the unique identifier
          .single();

      if (response == null) {
        print('Error: No response returned for parking spot: $parkingSpotId');
        throw Exception('Error fetching parking spot details: ${response}');
      }

      // Convert the spot_size (varchar) to an integer
      String spotSizeStr = response['spot_size'];
      int currentSpotSize =
          int.tryParse(spotSizeStr) ?? 0; // Default to 0 if parsing fails
      print('Current spot size for $parkingSpotId: $currentSpotSize');

      if (currentSpotSize > 0) {
        // Decrease the spot size by 1
        print('Decreasing spot size by 1...');
        final updatedSpotSize = (currentSpotSize - 1)
            .toString(); // Convert back to string after subtracting

        final updateResponse = await Supabase.instance.client
            .from('parking_spots')
            .update({'spot_size': updatedSpotSize}).eq('parking_name',
                parkingSpotId); // Ensure you use the correct column name for the unique identifier

        print("Spot size reduced successfully for $parkingSpotId!");
        // Update the spot size in the UI
        setState(() {
          spotSize = updatedSpotSize;
        });
      } else {
        print("No available spots to reduce for $parkingSpotId.");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Parking Spot Details',
          style: TextStyle(
            fontFamily: 'Poppins', // Use Poppins font
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF2ED0C2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Parking Name: ${widget.parkingName}',
                style: TextStyle(
                  fontFamily: 'Poppins', // Use Poppins font
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Description: ${widget.description}',
                style: TextStyle(
                  fontFamily: 'Poppins', // Use Poppins font
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Watchman Name: ${widget.watchmanName}',
                style: TextStyle(
                  fontFamily: 'Poppins', // Use Poppins font
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Layout: ${widget.layout}',
                style: TextStyle(
                  fontFamily: 'Poppins', // Use Poppins font
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Available Spots: $spotSize',
                style: TextStyle(
                  fontFamily: 'Poppins', // Use Poppins font
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Four Wheeler Hourly Charges: ${widget.accessibility}',
                style: TextStyle(
                  fontFamily: 'Poppins', // Use Poppins font
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Two Wheeler Hourly Charges: ${widget.lighting}',
                style: TextStyle(
                  fontFamily: 'Poppins', // Use Poppins font
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'UPI ID: ${widget.upiid}',
                style: TextStyle(
                  fontFamily: 'Poppins', // Use Poppins font
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Contact Number: ${widget.contactnumber}',
                style: TextStyle(
                  fontFamily: 'Poppins', // Use Poppins font
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              
              // Mark Occupied Button
              ElevatedButton(
                onPressed: () async {
                  // Show the confirmation dialog
                  bool? isConfirmed = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text(
                            'Do you really want to reduce the available spots?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false); // User pressed No
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true); // User pressed Yes
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );

                  // If the user confirmed, reduce the spot size
                  if (isConfirmed != null && isConfirmed) {
                    reduceSpotSize(
                        widget.parkingName); // Update availability in Supabase

                    // Update UI accordingly
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reduced Available Spots'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Red for marking occupied
                ),
                child: Text(
                  'Book a Slot',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),

              // Show on Map Button
              ElevatedButton(
                onPressed: () {
                  // Navigate back to the map view and center the camera on the marker
                  widget.mapController.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(widget.latitude, widget.longitude),
                      15.0, // Zoom level
                    ),
                  ); // Focus on the marker on the map
                  Navigator.pop(context); // Close the details screen
                  widget
                      .onShowMapPressed(); // Switch to map view using the callback function
                },
                child: Text('Show on Map'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2ED0C2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
