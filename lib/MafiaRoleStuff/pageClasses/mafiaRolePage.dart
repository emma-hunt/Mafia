import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mafia_app/MafiaRoleStuff/argsClasses/mafiaRoleArguments.dart';
import 'package:mafia_app/MafiaRoleStuff/argsClasses/soloMafiaRoleArguments.dart';


class MafiaRolePage extends StatefulWidget {
  final MafiaRoleArguments arguments;

  MafiaRolePage({this.arguments});

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
    getOtherMafiaName(widget.arguments);
  }

  void getOtherMafiaName(MafiaRoleArguments args) async {

    String url = "https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/role/friends";
    String body = '{"personId": "' + args.personId + '", "gameId": "' + args.gameId + '", "role": "mafia"}';
    final response = await http.put(url, body: body);
    if (response.statusCode == 200) {
      print("getOtherMafiaMemberName : " + response.statusCode.toString() + " : " + response.body.toString());

      List<dynamic> mafiaMembers = jsonDecode(response.body)["friends"];

      if (mafiaMembers.isEmpty) {
        throw Exception('ERROR: no mafia members listed??');
      }

      List<String> friends = [];

      for (dynamic member in mafiaMembers) {
        if (member != args.personName) {
          friends.add(member.toString());
        }
      }

      String otherMafiaPlayerName = "";
      if (friends.isEmpty) {
        Navigator.pushReplacementNamed(context, '/soloMafiaRole', arguments: SoloMafiaRoleArguments(args));
        return;

      } else {
        //will only ever be one other mafia or none other...
        otherMafiaPlayerName = "The other mafia member is: " + friends[0];
      }

      setState(() {
        this._otherMafiaName = otherMafiaPlayerName;
        this._isContinueButtonEnabled = true;
      });

    }
    else {
      print(response.statusCode);
      print(response.body.toString());
      throw Exception('ERROR: getOtherMafiaMemeberName failed.');
    }
  }
}