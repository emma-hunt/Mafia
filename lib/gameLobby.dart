import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mafia_app/createJoinGame.dart';

class CreateGameResponse {
  final String playerName;
  final String playerID;
  final String gameID;
  final String message;

  CreateGameResponse({this.playerName, this.playerID, this.gameID, this.message});

  factory CreateGameResponse.fromJson(Map<String, dynamic> json) {
    return CreateGameResponse(
      playerName: json['hostName'],
      playerID: json['hostId'],
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
  void deactivate() {
    print("IN DEACTIVATE");
    if(timer != null) {
      timer.cancel();
      timer = null;
    }
  }

  @override
  void dispose() {
    print("IN DISPOSE");
    if(timer != null) {
      timer.cancel();
    }
    timer = null;
  }

  @override
  _CreatorGameLobbyPageState createState() => _CreatorGameLobbyPageState();
}

class _CreatorGameLobbyPageState extends State<CreatorGameLobbyPage> {
  Future<CreateGameResponse> createGameResponse;
  Future<LobbyStateResponse> lobbyStateResponse;

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

  void _pollLobbyState(String gameID) async {
    setState(() {
      this.lobbyStateResponse = _checkLobbyState(gameID);
    });
  }

  @override
  void initState() {
    super.initState();
    createGameResponse = _fetchCreateGame();

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
              builder: (context, createGameSnapshot) {
                if (createGameSnapshot.hasData) {
                  widget.timer = Timer.periodic(Duration(seconds: 5), (_) => _pollLobbyState(createGameSnapshot.data.gameID));
                  return Container (
                    constraints: BoxConstraints(
                        maxHeight: 300.0,
                        maxWidth: 200.0,
                        minWidth: 150.0,
                        minHeight: 150.0
                    ),
                    child: Column(
                        children: <Widget>[
                          Text("Game ID: " + createGameSnapshot.data.gameID.toString()),
                          Text("\nPlayers: "),
                          FutureBuilder<LobbyStateResponse> (
                            future: lobbyStateResponse,
                            builder: (context, lobbyStateSnapshot) {
                              if (lobbyStateSnapshot.hasData) {
                                return Flexible (
                                  fit: FlexFit.loose,
                                  child: ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: lobbyStateSnapshot.data.playerList.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Center(
                                          child: Text(lobbyStateSnapshot.data.playerList[index]),
                                        );
                                      }
                                  ),
                                );
                              }
                              else {
                                return Flexible (
                                    fit: FlexFit.loose,
                                    child: Center(
                                      child: Text(createGameSnapshot.data.playerName),
                                    )
                                );
                              }
                            },
                          ),
                          RaisedButton(
                            onPressed: () {
                              widget.timer.cancel();
                              widget.timer = null;
                              Navigator.pushReplacementNamed(context, '/');
                            },
                            child: Text('Return Home'),
                          ),
                        ]
                    ),
                  );
                }
                else if (createGameSnapshot.hasError) {
                  return Column (
                    children: <Widget>[
                      Text("${createGameSnapshot.error}"),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: Text('Try Again'),
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
  Timer timer;

  JoinerGameLobbyPage({this.args});

  @override
  _JoinerGameLobbyPageState createState() => _JoinerGameLobbyPageState();
}

class _JoinerGameLobbyPageState extends State<JoinerGameLobbyPage> {
  Future<JoinGameResponse> joinGameResponse;
  Future<LobbyStateResponse> lobbyStateResponse;

  Future<JoinGameResponse> _fetchJoinGame() async {
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

  void _pollLobbyState(String gameID) async {
    setState(() {
      this.lobbyStateResponse = _checkLobbyState(gameID);
    });
  }

  @override
  void initState() {
    super.initState();
    this.joinGameResponse = _fetchJoinGame();
  }

  @override
  void deactivate() {
    print("IN DEACTIVATE");
    if(widget.timer != null) {
      widget.timer.cancel();
      widget.timer = null;
    }
    super.deactivate();
  }

  @override
  void dispose() {
    print("IN DISPOSE");
    if(widget.timer != null) {
      widget.timer.cancel();
    }
    widget.timer = null;
    super.dispose();
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
              builder: (context, joinGameSnapshot) {
                if (joinGameSnapshot.hasData) {
                  widget.timer = Timer.periodic(Duration(seconds: 5), (_) => _pollLobbyState(joinGameSnapshot.data.gameID));
                  return Container (
                    constraints: BoxConstraints(
                        maxHeight: 300.0,
                        maxWidth: 200.0,
                        minWidth: 150.0,
                        minHeight: 150.0
                    ),
                    child: Column(
                        children: <Widget>[
                          Text("Game ID: " + joinGameSnapshot.data.gameID.toString()),
                          Text("\nPlayers: "),
                          FutureBuilder<LobbyStateResponse> (
                            future: lobbyStateResponse,
                            builder: (context, lobbyStateSnapshot) {
                              if (lobbyStateSnapshot.hasData) {
                                return Flexible (
                                  fit: FlexFit.loose,
                                  child: ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: lobbyStateSnapshot.data.playerList.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Center(
                                          child: Text(lobbyStateSnapshot.data.playerList[index]),
                                        );
                                      }
                                  ),
                                );
                              }
                              else {
                                return Flexible (
                                  fit: FlexFit.loose,
                                  child: Center(
                                    child: Text(joinGameSnapshot.data.playerName),
                                  )
                                );
                              }
                            },
                          ),
                          RaisedButton(
                            onPressed: () {
                              widget.timer.cancel();
                              widget.timer = null;
                              Navigator.pushReplacementNamed(context, '/');
                            },
                            child: Text('Return Home'),
                          ),
                        ]
                    ),
                  );
                }
                else if (joinGameSnapshot.hasError) {
                  return Column (
                    children: <Widget>[
                      Text("${joinGameSnapshot.error}"),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: Text('Try Again'),
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