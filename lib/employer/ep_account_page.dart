import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mark_5/employer/ep_home_page.dart';
import 'package:mark_5/employer/ep_message_page.dart';
import 'package:mark_5/postjob_page.dart';
//  import 'package:mark_5/login_form.dart';
import '../main.dart';
import '../style.dart';
import '../user_details_page.dart';

int _acurrentIndex = 0;

class EmployerAccountPage extends StatefulWidget {
  EmployerAccountPage({Key? key}) : super(key: key);

  @override
  _EmployerAccountPageState createState() => _EmployerAccountPageState();
}

class _EmployerAccountPageState extends State<EmployerAccountPage> {
  String? userName;
  String? userEmail;
  String userPhotoURL = 'assets/user.png';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userDoc = await users.doc(userId).get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'];
          userEmail = userDoc['email'];
        });
      } else {
        setState(() {
          userName = 'N/A';
          userEmail = 'N/A';
        });
      }
    } catch (e) {
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
            navigateToUserDetailsPage();
          },
          child: Text(
            value ?? 'N/A',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _acurrentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EmployerHomePage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EmployerMessagePage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PostJobPage(),
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
          'My Account..',
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
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Us'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text('FAQs'),
              onTap: () {},
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
        currentIndex: 3,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Edit Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Post Job',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: AppStyles.appBarColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: onTabTapped,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EmployerAccountPage(),
  ));
}
