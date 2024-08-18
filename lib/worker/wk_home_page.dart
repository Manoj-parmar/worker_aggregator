import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../style.dart';
import 'wk_account_page.dart';
import 'wk_job_details_page.dart';
import 'wk_job_history.dart';
import 'wk_message_page.dart';
import 'wk_result_page.dart';

class WorkerHomePage extends StatefulWidget {
  @override
  _WorkerHomePageState createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  int _selectedIndex = 0;
  late TextEditingController _searchController = TextEditingController();
  String? _selectedJobType;
  List<JobPosting> _filteredJobs = [];
  TextEditingController _pincodeController = TextEditingController();

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      switch (_selectedIndex) {
        case 0:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => WorkerHomePage()),
          );
          break;
        case 1:
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => WorkerMessagePage()),
          );
          break;
        case 2:
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => WorkerJobHistoryPage()),
          );
          break;
        case 3:
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => WorkerAccountPage()),
          );
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedJobType = null;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _searchJobs(String keyword) {
    // Perform search query on the jobPosting collection
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorkerResultPage(keyword: keyword),
      ),
    );
  }

  void _filterJobsByType(String jobType) {
    setState(() {
      _selectedJobType = jobType; // Update selected job type
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedJobType = null; // Clear selected job type
    });
  }

  void _filterJobsByLocation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Pincode'),
          content: TextField(
            controller: _pincodeController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: InputDecoration(
              hintText: 'Enter 6-digit Pincode',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Filter'),
              onPressed: () {
                Navigator.of(context).pop();
                _fetchAndFilterJobs(
                    _pincodeController.text); // Pass pincode to the method
              },
            ),
          ],
        );
      },
    );
  }

  void _fetchAndFilterJobs(String pincode) {
    setState(() {
      _selectedJobType = null;
    });

    FirebaseFirestore.instance
        .collection('jobPostings')
        .where('location', isEqualTo: pincode)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        _filteredJobs = querySnapshot.docs
            .map((DocumentSnapshot document) =>
                JobPosting.fromJson(document.data() as Map<String, dynamic>))
            .toList();
      });
    }).catchError((error) {
      print('Error fetching job postings: $error');
      // Handle error
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Home Page',
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
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.deepPurple,
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search Jobs',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              color: Colors.deepPurple,
                              onPressed: () {
                                _searchJobs(_searchController.text);
                              },
                            ),
                          ),
                          onSubmitted: (value) {
                            _searchJobs(value);
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.location_on),
                        color: Colors.deepPurple,
                        onPressed: _filterJobsByLocation,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterTag(
                    tag: 'Clear Filters',
                    isSelected: _selectedJobType == null,
                    onTap: _clearFilters,
                  ),
                  FilterTag(
                    tag: 'Home',
                    isSelected: _selectedJobType == 'Home',
                    onTap: () => _filterJobsByType('Home'),
                  ),
                  FilterTag(
                    tag: 'Construction',
                    isSelected: _selectedJobType == 'Construction',
                    onTap: () => _filterJobsByType('Construction'),
                  ),
                  FilterTag(
                    tag: 'Shop',
                    isSelected: _selectedJobType == 'Shop',
                    onTap: () => _filterJobsByType('Shop'),
                  ),
                  FilterTag(
                    tag: 'Outdoor',
                    isSelected: _selectedJobType == 'Outdoor',
                    onTap: () => _filterJobsByType('Outdoor'),
                  ),
                  FilterTag(
                    tag: 'Childcare',
                    isSelected: _selectedJobType == 'Childcare',
                    onTap: () => _filterJobsByType('Childcare'),
                  ),
                  FilterTag(
                    tag: 'Security',
                    isSelected: _selectedJobType == 'Security',
                    onTap: () => _filterJobsByType('Security'),
                  ),
                  FilterTag(
                    tag: 'Electrical',
                    isSelected: _selectedJobType == 'Electrical',
                    onTap: () => _filterJobsByType('Electrical'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _selectedJobType != null
                  ? FirebaseFirestore.instance
                      .collection('jobPostings')
                      .where('jobType', isEqualTo: _selectedJobType)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('jobPostings')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No job postings available.'));
                }

                if (_filteredJobs.isNotEmpty) {
                  return ListView.builder(
                    itemCount: _filteredJobs.length,
                    itemBuilder: (context, index) {
                      final job = _filteredJobs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.deepPurple[100],
                          child: ListTile(
                            title: Text(job.jobTitle),
                            subtitle: Text(job.companyName),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.of(context).push(
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
                          ),
                        ),
                      );
                    },
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final jobData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    final job = JobPosting.fromJson(jobData);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.deepPurple[100],
                        child: ListTile(
                          title: Text(job.jobTitle),
                          subtitle: Text(job.companyName),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.of(context).push(
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
        selectedItemColor: _getSelectedColor(_selectedIndex),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }

  Color _getSelectedColor(int index) {
    return index == _selectedIndex ? Colors.deepPurple : Colors.grey;
  }
}

class FilterTag extends StatelessWidget {
  final String tag;
  final bool isSelected;
  final VoidCallback? onTap;

  FilterTag({
    required this.tag,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.white30,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.deepPurple,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          tag,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
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
