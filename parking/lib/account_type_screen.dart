import 'package:flutter/material.dart';
import 'parking_owner_details.dart';
import 'parking_seeker_details.dart';

class AccountTypeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF2ED0C2)), // Back button color
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: 0.5, // Adjust progress value
              backgroundColor: Color(0xFFD1ECE9), // Background color for progress bar
              color: Color(0xFF2ED0C2), // Progress bar color
              minHeight: 4,
            ),
            SizedBox(height: 20),
            Text(
              "What type of account would you like to create?",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2ED0C2), // Title text color
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            _buildOption(context, "Parking Owner", Icons.person, Color(0xFF2ED0C2), _navigateToMentorDetails),
            SizedBox(height: 8),
            _buildOption(context, "Parking Seeker", Icons.person_outline, Color(0xFF2ED0C2), _navigateToMenteeDetails),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, String title, IconData icon, Color color, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color.withOpacity(0.1), // Background color with opacity
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30), // Icon color
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: color, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMentorDetails(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => MentorDetailsScreen()));
  }

  void _navigateToMenteeDetails(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => MenteeDetailsScreen()));
  }
}
