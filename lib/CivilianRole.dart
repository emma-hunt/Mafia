import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CivilianRolePage extends StatefulWidget {

  CivilianRolePage();

  @override
  _CivilianRolePageState createState() => _CivilianRolePageState();
}

class _CivilianRolePageState extends State<CivilianRolePage> {

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