import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mark_5/postjob_page.dart';
import 'package:mark_5/style.dart';

import 'account_page.dart';
import 'home_page.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  int _selectedIndex = 1; // Set the initial selected index to 1 (Messages)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: AppStyles.appBarTitle, // Use defined style
        ),
        backgroundColor: AppStyles.appBarColor, // Use defined color
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getJobApplicationsForUserB(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Display a loading indicator while fetching data
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final jobApplications = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: jobApplications.length,
            itemBuilder: (context, index) {
              final jobApplication = JobApplication.fromJson(
                jobApplications[index].data() as Map<String, dynamic>,
              );

              return ListTile(
                title: Text(
                  'New Job Application',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('From: ${jobApplication.applicantName}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle 'Accept' button tap
                        acceptJobApplication(jobApplication);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('Accept'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Handle 'Reject' button tap
                        rejectJobApplication(jobApplication);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('Reject'),
                    ),
                  ],
                ),
                onTap: () {
                  // Handle notification tap
                },
                contentPadding: EdgeInsets.all(16),
                tileColor: Colors.white,
                minVerticalPadding: 0,
                dense: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true, // Show labels for selected items
        showUnselectedLabels: true, // Show labels for unselected items
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.work,
              color: _selectedIndex == 0
                  ? AppStyles.appBarColor
                  : Colors.grey, // Change color based on selected index
            ),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              color: _selectedIndex == 1
                  ? AppStyles.appBarColor
                  : Colors.grey, // Change color based on selected index
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.post_add,
              color: _selectedIndex == 2
                  ? AppStyles.appBarColor
                  : Colors.grey, // Change color based on selected index
            ),
            label: 'Post Job',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _selectedIndex == 3
                  ? AppStyles.appBarColor
                  : Colors.grey, // Change color based on selected index
            ),
            label: 'Profile',
          ),
        ],
        selectedItemColor: AppStyles.appBarColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update selected index on tap
          });

          // Navigate to the corresponding page
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            // You are already on the Messages page, so no need to navigate.
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => PostJobPage()),
            );
          } else if (index == 3) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AccountPage()),
            );
          }
        },
      ),
    );
  }

  void acceptJobApplication(JobApplication jobApplication) {
    // Implement the logic for accepting the job application
  }

  void rejectJobApplication(JobApplication jobApplication) {
    // Implement the logic for rejecting the job application
  }

  Stream<QuerySnapshot> getJobApplicationsForUserB() {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      return FirebaseFirestore.instance
          .collection('jobApplications')
          .where('status', isEqualTo: 'pending')
          .where('applicantId', isEqualTo: currentUser.uid)
          .snapshots();
    } else {
      // Return an empty stream if the user is not authenticated
      return Stream.empty();
    }
  }
}

class JobApplication {
  final String applicantName;

  JobApplication({required this.applicantName});

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(applicantName: json['applicantName'] ?? '');
  }
}
