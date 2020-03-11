import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'session.dart' as session;
import 'package:http/http.dart' as http;


class VoteLobbyArguments {
  String voteeID;
  VoteLobbyArguments(this.voteeID);
}

class SubmitVoteResponse {
  final bool isLast;

  SubmitVoteResponse({this.isLast});

  factory SubmitVoteResponse.fromJson(Map<String, dynamic> json) {
    return SubmitVoteResponse(
      isLast: json['isLast'],
    );
  }
}

class VotingStateResponse {
  final bool isVotingComplete;

  VotingStateResponse({this.isVotingComplete});

  factory VotingStateResponse.fromJson(Map<String, dynamic> json) {
    return VotingStateResponse(
      isVotingComplete: json['allVoted'],
    );
  }
}

class VoteLobbyPage extends StatefulWidget {
  final VoteLobbyArguments arguments;

  VoteLobbyPage(this.arguments);

  @override
  State<StatefulWidget> createState() => _VoteLobbyPageState();
}

class _VoteLobbyPageState extends State<VoteLobbyPage> {
  Timer timer;
  Future<SubmitVoteResponse> submitVoteResponse;
  Future<VotingStateResponse> votingStateResponse;

  Future<SubmitVoteResponse> _postVote() async {
    String url = "https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/game/vote/" +
        session.gameID + "/" + session.playerID + "/" + widget.arguments.voteeID;
    final _response = await http.put(url);
    if (_response.statusCode == 200) {
      SubmitVoteResponse submitVote = SubmitVoteResponse.fromJson(json.decode(_response.body));
      if(submitVote.isLast) {
        // if you were the last one to vote, move forward without polling
        _moveToEndgame();
      }
      return submitVote;
    }
    else {
      print(_response.statusCode);
      print(_response.body.toString());
      throw Exception('Unable to vote');
    }
  }

  Future<VotingStateResponse> _fetchVotingState() async {
    final response = await http.get('https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/game/vote/' + session.gameID);
    print("vote poll");
    if (response.statusCode == 200) {
      VotingStateResponse votingState = VotingStateResponse.fromJson(json.decode(response.body));
      if(votingState.isVotingComplete) {
        // game is started, time to move to the next page
        _moveToEndgame();
      }
      return votingState;
    }
    else {
      print("failure in submitting vote");
      print(response.statusCode);
      print(response.body);
      throw Exception('Unable to submit vote');
    }
  }

  void _pollVotingState() async {
    setState(() {
      this.votingStateResponse = _fetchVotingState();
    });
  }

  void _moveToEndgame() {
    //todo: change path to game results page
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  void initState() {
    submitVoteResponse = this._postVote();
    super.initState();
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
        title: Text("Vote Lobby"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<SubmitVoteResponse> (
              future: submitVoteResponse,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  timer = Timer(Duration(seconds: 1), () => _pollVotingState());
                  return Container(
                    padding: EdgeInsets.all(50),
                    child: Text("Please wait for all players to vote. You will be moved forward once everyone is done."),
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
                return Column (
                  children: <Widget>[
                    Text("Sending your vote..."),
                    CircularProgressIndicator()
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

}