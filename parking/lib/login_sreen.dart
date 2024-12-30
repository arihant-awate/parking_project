import 'package:flutter/material.dart';
import 'package:parking/home_page_for_seekers.dart';
import 'package:supabase/supabase.dart';
import 'package:parking/home_page.dart'; // Import HomePage for owners
 // Import SeekerPage for non-owners
import 'package:parking/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // UserModel to store the user details

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final SupabaseClient supabase = Supabase.instance.client; // Initialize Supabase client

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Validate the form
    if (_formKey.currentState?.validate() ?? false) {
      try {
        print('Login attempt with username: $username and password: $password');

        // Query Supabase for the user with matching username and password
        final response = await supabase
            .from('parking_users')
            .select()
            .eq('username', username)
            .eq('password', password) // Make sure to hash the password in a real app
            .single(); // Expecting a single result

        if (response != null) {
          // Store user data in UserModel
          UserModel.setUser(UserModel(
            firstName: response['first_name'],
            lastName: response['last_name'],
            username: response['username'],
            userType: response['is_owner'] ? 'owner' : 'seeker', // Based on the is_owner flag
          ));

          // Check if the user is an owner or not
          if (response['is_owner']) {
            // If the user is an owner, navigate to HomePage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePageForSeekers()),
            );
            // If the user is not an owner, navigate to SeekerPage
            
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid username or password')),
          );
        }
      } catch (e) {
        print('Error during login: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF2ED0C2)), // Updated color
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Log in to your account",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2ED0C2), // Updated color
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
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
              Spacer(),
              ElevatedButton(
                onPressed: _login, // Call the login method here
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2ED0C2), // Updated color
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Log In',
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
              borderSide: BorderSide(color: Color(0xFF2ED0C2)), // Updated color
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF2ED0C2)), // Updated color
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF2ED0C2)), // Updated color
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
