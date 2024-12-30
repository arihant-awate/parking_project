import 'package:flutter/material.dart';
import 'package:parking/home_page.dart'; // Import your HomePage or next screen
import 'package:supabase/supabase.dart'; // Import Supabase client
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase client
import 'user_model.dart'; // Import the UserModel

class MentorDetailsScreen extends StatefulWidget {
  @override
  _MentorDetailsScreenState createState() => _MentorDetailsScreenState();
}

class _MentorDetailsScreenState extends State<MentorDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final SupabaseClient supabase =
      Supabase.instance.client; // Initialize Supabase client

  Future<void> _storeMentorDetails() async {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      // Check if the username already exists in the parking_users table

      // Insert new mentor details with is_owner set to true
      final response = await supabase.from('parking_users').insert({
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'password': password, // Hash the password in a real app
        'is_owner': true, // Set the user as a parking owner
      });
      // Use execute() to get the full response

      if (response != null) {
        // If there's an error in storing the details
        print('Error inserting data: ${response}'); // Log error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response}')),
        );
      } else {
        // Store the user details in the UserModel
        UserModel.setUser(
          UserModel(
            firstName: firstName,
            lastName: lastName,
            username: username,
            userType: 'owner', // or 'seeker'
          ),
        );

        UserModel? user = UserModel.currentUser;

        if (user != null) {
          print('First Name: $firstName');
          print('Last Name: $lastName');
          print('Username: $username');
          print('User Type: owner');
        }

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage()), // Navigate to HomePage
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Parking Owner Account created successfully!')),
        );

        // After successful registration or login, navigate to the HomePage
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF2ED0C2)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearProgressIndicator(
                  value: 0.75, // Adjust progress value
                  backgroundColor: Colors.grey.shade300,
                  color: Color(0xFF2ED0C2), // Progress bar color
                  minHeight: 4,
                ),
                SizedBox(height: 20),
                Text(
                  "Create a Parking Owner Account",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2ED0C2), // Title color
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  "Please complete your profile. Your data will remain private.",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                _buildTextField(
                  label: "First Name",
                  controller: _firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: "Last Name",
                  controller: _lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: "Username",
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: "Password",
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _storeMentorDetails, // Call the UI method here
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2ED0C2), // Button color
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Text color
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF2ED0C2)), // Border color
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF2ED0C2)), // Border color
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF2ED0C2)), // Border color
            ),
          ),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
