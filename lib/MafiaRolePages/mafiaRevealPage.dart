import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import "package:mafia_app/session.dart" as session;

class MafiaRevealPageArguments {
  int cardNumber;

  MafiaRevealPageArguments(this.cardNumber);
}

class MafiaRevealPage extends StatefulWidget {

  final MafiaRevealPageArguments arguments;

  MafiaRevealPage(this.arguments);

  @override
  State<StatefulWidget> createState() {
    return _MafiaRevealPageState();
  }
}

class _MafiaRevealPageState extends State<MafiaRevealPage> {
  String _roleToReveal = "loading...";

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
        // This button will eventually route to the next part of the game... not there yet.
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
    String _url = 'https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/role/mafia/'
                  + session.gameID + '/' + (widget.arguments.cardNumber + 1).toString()
                  + "/" + session.playerID;
    final dynamic _response = await http.get(_url);
    if (_response.statusCode == 200) {
      setState(() {
        this._roleToReveal = "The role is " + jsonDecode(_response.body)["role"] + "!";
      });
    }
    else {
      print('ERROR: Center Card Role Reveal API: ' + _response.statusCode.toString());
      print(_response.body.toString());
      setState(() {
        this._roleToReveal = 'ERROR: unable to retrieve center card role for solo mafia role/mafia reveal';
      });
    }
  }
}