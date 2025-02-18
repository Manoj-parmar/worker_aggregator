import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../style.dart'; // Import your style.dart file
import '../user_details_page.dart';
import 'wk_home_page.dart';
import 'wk_job_history.dart';
import 'wk_message_page.dart'; // Import your UserDetailsPage

int _acurrentIndex = 0;

class WorkerAccountPage extends StatefulWidget {
  WorkerAccountPage({Key? key}) : super(key: key);
  // Declare _currentIndex variable to keep track of the selected tab
  // int _currentIndex = 0;

  @override
  _WorkerAccountPageState createState() => _WorkerAccountPageState();
}

class _WorkerAccountPageState extends State<WorkerAccountPage> {
  String? userName;
  String? userEmail;
  String userPhotoURL = 'assets/user.png';

  @override
  void initState() {
    super.initState();
    // Fetch the user's name and email from Firebase when the page loads
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Get the current user's ID from FirebaseAuth
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the Firestore collection containing user data
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Fetch user details from Firestore using the user's ID
      DocumentSnapshot userDoc = await users.doc(userId).get();

      // Check if the document exists
      if (userDoc.exists) {
        // Populate the name and email from the document
        setState(() {
          userName = userDoc['name'];
          userEmail = userDoc['email'];
        });
      } else {
        // Handle the case where the user document does not exist
        setState(() {
          userName = 'N/A';
          userEmail = 'N/A';
        });
      }
    } catch (e) {
      // Handle errors and show an error message
      setState(() {
        userName = 'N/A';
        userEmail = 'N/A';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user details: $e')),
      );
    }
  }

  void navigateToUserDetailsPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsPage(),
      ),
    );

    if (result != null && result is Map<String, String>) {
      // Update the user's name and email if they were changed in UserDetailsPage
      setState(() {
        userName = result['name'];
        userEmail = result['email'];
      });
    }
  }

  Widget _buildUserInfoTile(String label, String? value) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(
          label,
          style: AppStyles.textFieldLabel,
        ),
        subtitle: GestureDetector(
          onTap: () {
            // Navigate to UserDetailsPage when tapping on the email
            navigateToUserDetailsPage();
          },
          child: Text(
            value ?? 'N/A', // Display 'N/A' if value is null
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    // Handle navigation when a tab is tapped
    setState(() {
      _acurrentIndex = index;
    });

    switch (index) {
      case 0:
        // Navigate to Jobs page
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WorkerHomePage(),
        ));
        break;
      case 1:
        // Navigate to Messages page
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WorkerMessagePage(),
        ));
        break;
      case 2:
        // Navigate to Post Job page
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WorkerJobHistoryPage(),
        ));
        break;
      case 3:
        // Navigate to Profile page
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WorkerAccountPage(),
        ));
        break;
    }
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login page with a new session
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AuthenticationPage()),
        (Route<dynamic> route) => false, // Flush the navigation routes
      );
    } catch (e) {
      print('Error logging out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Account',
          style: AppStyles.appBarTitle,
        ),
        backgroundColor: AppStyles.appBarColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(userPhotoURL),
                backgroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            _buildUserInfoTile('Name', userName),
            SizedBox(height: 8),
            _buildUserInfoTile('Email', userEmail),
            SizedBox(height: 20),
            Text(
              'Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: () {
                // Handle navigation to the help page
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Us'),
              onTap: () {
                // Handle navigation to the about us page
              },
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text('FAQs'),
              onTap: () {
                // Handle navigation to the FAQs page
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3, // Set the current index
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'WJobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'WRequests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'WJob History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'WProfile',
          ),
        ],
        selectedItemColor: AppStyles.appBarColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: onTabTapped, // Handle tab tap
      ),
    );
  }
}
