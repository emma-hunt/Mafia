import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mafia_app/createJoinGame.dart';
import 'package:mafia_app/listRoles.dart';

class YourRoleArgument {
  final String playerName;
  final String gameId;

  YourRoleArgument(this.playerName, this.gameId);
}

class PlayerRole{
  final String role;
  PlayerRole({this.role});
  factory PlayerRole.fromJson(Map<String, dynamic> json){
    return PlayerRole(
      role: json['playerId']
    );
  }
}

class YourRolePage extends StatefulWidget {
  final YourRoleArgument args;

  YourRolePage({this.args});

  @override
  _YourRolePage createState() => _YourRolePage();
}


class _YourRolePage extends State<YourRolePage> {
  Future<PlayerRole> playerRole;

  Future<PlayerRole> fetchPlayerRole() async {
    final response = await http.post('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/role/' 
                                    + widget.args.playerName + '/' + widget.args.gameId);
    if (response.statusCode == 200) {
      print("YourRolePage: PlayerRole response code: " + response.statusCode.toString());
      print("YourRolePage: body: " + response.body.toString());

      PlayerRole playerRole = PlayerRole.fromJson(json.decode(response.body));
      print("YourRolePage: role: " + playerRole.role);

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
                child: FutureBuilder<PlayerRole>(
                  future: playerRole,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
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
                Fluttertoast.showToast(
                  msg: "take you to next screen",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              child: Text('time to sleep...'),
              //padding : EdgeInsets.fromLTRB(0, 0, 0, 200)
            )
          ],
        )));
  }
}
