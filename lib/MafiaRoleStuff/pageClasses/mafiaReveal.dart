import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mafia_app/MafiaRoleStuff/argsClasses/mafiaRevealArgs.dart';

class MafiaReveal extends StatefulWidget {
  final MafiaRevealArgs args;

  MafiaReveal({this.args});

  @override
  State<StatefulWidget> createState() {
    return _MafiaRevealState(args: args);
  }
}

class _MafiaRevealState extends State<MafiaReveal> {
  MafiaRevealArgs args;
  String roleToReveal = "loading...";

  _MafiaRevealState({this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mafia Reveal"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(this.roleToReveal),
              margin: EdgeInsets.all(30),
            ),
            _getContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _getContinueButton() {
    if (this.roleToReveal == "loading...") return CircularProgressIndicator();
    return FlatButton(
      color: Colors.red[900],
      textColor: Colors.white,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      padding: EdgeInsets.all(8.0),
      splashColor: Colors.redAccent[700],
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/');
        return;
      },
      child: Text('Continue'),
    );
  }

  @override
  void initState() {
    super.initState();
    _getRoleToReveal();
  }

  void _getRoleToReveal() async {
    String url = 'https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/role/mafia/' + this.args.gameId + '/' + (this.args.roleNum + 1).toString();

    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("getRoleToReveal : " + response.statusCode.toString() + " : " + response.body.toString());
      setState(() {
        this.roleToReveal = "The role is " + jsonDecode(response.body)["role"] + "!";
      });
    }
    else {
      print('Center Card Role Reveal API: ' + response.statusCode.toString());
      print(response.body.toString());
      setState(() {
        this.roleToReveal = 'ERROR: unable to retrieve center card role for solo mafia role/mafia reveal';
      });
//      throw Exception('ERROR: unable to retrieve center card role for solo mafia role/mafia reveal');
    }
  }
}