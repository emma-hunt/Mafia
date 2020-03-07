import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import "package:mafia_app/session.dart" as session;

class MafiaRevealPage extends StatefulWidget {

  MafiaRevealPage();

  @override
  State<StatefulWidget> createState() {
    return _MafiaRevealPageState();
  }
}

class _MafiaRevealPageState extends State<MafiaRevealPage> {
  String _roleToReveal = "loading...";

  _MafiaRevealPageState();

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
              child: Text(this._roleToReveal),
              margin: EdgeInsets.all(30),
            ),
            _getContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _getContinueButton() {
    if (this._roleToReveal == "loading...") return CircularProgressIndicator();
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
    print("PlayerID:");
    print(session.playerID);
    String url = 'https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/role/mafia/'
                  + session.gameID + '/' + (session.cardNumber + 1).toString()
                  + "/" + session.playerID;
    print("url:" + url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("getRoleToReveal : " + response.statusCode.toString() + " : " + response.body.toString());
      setState(() {
        this._roleToReveal = "The role is " + jsonDecode(response.body)["role"] + "!";
      });
    }
    else {
      print('Center Card Role Reveal API: ' + response.statusCode.toString());
      print(response.body.toString());
      setState(() {
        this._roleToReveal = 'ERROR: unable to retrieve center card role for solo mafia role/mafia reveal';
      });
    }
  }
}