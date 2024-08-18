import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../style.dart';

class WorkerJobDetailsPage extends StatelessWidget {
  final String createrId;
  final String jobId;
  final String jobTitle;
  final String companyName;
  final String jobType;
  final String location;
  final String jobDescription;
  final String experience;
  final String qualification;
  final String language;
  final String jobTiming;
  final String jobAddress;
  // final String receiverId; // ID of the employer who posted the job

  WorkerJobDetailsPage({
    required this.createrId,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.jobDescription,
    required this.experience,
    required this.qualification,
    required this.language,
    required this.jobTiming,
    required this.jobAddress,
    required this.jobType,
    //  required this.receiverId,
  });

  void handleApplyButton(BuildContext context) async {
    try {
      // Get the current user
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Create a request document with details
        await FirebaseFirestore.instance.collection('requests').add({
          'senderId': currentUser.uid,
          'receiverId': createrId, // ID of the employer
          'jobId': jobId,
          'status': 'PENDING',
          // Add other details as needed
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request sent successfully')),
        );
      }
    } catch (e) {
      // Handle errors
      print('Error sending request: $e');
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send request: $e')),
      );
    }
  }

  Future<void> _showContactDialog(BuildContext context) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(createrId)
          .get();
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      String name = userData['name'] ?? '';
      String phoneNumber = userData['phoneNumber'] ?? '';
      String email = userData['email'] ?? '';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Contact Information'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: $name'),
                SizedBox(height: 8),
                Text('Phone Number: $phoneNumber'),
                SizedBox(height: 8),
                Text('Email: $email'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error fetching contact information: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch contact information')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Job Details..',
          style: AppStyles.appBarTitle,
        ),
        backgroundColor: AppStyles.appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              jobTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                'Company :   $companyName',
                style: AppStyles.textFieldLabel,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                'Job Type : $jobType',
                style: AppStyles.textFieldLabel,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                'Location : $location',
                style: AppStyles.textFieldLabel,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                'Experience : $experience',
                style: AppStyles.textFieldLabel,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                'Qualification : $qualification',
                style: AppStyles.textFieldLabel,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                'Language : $language',
                style: AppStyles.textFieldLabel,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                'Job Timing : $jobTiming',
                style: AppStyles.textFieldLabel,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                'Job Address : $jobAddress',
                style: AppStyles.textFieldLabel,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Job Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              jobDescription,
              style: AppStyles.textFieldLabel,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => handleApplyButton(context),
                style: AppStyles.primaryButtonStyle,
                child: const Text('Apply',style: TextStyle(color: Colors.white),),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showContactDialog(context),
                style: AppStyles.primaryButtonStyle,
                child: const Text('Contact',style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
