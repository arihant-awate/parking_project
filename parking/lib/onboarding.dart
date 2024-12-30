import 'package:flutter/material.dart';
import 'package:parking/account_type_screen.dart';

import 'package:parking/login_sreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// Import the LoginScreen

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  final List<OnboardingContent> contents = [
    OnboardingContent(
      image: 'assets/images/onboarding1.png',
      title: "Find Parking Instantly",
      description:
          "Easily find the nearest parking spots near you with just a tap.",
    ),
    OnboardingContent(
      image: 'assets/images/onboarding2.png',
      title: "Real-Time Availability",
      description:
          "Get up-to-date information on available parking spaces, ensuring you never waste time.",
    ),
    OnboardingContent(
      image: 'assets/images/onboarding3.png',
      title: "Seamless Booking",
      description:
          "Book your spot in advance and secure your parking with just a few clicks.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(contents[index].image), // Display the image
                      SizedBox(height: 20),
                      Text(
                        contents[index].title,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2ED0C2), // Title color
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        contents[index].description,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Description color
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmoothPageIndicator(
                  controller: _controller, // PageController
                  count: contents.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Color(0xFF2ED0C2), // Active dot color
                    dotColor: Color(0xFFD1ECE9), // Inactive dot color
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to AccountTypeScreen when "GET STARTED" is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AccountTypeScreen()), // Navigate to AccountTypeScreen
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF2ED0C2), // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text(
                    'GET STARTED',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Text color
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen()), // Navigate to AccountTypeScreen
                    );
                    // Navigate to LoginScreen when "I ALREADY HAVE AN ACCOUNT" is clicked
                  },
                  child: Text(
                    'I ALREADY HAVE AN ACCOUNT',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF2ED0C2), // Text button color
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}
