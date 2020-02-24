import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mafia_app/MafiaRoleStuff/MafiaRolePageArgs.dart';


class MafiaRolePage extends StatefulWidget {
  final MafiaRolePageArgs args;

  MafiaRolePage({this.args});

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
    getOtherMafiaMemberName(widget.args);
  }

  void getOtherMafiaMemberName(MafiaRolePageArgs args) async {

    String url = "https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/role/friends";
    String body = '{"personId": "' + args.personId + '", "gameId": "' + args.gameId + '", "role": "mafia"}';
    print("url: " + url);
    print("body: " + body);
    final response = await http.put(url, body: body);
    if (response.statusCode == 200) {
      print("getOtherMafiaMemberName: " + response.statusCode.toString());
      print(response.body.toString());
      List<dynamic> friends = jsonDecode(response.body)["friends"];

      String otherMafiaPlayerName = "";
      if (friends.isEmpty) {
        otherMafiaPlayerName = "You are the only Mafia!";

      } else {
        otherMafiaPlayerName = "The other mafia member is: " + friends[0]; //will only ever be one other mafia or none other...
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