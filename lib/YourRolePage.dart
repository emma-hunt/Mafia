import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mafia_app/createJoinGame.dart';

class YourRolePage extends StatefulWidget {
  @override
  _YourRolePage createState() => _YourRolePage();
}

class _YourRolePage extends State<YourRolePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Role"),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                'You are the:',
                style: TextStyle(fontSize: 20.0),
              ),
              padding: EdgeInsets.fromLTRB(0.0, 30.0, 0, 0),
            ),
            Expanded(
              child: Container(
                alignment: Alignment(0.0, 0.0),
                child: Text("THE ROLE", 
                style: TextStyle(fontSize: 20.0),),
              ),
            ),
            Text("ROLE DESCIRPTION", 
                style: TextStyle(fontSize: 20.0),),
            RaisedButton(
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "take you to next screen",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
             //padding : EdgeInsets.fromLTRB(0, 0, 0, 200)
            )
          ],
        )));
  }
}
