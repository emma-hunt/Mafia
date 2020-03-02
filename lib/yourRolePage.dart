import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mafia_app/CivilianStuff/CivilianRoleArgs.dart';
import 'package:mafia_app/MafiaRoleStuff/argsClasses/mafiaRoleArgs.dart';
import 'package:mafia_app/createJoinGame.dart';
import 'package:mafia_app/listRoles.dart';

class YourRoleArguments {
  final String playerName;
  final String playerID;
  final String gameID;
  final List<dynamic> playerList;
  final bool isOwner;

  YourRoleArguments(this.playerName, this.playerID, this.gameID, this.playerList, this.isOwner);
}

class PlayerRoleResponse{
  final String role;
  final List<dynamic> allRoles;
  PlayerRoleResponse({this.role, this.allRoles});
  factory PlayerRoleResponse.fromJson(Map<String, dynamic> json){
    return PlayerRoleResponse(
      role: json['role'],
      allRoles: json['allRoles']
    );
  }
}

class YourRolePage extends StatefulWidget {
  final YourRoleArguments args;

  YourRolePage({this.args});

  @override
  _YourRolePageState createState() => _YourRolePageState();
}


class _YourRolePageState extends State<YourRolePage> {
  Future<PlayerRoleResponse> playerRole;
  String _role;

  Future<PlayerRoleResponse> fetchPlayerRole() async {
    final response = await http.get('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/role/'
                                    + widget.args.gameID + '/' + widget.args.playerID);
    if (response.statusCode == 200) {
      print("YourRolePage: PlayerRole response code: " + response.statusCode.toString());
      print("YourRolePage: body: " + response.body.toString());

      PlayerRoleResponse playerRole = PlayerRoleResponse.fromJson(json.decode(response.body));
      print("YourRolePage: role: " + playerRole.role);
      _role = playerRole.role;

      return playerRole;
    }
    else {
      print(response.statusCode);
      print(response.body.toString());
      throw Exception('Unable to create game');
    }
  }

  @override
  void initState(){
    super.initState();
    playerRole = fetchPlayerRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Role"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      // Does nothing, stay on the same page
                      //Navigator.pushReplacementNamed(context, '/yourRolePage');
                    },
                    child: Text('Your Role'),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/listRoles', arguments: ListRolesArguments());
                      },
                    child: Text('Roles'),
                  ),
                ),
              ],
            ),
            Container(
              child: Text(
                'You are the:',
                style: TextStyle(fontSize: 20.0),
              ),
              padding: EdgeInsets.fromLTRB(0.0, 30.0, 0, 0),
            ),
            Expanded(
              child: Container(
                alignment: Alignment(0.0, 0.0),
                child: FutureBuilder<PlayerRoleResponse>(
                  future: playerRole,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      print("role data received");
                      return Text(snapshot.data.role);
                    }
                    else if (snapshot.hasError){
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ),
            Text(
              "ROLE DESCIRPTION",
              style: TextStyle(fontSize: 20.0),
            ),
            RaisedButton(
              onPressed: () {
                print("pressed: " + this._role);
                switch (this._role) {
                  case "mafia" :
                    print("mafia switch");
                    MafiaRoleArgs args = MafiaRoleArgs(personId: widget.args.playerID, personName: widget.args.playerName,
                                                       gameId: widget.args.gameID);
                    Navigator.pushReplacementNamed(context, '/mafiaRole', arguments: args);
                    break;
                  case "civilian" :
                    print("civilian switch");
                    CivilianRoleArgs args = CivilianRoleArgs(personId: widget.args.playerID, personName: widget.args.playerName,
                                                             gameId: widget.args.gameID);
                    Navigator.pushReplacementNamed(context, '/civilianRole', arguments: args);
                    break;
                }
              },
              child: Text('Continue'),
              //padding : EdgeInsets.fromLTRB(0, 0, 0, 200)
            )
          ],
        )
      )
    );
  }
}
