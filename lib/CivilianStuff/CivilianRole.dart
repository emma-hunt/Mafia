import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:mafia_app/CivilianStuff/CivilianRoleArgs.dart";
import 'package:fluttertoast/fluttertoast.dart';

class CivilianRole extends StatefulWidget {
  final CivilianRoleArgs args;

  CivilianRole({this.args});

  @override
  _CivilianRoleState createState() => _CivilianRoleState();
}

class _CivilianRoleState extends State<CivilianRole> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Civilian Role"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("You are a civilian!\nThis means you have nothing to do.\nExcept look like you are doing something :)"),
            FlatButton (
              color: Colors.red[900],
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.redAccent[700],
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text(
                "Continue",
              ),
            ),
          ],
        ),
      ),
    );
  }
}