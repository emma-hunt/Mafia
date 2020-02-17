import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mafia_app/createJoinGame.dart';

class ListRoles extends StatefulWidget {
  @override
  _ListRoles createState() => _ListRoles();
}

class _ListRoles extends State<ListRoles> {
  var playerRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Roles for this game"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/yourRolePage');
                      },
                      child: Text('Your Role'),
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      onPressed: () {
                        // Does nothing: stay on the same page
                        //Navigator.pushReplacementNamed(context, '/listRoles');
                        },
                      child: Text('Roles'),
                    ),
                  ),
                ],
              ),
            ]
          ),
        )
    );
  }
}
            