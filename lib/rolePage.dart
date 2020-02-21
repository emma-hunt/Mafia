import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class RolePageArguments {
  final String playerName;
  final String playerID;
  final String gameID;
  final List<dynamic> playerList;

  RolePageArguments(this.playerName, this.playerID, this.gameID, this.playerList);
}

class RolePage extends StatefulWidget {
  final RolePageArguments args;

  RolePage({this.args});

  @override
  _RolePageState createState() => _RolePageState();

}

class _RolePageState extends State<RolePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text("Game Has Started!"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
          child: Text('Return Home'),
        ),
      )
    );
  }

}