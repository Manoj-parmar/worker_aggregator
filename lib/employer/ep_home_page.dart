import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../style.dart';
import 'ep_account_page.dart';
import 'ep_message_page.dart';
import '../postjob_page.dart';
import 'ep_job_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Employer Dashboard',
          style: AppStyles.appBarTitle,
        ),
        backgroundColor: AppStyles.appBarColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('jobPostings')
            .where('createrId', isEqualTo: currentUserUid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var jobPosting = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            EmployerJobDetailsPage(jobPosting: jobPosting),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(jobPosting['jobTitle']),
                        subtitle: Text(jobPosting['companyName']),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
            label: 'EProfile',
          ),
        ],
        selectedItemColor: AppStyles.appBarColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EmployerMessagePage()),
            );
          }
          if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PostJobPage()),
            );
          }
          if (index == 3) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EmployerAccountPage()),
            );
          }
        },
      ),
    );
  }
}
