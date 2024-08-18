import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class EmployerJobDetailsPage extends StatefulWidget {
  final QueryDocumentSnapshot jobPosting;

  EmployerJobDetailsPage({required this.jobPosting});

  @override
  _EmployerJobDetailsPageState createState() => _EmployerJobDetailsPageState();
}

class _EmployerJobDetailsPageState extends State<EmployerJobDetailsPage> {
  late TextEditingController _jobIdController;
  late TextEditingController _jobTitleController;
  late TextEditingController _companyNameController;
  late TextEditingController _locationController;
  late TextEditingController _jobDescriptionController;
  late TextEditingController _experienceController;
  late TextEditingController _qualificationController;
  late TextEditingController _languageController;
  late TextEditingController _jobTimingController;
  late TextEditingController _jobAddressController;
  late TextEditingController _jobTypeController; // Added controller for JobType

  @override
  void initState() {
    super.initState();
    _jobIdController = TextEditingController(text: widget.jobPosting['jobId']);
    _jobTitleController =
        TextEditingController(text: widget.jobPosting['jobTitle']);
    _companyNameController =
        TextEditingController(text: widget.jobPosting['companyName']);
    _locationController =
        TextEditingController(text: widget.jobPosting['location']);
    _jobDescriptionController =
        TextEditingController(text: widget.jobPosting['jobDescription']);
    _experienceController =
        TextEditingController(text: widget.jobPosting['experience']);
    _qualificationController =
        TextEditingController(text: widget.jobPosting['qualification']);
    _languageController =
        TextEditingController(text: widget.jobPosting['language']);
    _jobTimingController =
        TextEditingController(text: widget.jobPosting['jobTiming']);
    _jobAddressController =
        TextEditingController(text: widget.jobPosting['jobAddress']);
    _jobTypeController = TextEditingController(
        text: widget.jobPosting['jobType']); // Initialize JobType controller
  }

  @override
  void dispose() {
    _jobIdController.dispose();
    _jobTitleController.dispose();
    _companyNameController.dispose();
    _locationController.dispose();
    _jobDescriptionController.dispose();
    _experienceController.dispose();
    _qualificationController.dispose();
    _languageController.dispose();
    _jobTimingController.dispose();
    _jobAddressController.dispose();
    _jobTypeController.dispose(); // Dispose JobType controller
    super.dispose();
  }

  void _saveJobPosting() {
    // Get the updated values from the text controllers
    String jobId = _jobIdController.text;
    String jobTitle = _jobTitleController.text;
    String companyName = _companyNameController.text;
    String location = _locationController.text;
    String jobDescription = _jobDescriptionController.text;
    String experience = _experienceController.text;
    String qualification = _qualificationController.text;
    String language = _languageController.text;
    String jobTiming = _jobTimingController.text;
    String jobAddress = _jobAddressController.text;
    String jobType = _jobTypeController.text; // Added job type

    // Create a map with the updated values
    Map<String, dynamic> updatedData = {
      'jobId': jobId,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'location': location,
      'jobDescription': jobDescription,
      'experience': experience,
      'qualification': qualification,
      'language': language,
      'jobTiming': jobTiming,
      'jobAddress': jobAddress,
      'jobType': jobType, // Added job type
    };

    // Update the document in the Firestore collection
    FirebaseFirestore.instance
        .collection('jobPostings')
        .doc(widget.jobPosting.id)
        .update(updatedData)
        .then((value) {
      // Job posting updated successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Job details saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    }).catchError((error) {
      // An error occurred while updating the job posting
      print('Error updating job posting: $error');
      // You can show a snackbar or display an error message here
    });
  }

  void _deleteJobPosting() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this job posting?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog and delete the job posting
                Navigator.of(context).pop();
                _performDelete();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _performDelete() {
    FirebaseFirestore.instance
        .collection('jobPostings')
        .doc(widget.jobPosting.id)
        .delete()
        .then((value) {
      // Job posting deleted successfully, navigate back
      Navigator.pop(context);
    }).catchError((error) {
      // An error occurred while deleting the job posting
      print('Error deleting job posting: $error');
      // You can show a snackbar or display an error message here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Job Details',
          style: AppStyles.appBarTitle,
        ),
        backgroundColor: AppStyles.appBarColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _jobIdController,
                decoration: InputDecoration(
                  labelText: 'Job ID',
                  filled: true,
                  fillColor: Colors.deepPurple[50],
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.red), // Change the color here
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey), // Change the color here
                  ),
                ),
                cursorColor: Colors.deepPurple,
              ),
              TextFormField(
                controller: _jobTitleController,
                decoration: InputDecoration(
                  labelText: 'Job Title',
                  filled: true,
                  fillColor: Colors.deepPurple[50],
                ),
              ),
              TextFormField(
                controller: _companyNameController,
                decoration: InputDecoration(
                  labelText: 'Company Name',
                  filled: true,
                  fillColor: Colors.deepPurple[50],
                ),
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  filled: true,
                  fillColor: Colors.deepPurple[50],
                ),
              ),
              TextFormField(
                controller: _jobDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Job Description',
                  filled: true,
                  fillColor: Colors.deepPurple[50],
                ),
                maxLines: null, // Allow multiple lines for description
              ),
              TextFormField(
                controller: _experienceController,
                decoration: InputDecoration(
                  labelText: 'Experience',
                  filled: true,
                  fillColor: Colors.deepPurple[50],
                ),
              ),
              TextFormField(
                controller: _qualificationController,
                decoration: InputDecoration(
                  labelText: 'Qualification',
                  filled: true,
                  fillColor: Colors.deepPurple[50],
                ),
              ),
              TextFormField(
                controller: _languageController,
                decoration: InputDecoration(
                  labelText: 'Language',
                  filled: true,
                  fillColor: Colors.deepPurple[50],
                ),
              ),
              TextFormField(
                controller: _jobTimingController,
                decoration: InputDecoration(
                  labelText: 'Job Timing',
                  filled: true,
                  fillColor: Colors.deepPurple[50],
                ),
              ),
              TextFormField(
                controller: _jobAddressController,
                decoration: InputDecoration(
                  labelText: 'Job Address',
                  filled: true,
                  fillColor: Colors.deepPurple[50],
                ),
              ),
              TextFormField(
                controller: _jobTypeController,
                decoration: InputDecoration(
                  // Add TextFormField for JobType
                  labelText: 'Job Type',
                  filled: true,
                  fillColor: Colors.deepPurple[50],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _saveJobPosting,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: _deleteJobPosting,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: Text('DELETE'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
