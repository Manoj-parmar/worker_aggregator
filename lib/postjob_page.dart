import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'style.dart';

class PostJobPage extends StatelessWidget {
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController jobTypeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController jobDescriptionController =
      TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController jobTimingController = TextEditingController();
  final TextEditingController jobAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post a Job',
          style: AppStyles.appBarTitle,
        ),
        backgroundColor: AppStyles.appBarColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: jobTitleController,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  labelText: 'Job Title',
                ),
                cursorColor: Colors.deepPurple,
              ),
              SizedBox(height: 8),
              TextField(
                controller: companyNameController,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  labelText: 'Company Name',
                ),
                cursorColor: Colors.deepPurple,
              ),
              SizedBox(height: 8),
              TextField(
                controller: jobTypeController,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  labelText: 'Job Type',
                ),
                cursorColor: Colors.deepPurple,
              ),
              SizedBox(height: 8),
              TextField(
                controller: locationController,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  labelText: 'Location',
                ),
                cursorColor: Colors.deepPurple,
              ),
              SizedBox(height: 8),
              TextField(
                controller: jobDescriptionController,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  labelText: 'Job Description',
                ),
                cursorColor: Colors.deepPurple,
                maxLines: 3,
              ),
              SizedBox(height: 8),
              TextField(
                controller: experienceController,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  labelText: 'Experience',
                ),
                cursorColor: Colors.deepPurple,
              ),
              SizedBox(height: 8),
              TextField(
                controller: qualificationController,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  labelText: 'Qualification',
                ),
                cursorColor: Colors.deepPurple,
              ),
              SizedBox(height: 8),
              TextField(
                controller: languageController,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  labelText: 'Language',
                ),
                cursorColor: Colors.deepPurple,
              ),
              SizedBox(height: 8),
              TextField(
                controller: jobTimingController,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  labelText: 'Job Timing',
                ),
                cursorColor: Colors.deepPurple,
              ),
              SizedBox(height: 8),
              TextField(
                controller: jobAddressController,
                decoration: AppStyles.textFieldDecoration.copyWith(
                  labelText: 'Job Address',
                ),
                cursorColor: Colors.deepPurple,
              ),
              SizedBox(height: 8),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser != null) {
                      final jobPosting = JobPosting(
                        createrId: currentUser.uid,
                        jobTitle: jobTitleController.text,
                        companyName: companyNameController.text,
                        jobType: jobTypeController.text,
                        location: locationController.text,
                        jobDescription: jobDescriptionController.text,
                        experience: experienceController.text,
                        qualification: qualificationController.text,
                        language: languageController.text,
                        jobTiming: jobTimingController.text,
                        jobAddress: jobAddressController.text,
                      );

                      final DocumentReference jobRef = await FirebaseFirestore
                          .instance
                          .collection('jobPostings')
                          .add(jobPosting.toJson());

                      final jobId = jobRef.id;

                      // Update the jobId in the jobPosting object
                      jobPosting.jobId = jobId;
                      // Update Firestore with the complete jobPosting object
                      await jobRef.update({'jobId': jobId});

                      // Clear all text controllers after posting the job
                      jobTitleController.clear();
                      companyNameController.clear();
                      jobTypeController.clear();
                      locationController.clear();
                      jobDescriptionController.clear();
                      experienceController.clear();
                      qualificationController.clear();
                      languageController.clear();
                      jobTimingController.clear();
                      jobAddressController.clear();
                    }
                  } catch (error) {
                    print('Error posting job: $error');
                  }
                },
                style: AppStyles.primaryButtonStyle,
                child: Text('Post Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JobPosting {
  String jobId = ''; // Remove 'late' keyword and assign a default value
  final String createrId;
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

  JobPosting({
    required this.createrId,
    required this.jobTitle,
    required this.companyName,
    required this.jobType,
    required this.location,
    required this.jobDescription,
    required this.experience,
    required this.qualification,
    required this.language,
    required this.jobTiming,
    required this.jobAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'createrId': createrId,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'jobType': jobType,
      'location': location,
      'jobDescription': jobDescription,
      'experience': experience,
      'qualification': qualification,
      'language': language,
      'jobTiming': jobTiming,
      'jobAddress': jobAddress,
    };
  }
}
