import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class MafiaRolePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MafiaRolePageState();
  }
}

class _MafiaRolePageState extends State<MafiaRolePage> {
  String otherMafiaPlayerName = "loading...";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mafia Role Page',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mafia Role'),
        ),
        body: Center(
          child: Text(this.otherMafiaPlayerName),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getOtherMafiaMemberName();
  }

  void getOtherMafiaMemberName() async {

    String url = "https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/role/friends";
    String body = '{"personId": "1", "gameId": "1", "role": "mafia"}';

    final response = await http.put(url, body: body);
    if (response.statusCode == 200) {
      print("getOtherMafiaMemberName: " + response.statusCode.toString());
      print(response.body.toString());
      List<dynamic> friends = jsonDecode(response.body)["friends"];

      String otherMafiaPlayerName = "";
      if (friends.length < 1) {
        otherMafiaPlayerName = "You are the only Mafia!";

      } else {
        otherMafiaPlayerName = friends[0];
      }

      setState(() {
        this.otherMafiaPlayerName = otherMafiaPlayerName;
      });

    }
    else {
      print(response.statusCode);
      print(response.body.toString());
      throw Exception('ERROR: getOtherMafiaMemeberName failed.');
    }
  }
}