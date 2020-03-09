import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VotePage extends StatefulWidget {

  VotePage();

  @override
  State<StatefulWidget> createState() {
    return _VotePageState();
  }
}

class _VotePageState extends State<VotePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vote'),
      ),
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Container(
                padding: EdgeInsets.all(50),
                child: Text("Time to vote!"),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                  ]
              ),
            ]),
      ),
    );
  }
}