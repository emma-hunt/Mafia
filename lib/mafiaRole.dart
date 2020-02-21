import 'package:flutter/material.dart';

class MafiaRolePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mafia Role Page',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mafia Role'),
        ),
        body: Center(
          child: Text('Content goes here!'),
        ),
      ),
    );
  }
}