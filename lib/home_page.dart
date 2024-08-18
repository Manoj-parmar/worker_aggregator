import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mark_5/postjob_page.dart';
import 'account_page.dart';
import 'job_details_page.dart';
import 'message_page.dart';
import 'style.dart'; // Import the style.dart file

class HomePage extends StatelessWidget {
  String pageTitle = " Home Page ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          pageTitle,
          style: AppStyles.appBarTitle,
        ),
        backgroundColor: AppStyles.appBarColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText:
                          'Search Jobs', // Add the search icon (\u{1F50D})
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Add horizontal scroll
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterTag(tag: 'Home'),
                  FilterTag(tag: 'Construction'),
                  FilterTag(tag: 'Outdoor'),
                  FilterTag(tag: 'Shop'),
                  FilterTag(tag: 'Childcare'),
                  FilterTag(tag: 'Security'),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              //This line establishes a connection to Firebase Firestore and retrieves a stream of snapshots representing the documents in the 'jobPostings' collection. Each snapshot reflects the current state of the collection
              stream: FirebaseFirestore.instance
                  .collection('jobPostings')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Display a loading indicator while fetching data
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text(
                      'No job postings available.'); // Display a message if no data is available
                }
                // Display job postings using a ListView.builder or any other widget
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final jobData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    final job = JobPosting.fromJson(jobData);//Converts the map into a JobPosting object (you'll need to define this class in your application).


                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        title: Text(job.jobTitle),
                        subtitle: Text(job.companyName),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => JobDetailsPage(
                                jobId: job.jobId, // Pass jobId here
                                jobTitle: job.jobTitle,
                                companyName: job.companyName,
                                location: job.location,
                                jobDescription: job.jobDescription,
                                experience: job.experience,
                                qualification: job.qualification,
                                language: job.language,
                                jobTiming: job.jobTiming,
                                jobAddress: job.jobAddress,
                              ),
                            ),
                          );
                        },
                        contentPadding: EdgeInsets.all(16),
                        tileColor: Colors.white,
                        minVerticalPadding: 0,
                        dense: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
            //  backgroundColor: Colors.red,
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
        onTap: (index) {
          if (index == 1) {
            // Navigate to the MessagePage when the message icon is tapped
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MessagePage()),
            );
          }
          if (index == 2) {
            // Navigate to the PostJobPage when the post job icon is tapped
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PostJobPage()),
            );
          }
          if (index == 3) {
            // Navigate to the ProfilePage when the profile icon is tapped
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AccountPage()),
            );
          }
        },
      ),
    );
  }
}

class FilterTag extends StatelessWidget {
  final String tag;

  FilterTag({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(tag),
    );
  }
}

class JobPosting {
  final String jobId; // Add jobId field
  final String jobTitle;
  final String companyName;
  final String location; // Add location field
  final String jobDescription;
  final String experience; // Add experience field
  final String qualification; // Add qualification field
  final String language; // Add language field
  final String jobTiming; // Add jobTiming field
  final String jobAddress; // Add jobAddress field

  JobPosting({
    required this.jobId, // Include jobId in the constructor
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.jobDescription,
    required this.experience,
    required this.qualification,
    required this.language,
    required this.jobTiming,
    required this.jobAddress,
  });

  factory JobPosting.fromJson(Map<String, dynamic> json) {
    final jobId = json['jobId']; // Retrieve jobId from JSON

    final jobTitle = json['jobTitle'];
    final companyName = json['companyName'];
    final jobDescription = json['jobDescription'];

    if (jobId == null ||
        jobTitle == null ||
        companyName == null ||
        jobDescription == null) {
      throw ArgumentError("Required fields missing in JSON data");
    }

    return JobPosting(
      jobId: jobId,
      jobTitle: jobTitle,
      companyName: companyName,
      location: json['location'] ?? '',
      jobDescription: jobDescription,
      experience: json['experience'] ?? '',
      qualification: json['qualification'] ?? '',
      language: json['language'] ?? '',
      jobTiming: json['jobTiming'] ?? '',
      jobAddress: json['jobAddress'] ?? '',
    );
  }
}
