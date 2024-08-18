import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mark_5/signup_form.dart';
import 'worker/wk_home_page.dart';
import 'employer/ep_home_page.dart';
import 'style.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late User? _user;

  @override
  void initState() {
    super.initState();
    // Check if user is already signed in
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _redirectUser();
    }
  }

  Future<void> _login() async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        setState(() {
          _user = userCredential.user;
        });
        _redirectUser();
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid email or password.'),
        ),
      );
    }
  }

  Future<String> _fetchUserRole(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        return userDoc['role'];
      } else {
        return '';
      }
    } catch (e) {
      print('Error fetching user role: $e');
      return '';
    }
  }

  void _redirectUser() async {
    String userRole = await _fetchUserRole(_user!.uid);
    if (userRole == 'worker') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => WorkerHomePage()),
      );
    } else if (userRole == 'employer') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => EmployerHomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid user role.'),
        ),
      );
    }
  }

  void _navigateToSignupPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SignupForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Log in',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          TextField(
            controller: _emailController,
            decoration: AppStyles.textFieldDecoration.copyWith(
              labelText: 'Email',
            ),
            cursorColor: Colors.deepPurple,
          ),
          SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            decoration: AppStyles.textFieldDecoration.copyWith(
              labelText: 'Password',
            ),
            cursorColor: Colors.deepPurple,
            obscureText: true,
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _login,
              style: AppStyles.primaryButtonStyle,
              child: Text('Log in',style: TextStyle(color: Colors.white),),

            ),
            widthFactor: 50,

          ),
          TextButton(
            onPressed: () => _navigateToSignupPage(), // Use anonymous function
            child: Text(
              'Signup',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
