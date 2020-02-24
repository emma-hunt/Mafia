import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mafia_app/MafiaRoleStuff/argsClasses/soloMafiaRoleArgs.dart';


class SoloMafiaRole extends StatefulWidget {
  final SoloMafiaRoleArgs args;

  SoloMafiaRole({this.args});

  @override
  State<StatefulWidget> createState() {
    return _SoloMafiaRoleState();
  }
}

class _SoloMafiaRoleState extends State<SoloMafiaRole> {
  List<bool> isCenterButtonEnabled = [true, true, true];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solo Mafia Role Page',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Solo Mafia Role'),
        ),
        body: Center(
          child: Column(
            children: <Widget> [
              Text("You are the only mafia! Therefore you are priveledged with viewed one of the center cards! Choose one to continue"),
              _buildCenterCardButton(0),
              _buildCenterCardButton(1),
              _buildCenterCardButton(2),
              _buildContinueButton(),
            ]
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildContinueButton() {
    return RaisedButton(
      onPressed: this.isCenterButtonEnabled.every((e) => e) ? null : () {
        Navigator.pushReplacementNamed(context, '/');
        return;
      },
      child: Text("Continue"),
    );
  }

  Widget _buildCenterCardButton(int cardNumber) {
    return RaisedButton(
      onPressed: this.isCenterButtonEnabled[cardNumber] ? () => _centerButtonClicked(cardNumber) : null,
      child: Text("Center Card " + (cardNumber + 1).toString()), // plus 1 to convert card number from 0 based to 1 based
    );
  }

  void _centerButtonClicked(int cardNumber) {
    setState(() {
      for (int i = 0; i < 3; i++) {this.isCenterButtonEnabled[i] = true;}
      this.isCenterButtonEnabled[cardNumber] = false;
    });
  }
}