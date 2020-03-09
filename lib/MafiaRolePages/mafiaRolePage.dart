import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mafia_app/session.dart' as session;

class MafiaRolePage extends StatefulWidget {

  MafiaRolePage();

  @override
  State<StatefulWidget> createState() {
    return _MafiaRolePageState();
  }
}

class _MafiaRolePageState extends State<MafiaRolePage> {
  String _otherMafiaName = "loading...";
  bool _isContinueButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mafia Role"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_otherMafiaName),
            _buildContinueButton(),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildContinueButton() {
    if (!_isContinueButtonEnabled) return CircularProgressIndicator();
    return FlatButton (
      color: Colors.red[900],
      textColor: Colors.white,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      padding: EdgeInsets.all(8.0),
      splashColor: Colors.redAccent[700],
      onPressed: () {
        // This will eventually route to the next part of the app. Not yet ready.
        Navigator.pushReplacementNamed(context, '/');
      },
      child: Text(
        "Continue",
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getOtherMafiaName();
  }

  void _getOtherMafiaName() async {

    String _url = "https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/role/friends";
    String _body = '{"personId": "' + session.playerID + '", "gameId": "' + session.gameID + '", "role": "mafia"}';
    final _response = await http.put(_url, body: _body);
    if (_response.statusCode == 200) {
      List<dynamic> _mafiaMembers = jsonDecode(_response.body)["friends"];

      if (_mafiaMembers.isEmpty) {
        throw Exception('ERROR: no mafia members listed??');
      }

      List<String> _friends = [];

      for (dynamic member in _mafiaMembers) {
        if (member != session.playerName) {
          _friends.add(member.toString());
        }
      }

      String _otherMafiaPlayerName = "";
      if (_friends.isEmpty) {
        Navigator.pushReplacementNamed(context, '/soloMafiaRole');
        return;

      } else {
        //will only ever be one other mafia or none other...
        _otherMafiaPlayerName = "The other mafia member is: " + _friends[0];
      }

      setState(() {
        this._otherMafiaName = _otherMafiaPlayerName;
        this._isContinueButtonEnabled = true;
      });

    }
    else {
      print(_response.statusCode);
      print(_response.body.toString());
      throw Exception('ERROR: getOtherMafiaMemeberName failed.');
    }
  }
}