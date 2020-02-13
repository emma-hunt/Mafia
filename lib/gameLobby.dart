import 'dart:async';
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

class LobbyStateResponse {
  final bool isGameStarted;
  final List<dynamic> playerList;

  LobbyStateResponse({this.isGameStarted, this.playerList});

  factory LobbyStateResponse.fromJson(Map<String, dynamic> json) {
    return LobbyStateResponse(
      isGameStarted: json['hasStarted'],
      playerList: json['playerNames']
    );
  }
}

class CreatorGameLobbyPage extends StatefulWidget {
  final CreateGameArguments args;
  Timer timer;

  CreatorGameLobbyPage({this.args});

  @override
  _CreatorGameLobbyPageState createState() => _CreatorGameLobbyPageState();
}

class _CreatorGameLobbyPageState extends State<CreatorGameLobbyPage> {
  Future<CreateGameResponse> createGameResponse;

  Future<CreateGameResponse> _fetchCreateGame() async {
    final response = await http.post('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/game/' + widget.args.playerName);
    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body.toString());
      CreateGameResponse createGameResponse = CreateGameResponse.fromJson(json.decode(response.body));
      return createGameResponse;
    }
    else {
      print(response.statusCode);
      print(response.body.toString());
      throw Exception('Unable to create game');
    }
  }

  Future<LobbyStateResponse> _checkLobbyState(String gameID) async {
    final response = await http.get('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/game/status/' + gameID);
    if (response.statusCode == 200) {
      print(response.body);
      LobbyStateResponse lobbyState = LobbyStateResponse.fromJson(json.decode(response.body));
      print(lobbyState.playerList);
      return lobbyState;
    }
    else {
      print("failure in lobby polling");
      print(response.statusCode);
      print(response.body);
      throw Exception('Unable to get Lobby State');
    }
  }

  @override
  void initState() {
    super.initState();
    createGameResponse = _fetchCreateGame();

  }

  @override
  void deactivate() {
    if(widget.timer != null) {
      widget.timer.cancel();
      widget.timer = null;
    }
    super.deactivate();
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
                  widget.timer = Timer.periodic(Duration(seconds: 2), (_) => _checkLobbyState(snapshot.data.gameID));
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
                      RaisedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: Text('Return Home'),
                      ),
                    ]
                  );
                }
                else if (snapshot.hasError) {
                  return Column (
                    children: <Widget>[
                      Text("${snapshot.error}"),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: Text('Return Home'),
                      ),
                    ],
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

}