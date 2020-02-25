import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mafia_app/MafiaRoleStuff/argsClasses/mafiaRevealArgs.dart';

class MafiaReveal extends StatefulWidget {
  final MafiaRevealArgs args;

  MafiaReveal({this.args});

  @override
  State<StatefulWidget> createState() {
    return _MafiaRevealState();
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
            Text(this.roleToReveal),
            _getContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _getContinueButton() {
    if (this.roleToReveal == "") return CircularProgressIndicator();
    return RaisedButton(
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
    final response = await http.get('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/role/mafia/{' + this.args.gameId + '}/{' + this.args.roleNum.toString() + '}');
    if (response.statusCode == 200) {
      print("getRoleToReveal: " + response.statusCode.toString());
      print(response.body.toString());
      setState(() {
        this.roleToReveal = jsonDecode(response.body)["role"];
      });
    }
    else {
      print(response.statusCode);
      print(response.body.toString());
      throw Exception('Unable to leave game');
    }
  }
}