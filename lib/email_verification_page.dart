import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'worker/wk_home_page.dart';
import 'employer/ep_home_page.dart';
import 'style.dart'; // Import the style.dart file

class EmailVerificationPage extends StatefulWidget {
  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  String? userType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text(
          'Phone / Email Verification',
          style: AppStyles.appBarTitle, // Apply app bar title style
        ),
        backgroundColor: AppStyles.appBarColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Select your user type:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black, // Apply specific styles here if needed
                ),
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: userType,
                onChanged: (value) {
                  setState(() {
                    userType = value;
                  });
                },
                items: [
                  const DropdownMenuItem(
                    value: 'worker',
                    child: Text('Worker'),
                  ),
                  const DropdownMenuItem(
                    value: 'employer',
                    child: Text('Employer'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Check if the user has verified their email
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null && !user.emailVerified) {
                    // Reload the user to get the latest email verification status
                    await user.reload();
                    user = FirebaseAuth.instance.currentUser;
                  }

                  if (user != null && user.emailVerified) {
                    // Email is verified, navigate to the home page based on user type
                    if (userType == 'worker') {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => WorkerHomePage()),
                      );
                    } else if (userType == 'employer') {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => EmployerHomePage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a user type.'),
                        ),
                      );
                    }
                  } else {
                    // Email is not verified, show a message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email not yet verified.'),
                      ),
                    );
                  }
                },
                style: AppStyles.primaryButtonStyle, // Apply button style
                child: const Text('Check Verification'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
