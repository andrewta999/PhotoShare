import 'package:flutter/material.dart';
import 'package:photoshare/widgets/header.dart';
import 'package:photoshare/widgets/progress.dart';

//Timeline page
class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

//Timeline page's states
class _TimelineState extends State<Timeline> {
  @override
  Widget build(context) {
    return Scaffold(
      //calls header() to get appBar widget
      appBar: header(context, isAppTitle: true),
      //calls linearProgress() to get linear progress widget
      body: linearProgress(),
    );
  }
}
