import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'wk_job_details_page.dart';
import '../style.dart';

class WorkerResultPage extends StatelessWidget {
  final String keyword;

  WorkerResultPage({required this.keyword});

  @override
  Widget build(BuildContext context) {
    print('Keyword: $keyword'); // Add this line to print the keyword
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results', style: AppStyles.appBarTitle),
        backgroundColor: AppStyles.appBarColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobPostings')
            .where('jobTitle')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Handle loading state
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            // Handle error state
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Handle no data state
            return Text('No job postings available.');
          }

          final List<DocumentSnapshot> matchedJobs =
              snapshot.data!.docs.where((doc) {
            final jobTitle = doc['jobTitle'].toString().toLowerCase();
            return jobTitle.contains(keyword.toLowerCase());
          }).toList();

        if (matchedJobs.isEmpty) {
            // If no matches found, display "No match found"
            return Center(
              child: Text(
                'No match found. 😞',
                style: TextStyle(
                  fontSize: 20, // Adjust the font size as needed
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: matchedJobs.length,
            itemBuilder: (context, index) {
              final jobData = matchedJobs[index].data() as Map<String, dynamic>;
              final job = JobPosting.fromJson(jobData);
              final jobTitle = job.jobTitle;
              final companyName = job.companyName;
              return ListTile(
                title: Text(jobTitle),
                subtitle: Text(companyName),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkerJobDetailsPage(
                        createrId: job.createrId,
                        jobId: job.jobId,
                        jobTitle: job.jobTitle,
                        companyName: job.companyName,
                        jobType: job.jobType,
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
              );
            },
          );
        },
      ),
    );
  }
}

class JobPosting {
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

  JobPosting({
    required this.createrId,
    required this.jobId,
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

  factory JobPosting.fromJson(Map<String, dynamic> json) {
    final jobId = json['jobId'];
    final createrId = json['createrId'];
    final jobTitle = json['jobTitle'];
    final companyName = json['companyName'];
    final jobDescription = json['jobDescription'];

    if (createrId == null ||
        jobId == null ||
        jobTitle == null ||
        companyName == null ||
        jobDescription == null) {
      throw ArgumentError("Required fields missing in JSON data");
    }

    return JobPosting(
      createrId: createrId,
      jobId: jobId,
      jobTitle: jobTitle,
      companyName: companyName,
      jobType: json['jobType'] ?? '',
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
