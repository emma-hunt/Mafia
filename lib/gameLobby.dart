import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:mafia_app/createJoinGame.dart';

class CreateGameResponse {
  final String hostName;
  final String hostID;
  final String gameID;

  CreateGameResponse({this.hostName, this.hostID, this.gameID});

  factory CreateGameResponse.fromJson(Map<String, dynamic> json) {
    return CreateGameResponse(
      hostName: json['hostName'],
      hostID: json['hostId'],
      gameID: json['gameId'],
    );
  }
}

class CreatorGameLobbyPage extends StatefulWidget {
  final CreateGameArguments args;

  CreatorGameLobbyPage({this.args});

  @override
  _CreatorGameLobbyPageState createState() => _CreatorGameLobbyPageState();
}

class _CreatorGameLobbyPageState extends State<CreatorGameLobbyPage> {
  Future<CreateGameResponse> createGameResponse;

  Future<CreateGameResponse> fetchPost() async {
    final response = await http.post('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/game/' + widget.args.playerName);
    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body.toString());
      CreateGameResponse createGameResponse = CreateGameResponse.fromJson(json.decode(response.body));
      print(createGameResponse.gameID);
      print(createGameResponse.hostName);
      return createGameResponse;
    }
    else {
      print(response.statusCode);
      print(response.body.toString());
      throw Exception('Unable to create game');
    }
  }

  @override
  void initState() {
    super.initState();
    createGameResponse = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Creator Game Lobby"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<CreateGameResponse> (
              future: createGameResponse,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text("Game ID: " + snapshot.data.gameID.toString());
                }
                else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text('Return Home'),
            ),
          ],
        ),
      ),
    );
  }

}

class JoinerGameLobbyPage extends StatefulWidget {
  final JoinGameArguments args;

  JoinerGameLobbyPage({this.args});

  @override
  _JoinerGameLobbyPageState createState() => _JoinerGameLobbyPageState();
}

class _JoinerGameLobbyPageState extends State<JoinerGameLobbyPage> {
  Future<bool> apiSuccess;

  Future<bool> fetchPost() async {
    final response = await http.get('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev');
    if (response.statusCode == 200) {
      return true;
    }
    else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    this.apiSuccess = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Joiner Game Lobby"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<bool> (
              future: apiSuccess,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.toString());
                }
                else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text('Return Home'),
            ),
            RaisedButton(
              onPressed: () {

                Future<bool> leaveGame() async {
                  final response = await http.delete('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/game/leave/' + widget.args.gameCode + '/' + widget.args.playerName);
                  if (response.statusCode == 200) {
                    print(response.statusCode);
                    print(response.body.toString());
                    return true;
                  }
                  else {
                    print(response.statusCode);
                    print(response.body.toString());
                    throw Exception('Unable to leave game');
                  }
                }

                Future<bool> leaveGameFuture = leaveGame();
                print("here");
                leaveGameFuture.whenComplete(() => {
//                  print("when complete called");
//                  Navigator.pushReplacementNamed(context, '/');
                });
              },
              child: Text('Leave Lobby'),
            ),
          ],
        ),
      ),
    );
  }

}