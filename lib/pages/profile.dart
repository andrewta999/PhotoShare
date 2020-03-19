import 'package:flutter/material.dart';
import 'package:photoshare/widgets/header.dart';

//Profile page
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

//Profile page's state
class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //get app bar widget
      appBar: header(context, titleText: "Profile"),
      //body widget
      body: Text("Profile"),
    );
  }
}
