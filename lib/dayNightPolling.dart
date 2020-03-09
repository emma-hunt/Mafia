import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "session.dart" as session;

class ActionCompleteResponse {
  final bool success;

  ActionCompleteResponse({this.success});

  factory ActionCompleteResponse.fromJson(Map<String, dynamic> json) {
    if(json['message'] == "Success") {
      return ActionCompleteResponse(success: true);
    }
    else {
      return ActionCompleteResponse(success: false);
    }
  }
}

class NightStateResponse {
  final bool isNightOver;

  NightStateResponse({this.isNightOver});

  factory NightStateResponse.fromJson(Map<String, dynamic> json) {
    return NightStateResponse(
        isNightOver: json['areAllActionsComplete'],
    );
  }
}

class NightPollingPage extends StatefulWidget {
  @override
  _NightPollingPageState createState() => _NightPollingPageState();
}

class _NightPollingPageState extends State<NightPollingPage> {
  Timer timer;
  Future<ActionCompleteResponse> actionCompleteResponse;
  Future<NightStateResponse> nightStateResponse;

  Future<ActionCompleteResponse> _postActionComplete() async {
    final response = await http.put('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/role/' + session.gameID + '/' + session.playerID);
    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body.toString());
      ActionCompleteResponse actionCompleteResponse = ActionCompleteResponse.fromJson(json.decode(response.body));
      return actionCompleteResponse;
    }
    else {
      print(response.statusCode);
      print(response.body.toString());
      throw Exception('Failure to mark role action as complete');
    }
  }

  Future<NightStateResponse> _fetchNightState() async {
    final response = await http.get('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/game/status/' + session.gameID + '/actions');
    print("night poll");
    if (response.statusCode == 200) {
      NightStateResponse nightState = NightStateResponse.fromJson(json.decode(response.body));
      if(nightState.isNightOver) {
        // game is started, time to move to the next page
        _moveToDay();
      }
      return nightState;
    }
    else {
      print("failure in lobby polling");
      print(response.statusCode);
      print(response.body);
      throw Exception('Unable to get Lobby State');
    }
  }

  void _pollNightState() async {
    setState(() {
      this.nightStateResponse = _fetchNightState();
    });
  }

  void _moveToDay() {
    Navigator.pushReplacementNamed(context, '/dayPolling');
  }

  @override
  void initState() {
    super.initState();
    actionCompleteResponse = _postActionComplete();
  }

  @override
  void deactivate() {
    if(timer != null) {
      timer.cancel();
      timer = null;
    }
    super.deactivate();
  }

  @override
  void dispose() {
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
        title: Text("Night"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<ActionCompleteResponse> (
              future: actionCompleteResponse,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  timer = Timer(Duration(seconds: 5), () => _pollNightState());
                  return Container(
                    padding: EdgeInsets.all(50),
                    child: Text("Please wait for other players to complete thier role action. You will be moved forward once everyone is done."),
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
                        child: Text('Quit'),
                      ),
                    ],
                  );
                }
                return CircularProgressIndicator();
              },
            )
          ],
        ),
      ),
    );
  }

}

class DayStateResponse {
  final bool isDayOver;

  DayStateResponse({this.isDayOver});

  factory DayStateResponse.fromJson(Map<String, dynamic> json) {
    return DayStateResponse(
      isDayOver: json['areAllActionsComplete'],
    );
  }
}

class DayPollingPage extends StatefulWidget {
  @override
  _DayPollingPageState createState() => _DayPollingPageState();
}

class _DayPollingPageState extends State<DayPollingPage> {
  Timer timer;
  Future<DayStateResponse> dayStateResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Day"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Text("Talk with the other players to try and determine their roles. Voting will commence when the game owner decides the group is ready."),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Text("Hint: If you are a civilian, your goal is to kill a mafia member. If you are a mafia member, your goal is to kill a civilian."),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

}