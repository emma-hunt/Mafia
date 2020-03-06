import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import "session.dart" as session;


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

  CreatorGameLobbyPage();

  @override
  _CreatorGameLobbyPageState createState() => _CreatorGameLobbyPageState();
}

class _CreatorGameLobbyPageState extends State<CreatorGameLobbyPage> {
  Future<CreateGameResponse> createGameResponse;
  Future<LobbyStateResponse> lobbyStateResponse;
  Timer timer;

  Future<CreateGameResponse> _fetchCreateGame() async {
    final response = await http.post('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/game/' + session.playerName);
    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body.toString());
      CreateGameResponse createGameResponse = CreateGameResponse.fromJson(json.decode(response.body));
      session.playerID = json.decode(response.body)["hostId"];
      session.gameID = json.decode(response.body)["gameId"];
      session.playerName = json.decode(response.body)["hostName"];
      return createGameResponse;
    }
    else {
      print(response.statusCode);
      print(response.body.toString());
      throw Exception('Unable to create game');
    }
  }

  Future<LobbyStateResponse> _checkLobbyState(CreateGameResponse createResponse) async {
    final response = await http.get('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/game/status/' + createResponse.gameID);
    if (response.statusCode == 200) {
      //print(response.body);
      LobbyStateResponse lobbyState = LobbyStateResponse.fromJson(json.decode(response.body));
      //print(lobbyState.playerList);
      if(lobbyState.isGameStarted) {
        // game is started, time to move to the next page
        _startPlaying(lobbyState, createResponse);
      }
      return lobbyState;
    }
    else {
      print("failure in lobby polling");
      print(response.statusCode);
      print(response.body);
      throw Exception('Unable to get Lobby State');
    }
  }

  void _pollLobbyState(CreateGameResponse createGameResponse) async {
    setState(() {
      this.lobbyStateResponse = _checkLobbyState(createGameResponse);
    });
  }

  void _startGamePost(String gameID, List<dynamic> playerList) async {
    print("SENDING START GAME!!!!");
    List<String> roles = ["mafia", "mafia", "civilian"];
    for (int i = 0; i < playerList.length; i++) {
      roles.add("civilian");
    }
    String jsonRoles = jsonEncode(roles);
    String startBody = '{"roles": ' + jsonRoles + '}';
    print(startBody);
    Map<String, String> headers = {"Content-type": "application/json"};
    //recording playerList right before starting game...
    session.playerList = playerList;
    final response = await http.put('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/game/start/' + gameID, headers: headers, body: startBody);
    if (response.statusCode == 200) {
      print("startGame: " + response.statusCode.toString());
      print(response.body.toString());
    }
    else {
      print(response.statusCode);
      print(response.body.toString());
      throw Exception('Unable to start game');
    }
  }

  void _startPlaying(LobbyStateResponse lobbyState, CreateGameResponse createResponse) {
    print("game has started");
    session.playerName = createResponse.playerName;
    session.gameID = createResponse.gameID;
    session.playerID = createResponse.playerID;
    session.playerList = lobbyState.playerList;
    session.isOwner = true;
    Navigator.pushReplacementNamed(context, '/yourRolePage');
  }

  @override
  void initState() {
    super.initState();
    createGameResponse = _fetchCreateGame();
  }

  @override
  void deactivate() {
    print("IN DEACTIVATE");
    if(timer != null) {
      timer.cancel();
      timer = null;
    }
    super.deactivate();
  }

  @override
  void dispose() {
    print("IN DISPOSE");
    if(timer != null) {
      timer.cancel();
      timer = null;
    }
    super.dispose();
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
                  timer = Timer(Duration(seconds: 5), () => _pollLobbyState(createGameSnapshot.data));
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
                          // this future builder is for the player list
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
                        FutureBuilder<LobbyStateResponse> (
                          // this future is for the start game button
                          future: lobbyStateResponse,
                          builder: (context, lobbyStateSnapshot) {
                            if (lobbyStateSnapshot.hasData) {
                              print("has data");
                              return RaisedButton(
                                onPressed: () {
                                  if (lobbyStateSnapshot.data.playerList != null && lobbyStateSnapshot.data.playerList.length >= 2) {
                                    Fluttertoast.showToast(
                                      msg: "Starting game... be patient :)",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                    );
                                    _startGamePost(createGameSnapshot.data.gameID, lobbyStateSnapshot.data.playerList);
                                  }
                                  else {
                                    Fluttertoast.showToast(
                                      msg: "You must have 2+ players to start",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                    );
                                  }
                                },
                                child: Text('Start Game'),
                              );
                            }
                            else {
                              return  RaisedButton(
                                onPressed: () {
                                  Fluttertoast.showToast(
                                    msg: "You must have 3+ players to start",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                  );
                                },
                                child: Text('Start Game'),
                              );
                            }
                          },
                        ),
                        RaisedButton(
                          onPressed: () {
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

void leaveGame(BuildContext context) async {
  final response = await http.delete('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/game/leave/' + session.gameID + '/' + session.playerName);
  if (response.statusCode == 200) {
    print("leaveGame: " + response.statusCode.toString());
    print(response.body.toString());
    Navigator.pushReplacementNamed(context, '/');
  }
  else {
    print(response.statusCode);
    print(response.body.toString());
    throw Exception('Unable to leave game');
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

  JoinerGameLobbyPage();

  @override
  _JoinerGameLobbyPageState createState() => _JoinerGameLobbyPageState();
}

class _JoinerGameLobbyPageState extends State<JoinerGameLobbyPage> {
  Future<JoinGameResponse> joinGameResponse;
  Future<LobbyStateResponse> lobbyStateResponse;
  Timer timer;

  Future<JoinGameResponse> _fetchJoinGame() async {
    final response = await http.post('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/game/join/' + session.gameID + '/' + session.playerName);
    if (response.statusCode == 200) {
      print(response.body.toString());
      JoinGameResponse joinResponse = JoinGameResponse.fromJson(json.decode(response.body));
      session.playerName = joinResponse.playerName;
      session.gameID = joinResponse.gameID;
      session.playerID = joinResponse.playerID;
      print("LOOK HERE!!!  ----->    " + session.playerID);
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

  Future<LobbyStateResponse> _checkLobbyState(JoinGameResponse joinResponse) async {
    final response = await http.get('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/game/status/' + joinResponse.gameID);
    if (response.statusCode == 200) {
      print(response.body);
      LobbyStateResponse lobbyState = LobbyStateResponse.fromJson(json.decode(response.body));
      print(lobbyState.playerList);
      session.playerList = lobbyState.playerList;
      if(lobbyState.isGameStarted) {
        // game is started, time to move to the next page
        _startPlaying(lobbyState, joinResponse);
      }
      return lobbyState;
    }
    else {
      print("failure in lobby polling");
      print(response.statusCode);
      print(response.body);
      throw Exception('Unable to get Lobby State');
    }
  }

  void _pollLobbyState(JoinGameResponse joinResponse) async {
    setState(() {
      this.lobbyStateResponse = _checkLobbyState(joinResponse);
    });
  }

  void _startPlaying(LobbyStateResponse lobbyState, JoinGameResponse joinResponse) {
    print("game has started");
    session.playerName = joinResponse.playerName;
    session.playerID = joinResponse.playerID;
    session.gameID = joinResponse.gameID;
    session.playerList = lobbyState.playerList;
    session.isOwner = false;
    Navigator.pushReplacementNamed(context, '/yourRolePage');
  }

  @override
  void initState() {
    super.initState();
    this.joinGameResponse = _fetchJoinGame();
  }

  @override
  void deactivate() {
    print("IN DEACTIVATE");
    if(timer != null) {
      timer.cancel();
      timer = null;
    }
    super.deactivate();
  }

  @override
  void dispose() {
    print("IN DISPOSE");
    if(timer != null) {
      timer.cancel();
    }
    timer = null;
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
                  timer = Timer(Duration(seconds: 5), () => _pollLobbyState(joinGameSnapshot.data));
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
            RaisedButton(
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "Leaving game... be patient :)",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                );
                leaveGame(context);
              },
              child: Text('Leave Game'),
            ),
          ],
        ),
      ),
    );
  }

}