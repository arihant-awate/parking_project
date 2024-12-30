import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/parking_details_for_seekers.dart';
import 'package:parking/parking_details_screen.dart'; // Import the screen to add parking details
import 'package:supabase/supabase.dart'; // Import Supabase client
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase client
import 'user_model.dart'; // Import the UserModel to access the current user

const LatLng currentLocation =
    LatLng(20.012611553440287, 73.82136144669424); // Set the location to Pune

class HomePageForSeekers extends StatefulWidget {
  const HomePageForSeekers({super.key});

  @override
  State<HomePageForSeekers> createState() => _HomePageForSeekersState();
}

class _HomePageForSeekersState extends State<HomePageForSeekers> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {}; // To hold the markers (pins)
  LatLng? _selectedLocation; // To store the selected location
  bool isEditMode = false; // Flag to toggle between edit mode and view mode

  // State to track selected page (map or list)
  int _selectedIndex = 0;

  // Custom map style to make roads thinner
  final String _mapStyle = '''
[
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "weight": 0.5  // Thinner roads
      }
    ]
  }
]
  ''';
  void initState() {
    super.initState();
    _loadUserParkingSpots(); // Load parking spots on initial load
  }

  // Function to round the latitude and longitude to 2 decimal places
  LatLng _roundCoordinates(LatLng position) {
    double roundedLatitude = double.parse(position.latitude.toStringAsFixed(2));
    double roundedLongitude =
        double.parse(position.longitude.toStringAsFixed(2));
    return LatLng(roundedLatitude, roundedLongitude);
  }

  // Function to handle tapping on the map
  void _onTap(LatLng position) async {
    print("Tapped at position: $position"); // Debug: Tapped location

    if (isEditMode) {
      setState(() {
        _selectedLocation = position;
        LatLng roundedPosition =
            _roundCoordinates(position); // Round coordinates to 2 decimals
        _markers.add(
          Marker(
            markerId: MarkerId(roundedPosition
                .toString()), // Use the rounded position as a unique identifier
            position: roundedPosition,
            infoWindow: InfoWindow(title: "Parking Spot"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet, // Set color
            ), // You can customize the title
          ),
        );
      });
      print("Marker added at: $position"); // Debug: Marker added
    } else {
      // In view mode, directly query Supabase when a location is tapped
      print(
          "In view mode, fetching details from Supabase for position: $position");

      LatLng roundedPosition =
          _roundCoordinates(position); // Round coordinates to 2 decimals

      final response = await Supabase.instance.client
          .from('parking_spots')
          .select()
          .eq('latitude', roundedPosition.latitude)
          .eq('longitude', roundedPosition.longitude)
          .single(); // Expecting a single result

      if (response != null) {
        print(
            "Parking spot details fetched: ${response}"); // Debug: Data fetched
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ParkingDetailsScreenForSeekers(
              parkingName: response['parking_name'],
              description:
                  response['description'] ?? 'No description available',
              latitude: response['latitude'],
              longitude: response['longitude'],
              mapController: _mapController,
              watchmanName: response['watchman_name'],
              layout: response['layout'],
              spotSize: response['spot_size'],
              accessibility: response['accessibility'],
              lighting: response['lighting'],
              
              upiid: response['upi_id'],
              contactnumber: response['contact_number'],
              isAvailable: response['available'],
              onShowMapPressed: () {
                // Switch to map view and update selected index
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
          ),
        );
      } else {
        print("Error fetching parking details: ${response}"); // Debug: Error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Parking details not found!')),
        );
      }
    }
  }

  Future<void> _loadUserParkingSpots() async {
    final response = await Supabase.instance.client
        .from('parking_spots')
        .select();
         // Filter by current user's username

    if (response != null) {
      // Loop through the results and add markers for each parking spot
      for (var spot in response) {
        final LatLng position = LatLng(spot['latitude'], spot['longitude']);
        bool isAvailable = true;

        

        
             // Assuming is_available is a boolean

        // Set the marker color based on the availability
        Color markerColor = isAvailable ? Color(0xFF2ED0C2) : Colors.red;

        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(spot['parking_name']),
              position: position,
              infoWindow: InfoWindow(
                title: spot['parking_name'],
                snippet: spot['description'] ?? 'No description available',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                isAvailable
                    ? BitmapDescriptor.hueViolet
                    : BitmapDescriptor.hueRed, // Set color
              ),
            ),
          );
        });
      }
    } else {
      print("Error loading parking spots: ${response}");
    }
  }

  // Function to save parking spot to Supabase
  Future<void> _saveParkingSpot() async {
    if (_selectedLocation != null) {
      print(
          "Preparing to save parking spot at: ${_selectedLocation!}"); // Debug: Preparing to save

      LatLng roundedLocation = _roundCoordinates(
          _selectedLocation!); // Round coordinates to 2 decimals

      // Show a dialog to enter parking details
      final parkingNameController = TextEditingController();
      final descriptionController = TextEditingController();
      final watchmanController = TextEditingController();
      final layoutController = TextEditingController();
      final spotSizeController = TextEditingController();
      final accessibilityController = TextEditingController();
      final lightingController = TextEditingController();
      final surveillanceController = TextEditingController();
      final upiid = TextEditingController();
      final contactnumber = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter Parking Details'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: parkingNameController,
                    decoration: InputDecoration(labelText: 'Parking Name'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  TextField(
                    controller: watchmanController,
                    decoration: InputDecoration(labelText: 'Watchman Name'),
                  ),
                  TextField(
                    controller: layoutController,
                    decoration: InputDecoration(labelText: 'Layout'),
                  ),
                  TextField(
                    controller: spotSizeController,
                    decoration: InputDecoration(labelText: 'Spot Size'),
                  ),
                  TextField(
                    controller: accessibilityController,
                    decoration: InputDecoration(
                        labelText: 'Accessibility (true/false)'),
                  ),
                  TextField(
                    controller: lightingController,
                    decoration:
                        InputDecoration(labelText: 'Lighting (true/false)'),
                  ),
                  TextField(
                    controller: surveillanceController,
                    decoration:
                        InputDecoration(labelText: 'Surveillance (true/false)'),
                  ),
                  TextField(
                    controller: upiid,
                    decoration: InputDecoration(labelText: 'UPI ID'),
                  ),
                  TextField(
                    controller: contactnumber,
                    decoration: InputDecoration(labelText: 'Contact Number'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  // Insert parking details into Supabase
                  final response = await Supabase.instance.client
                      .from('parking_spots')
                      .insert({
                    'latitude': roundedLocation.latitude,
                    'longitude': roundedLocation.longitude,
                    'parking_name': parkingNameController.text,
                    'description': descriptionController.text,
                    'watchman_name': watchmanController.text,
                    'layout': layoutController.text,
                    'spot_size': spotSizeController.text,
                    'accessibility':
                        accessibilityController.text,
                    'lighting': lightingController.text,
                   
                    'username': UserModel.currentUser!.username,
                    'contact_number': contactnumber.text,
                    'upi_id': upiid.text // Store the username
                  });

                  if (response.error == null) {
                    print("Parking spot saved successfully!"); // Debug: Success
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Parking spot saved!')));
                  } else {
                    print(
                        "Error saving parking spot: ${response.error!.message}"); // Debug: Error
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Error: ${response.error!.message}')));
                  }
                },
                child: Text('Save'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }
  }

  // Toggle between edit and view mode
  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
    print(isEditMode
        ? "Switched to Edit Mode"
        : "Switched to View Mode"); // Debug: Mode toggled
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              isEditMode ? 'Switched to Edit Mode' : 'Switched to View Mode')),
    );
  }

  // Fetch all parking spots from Supabase for the current user
  Future<List<Map<String, dynamic>>> _fetchParkingSpots() async {
    final response = await Supabase.instance.client
        .from('parking_spots')
        .select();
        // Filter by current user's username

    if (response != null) {
      return List<Map<String, dynamic>>.from(response);
    } else {
      print("Error fetching parking spots: ${response}");
      return [];
    }
  }

  // Bottom navigation to switch between map and list view
  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page',
            style:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF2ED0C2), // AppBar color
        actions: [
          
        ],
      ),
      body: _selectedIndex == 0
          ? GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _mapController.setMapStyle(
                    _mapStyle); // Apply the custom style to make roads thinner
              },
              initialCameraPosition: const CameraPosition(
                target: currentLocation,
                zoom: 14.0, // Adjust the zoom level as needed
              ),
              markers: _markers, // Display markers
              onTap:
                  _onTap, // Call the onTap function when the user taps on the map
            )
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchParkingSpots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No parking spots available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final spot = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(spot['parking_name'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                spot['description'] ?? 'No description',
                                style: TextStyle(fontSize: 14)),
                            tileColor: Color(0xFFF0F0F0),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ParkingDetailsScreenForSeekers(
                                    parkingName: spot['parking_name'],
                                    description: spot['description'] ??
                                        'No description available',
                                    latitude: spot['latitude'],
                                    longitude: spot['longitude'],
                                    mapController: _mapController,
                                    watchmanName: spot['watchman_name'],
                                    layout: spot['layout'],
                                    spotSize: spot['spot_size'],
                                    accessibility: spot['accessibility'],
                                    lighting: spot['lighting'],
                                   
                                    upiid: spot['upi_id'],
                                    contactnumber: spot['contact_number'],
                                    isAvailable: spot['available'],
                                    onShowMapPressed: () {
                                      // Switch to map view and update selected index
                                      setState(() {
                                        _selectedIndex = 0;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Available',
          ),
        ],
      ),
     
      
    );
  }
}
