import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // For Google Maps
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Import Supabase client

class ParkingDetailsScreenForSeekers extends StatelessWidget {
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

  ParkingDetailsScreenForSeekers({
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

  // Function to update the availability in Supabase
  Future<void> _updateAvailability(bool available) async {
    final response = await Supabase.instance.client.from('parking_spots').update({
      'available': available,
    }).eq('parking_name', parkingName);

    if (response.error == null) {
      print("Parking spot availability updated successfully!"); // Debug: Success
    } else {
      print("Error updating availability: ${response.error!.message}"); // Debug: Error
    }
  }

  _launchPhoneDialer() async {
    final url = 'tel:1234567891';  // Format the phone number
    if (await canLaunch(url)) {
      await launch(url);  // Launch the dialer with the phone number
    } else {
      throw 'Could not launch $url';  // Handle error if the dialer cannot be opened
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
                'Parking Name: $parkingName',
                style: TextStyle(
                  fontFamily: 'Poppins', // Use Poppins font
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Description: $description',
                style: TextStyle(
                  fontFamily: 'Poppins', // Use Poppins font
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Watchman Name: $watchmanName',
                style: TextStyle(
                  fontFamily: 'Poppins', // Use Poppins font
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Layout: $layout',
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
                'Four Wheeler Hourly Charges: $accessibility',
                style: TextStyle(
                  fontFamily: 'Poppins', // Use Poppins font
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Two Wheeler Hourly Charges: $lighting',
                style: TextStyle(
                  fontFamily: 'Poppins', // Use Poppins font
                  fontSize: 16,
                ),
              ),
             
              SizedBox(height: 10),
              Text(
                'UPI ID: $upiid',
                style: TextStyle(
                  fontFamily: 'Poppins', // Use Poppins font
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Contact Number: $contactnumber',
                style: TextStyle(
                  fontFamily: 'Poppins', // Use Poppins font
                  fontSize: 16,
                ),
              ),
             
              
          
              // Mark Occupied Button
              ElevatedButton(
                onPressed: () async {
                  // Switch back to map view
                  final Uri url = Uri(scheme: 'tel', path: contactnumber.toString());
                  if(await canLaunchUrl(url))
                  {
                    await launchUrl(url);
                  }

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Red for marking occupied
                ),
                child: Text('Call', style: TextStyle(color: Colors.white),),
              ),
          
              SizedBox(height: 20),
          
              // Show on Map Button
              ElevatedButton(
                onPressed: () {
                  // Navigate back to the map view and center the camera on the marker
                  mapController.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(latitude, longitude),
                      15.0, // Zoom level
                    ),
                  ); // Focus on the marker on the map
                  Navigator.pop(context); // Close the details screen
                  onShowMapPressed(); // Switch to map view using the callback function
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


