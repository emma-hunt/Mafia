import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mafia_app/createJoinGame.dart';

class CreateGameResponse {
  final String hostName;
  final String hostID;
  final String gameID;
  final String message;

  CreateGameResponse({this.hostName, this.hostID, this.gameID, this.message});

  factory CreateGameResponse.fromJson(Map<String, dynamic> json) {
    return CreateGameResponse(
      hostName: json['hostName'],
      hostID: json['hostId'],
      gameID: json['gameId'],
      message: json['message']
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
      if(createGameResponse.message == null) {
        print(createGameResponse.gameID);
        print(createGameResponse.hostName);
        print(createGameResponse.message);
        return createGameResponse;
      }
      else {
        throw Exception(createGameResponse.message);
      }
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

class JoinGameResponse {
  final String playerName;
  final String gameID;
  final String playerID;

  JoinGameResponse( {this.playerName, this. playerID, this.gameID});

  factory JoinGameResponse.fromJson(Map<String, dynamic> json) {
    return JoinGameResponse (
      playerName: json['playerName'],
      playerID: json['playerId'],
      gameID: json['gameId'],
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
  Future<JoinGameResponse> joinGameResponse;

  Future<JoinGameResponse> fetchPost() async {
    final response = await http.post('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/game/join/' + widget.args.gameCode + '/' + widget.args.playerName);
    if (response.statusCode == 200) {
      print(response.body.toString());
      JoinGameResponse joinResponse = JoinGameResponse.fromJson(json.decode(response.body));
      print(joinResponse.gameID);
      print(joinResponse.playerName);
      return joinResponse;
    }
    else {
      print(response.statusCode);
      print(response.body.toString());
      throw Exception('Unable to join game');
    }
  }

  @override
  void initState() {
    super.initState();
    this.joinGameResponse = fetchPost();
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
            FutureBuilder<JoinGameResponse> (
              future: joinGameResponse,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Text("Game ID: " + snapshot.data.gameID.toString()),
                      Text("Player name: " + snapshot.data.playerName.toString()),
                    ]
                  );
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