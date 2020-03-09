import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mafia_app/session.dart' as session;

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
  YourRolePage();

  @override
  _YourRolePageState createState() => _YourRolePageState();
}

class _YourRolePageState extends State<YourRolePage> {
  Future<PlayerRoleResponse> playerRole;
  String _role;

  Future<PlayerRoleResponse> fetchPlayerRole() async {
    final response = await http.get('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/role/'
                                    + session.gameID + '/' + session.playerID);
    if (response.statusCode == 200) {
      print("YourRolePage: PlayerRole response code: " + response.statusCode.toString());
      print("isOwner: " + session.isOwner.toString());
      print("YourRolePage: body: " + response.body.toString());

      PlayerRoleResponse playerRole = PlayerRoleResponse.fromJson(json.decode(response.body));
      print("YourRolePage: role: " + playerRole.role);
      _role = playerRole.role;
      session.allRoles = playerRole.allRoles;

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
                    },
                    child: Text('Your Role'),
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/listRoles');
                      },
                    child: Text('All Roles'),
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
                      return Text(_role);
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
                    Navigator.pushReplacementNamed(context, '/mafiaRole');
                    break;
                  case "civilian" :
                    print("civilian switch");
                    Navigator.pushReplacementNamed(context, '/civilianRole');
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
