// import 'dart:js';

import 'package:flutter/material.dart';

class AppStyles {
  static final TextStyle appBarTitle = TextStyle(
    color: Colors.white,
    fontSize: 24,
  );

  static final Color appBarColor = Colors.deepPurple;

  static final TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );

  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.deepPurple,
    textStyle: buttonTextStyle,

  );

  static final ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.deepPurple, textStyle: buttonTextStyle,
  );

  static final TextStyle textFieldLabel = TextStyle(
    color: Colors.black, // You can customize the color
    fontSize: 16, // You can customize the font size
  );

  static final InputDecoration textFieldDecoration = InputDecoration(
    labelStyle: TextStyle(
      color: Colors.deepPurple, // Change the label (hint) text color
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.deepPurple, // Change the border color when focused
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.deepPurple, // Change the border color when not focused
      ),
    ),
    // contentPadding: EdgeInsets.symmetric(
    //   horizontal: 16.0, // Set the horizontal padding to 16 pixels
    //   vertical: 10.0, //Vertical padding (adjust as needed)
    // ),
    contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
  );
}
