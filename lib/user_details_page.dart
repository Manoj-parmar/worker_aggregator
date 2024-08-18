import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'style.dart';

class UserDetailsPage extends StatefulWidget {
  UserDetailsPage({Key? key}) : super(key: key);

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  // String? selectedGender;
  TextEditingController ageController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  String? selectedRole; // New field for Worker/Employer
  String? selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    // Fetch the user's details from Firestore when the page loads
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      // Get the current user's ID from FirebaseAuth
      final User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Fetch user details from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        // Populate the text fields with the retrieved data
        setState(() {
          nameController.text = userDoc['name'] ?? '';
          emailController.text = userDoc['email'] ?? '';
          phoneNumberController.text = userDoc['phoneNumber'] ?? '';
          selectedGender = userDoc['gender'];
          ageController.text = userDoc['age'] ?? '';
          educationController.text = userDoc['education'] ?? '';
          bioController.text = userDoc['bio'] ?? '';
          selectedRole = userDoc['role']; // Fetch the role from Firestore
        });
      }
    } catch (e) {
      // Handle errors and show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user details: $e')),
      );
    }
  }

  void saveChanges() async {
    try {
      // Get the current user's ID from FirebaseAuth
      final User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Fetch user details from Firestore to get existing values
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        // Get existing values or use new values if they're not present
        String existingEmail = userDoc.exists ? userDoc['email'] ?? '' : '';
        String existingPhoneNumber =
            userDoc.exists ? userDoc['phoneNumber'] ?? '' : '';
        String existingRole = userDoc.exists ? userDoc['role'] ?? '' : '';

        // Update the user's details in Firestore with both existing and new values
        await _firestore.collection('users').doc(currentUser.uid).set({
          'userId': currentUser.uid, // Add userId field to store current UID
          'name': nameController.text,
          'email':
              existingEmail.isNotEmpty ? existingEmail : emailController.text,
          'phoneNumber': existingPhoneNumber.isNotEmpty
              ? existingPhoneNumber
              : phoneNumberController.text,
          'gender': selectedGender ?? '',
          'age': ageController.text,
          'education': educationController.text,
          'bio': bioController.text,
          'role': existingRole.isNotEmpty
              ? existingRole
              : selectedRole, // Preserve existing role if available
        });

        Navigator.pop(context,
            {'name': nameController.text, 'email': emailController.text});
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Changes saved successfully')),
        );
      }
    } catch (e) {
      // Handle errors and show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save changes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit User Details',
          style: AppStyles.appBarTitle,
        ),
        backgroundColor: AppStyles.appBarColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: AppStyles.textFieldLabel,
              ),
              TextFormField(
                controller: nameController,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  hintText: 'Enter your name',
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Email',
                style: AppStyles.textFieldLabel,
              ),
              TextFormField(
                controller: emailController,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Phone Number',
                style: AppStyles.textFieldLabel,
              ),
              TextFormField(
                controller: phoneNumberController,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  hintText: 'Enter your phone number',
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Gender',
                style: AppStyles.textFieldLabel,
              ),
              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  hintText: 'Select gender',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Male', // Ensure this value is unique
                    child: Text('Male'),
                  ),
                  DropdownMenuItem(
                    value: 'Female', // Ensure this value is unique
                    child: Text('Female'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Role',
                style: AppStyles.textFieldLabel,
              ),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  hintText: 'Select role',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'worker', // Ensure this value is unique
                    child: Text('Worker'),
                  ),
                  DropdownMenuItem(
                    value: 'employer', // Ensure this value is unique
                    child: Text('Employer'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Age',
                style: AppStyles.textFieldLabel,
              ),
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  hintText: 'Enter your age',
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Education',
                style: AppStyles.textFieldLabel,
              ),
              TextFormField(
                controller: educationController,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  hintText: 'Enter your education',
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Bio',
                style: AppStyles.textFieldLabel,
              ),
              TextFormField(
                controller: bioController,
                maxLines: 4,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  hintText: 'Enter your bio',
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Container(
                  child: ElevatedButton(
                    onPressed: () {
                      // Call the function to save changes when the button is pressed
                      saveChanges();
                    },
                    style: AppStyles.primaryButtonStyle,
                    child: Center(child: Text('Save Changes',style: TextStyle(color: Colors.white),)),

                  ),
                  width: 200,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserDetailsPage(),
  ));
}
