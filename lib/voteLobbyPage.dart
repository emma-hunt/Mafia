import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'session.dart' as session;
import 'package:http/http.dart' as http;


class VoteLobbyArguments {
  String voteeID;
  VoteLobbyArguments(this.voteeID);
}

class VoteLobbyPage extends StatefulWidget {
  final VoteLobbyArguments arguments;
  VoteLobbyPage(this.arguments);
  @override
  State<StatefulWidget> createState() => _VoteLobbyPageState();
}

class _VoteLobbyPageState extends State<VoteLobbyPage> {
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vote Lobby"),
      ),
      body: this._getBody(),
    );
  }

  Widget _getBody() {
    if (this._loading) {
      return CircularProgressIndicator();
    } else {
      //TODO build page here...
      return Column(
        children: <Widget>[
          Text("api finished"),
        ],
      );
    }
  }

  @override
  void initState() {
    this._submitVoteWithAPI();
    super.initState();
  }

  void _submitVoteWithAPI() async {
    String url = "https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/game/vote/" +
                  session.gameID + "/" + session.playerID + "/" + widget.arguments.voteeID;
    final _response = await http.put(url);
    if (_response.statusCode == 200) {
      print("startGame: " + _response.statusCode.toString());
      print(_response.body.toString());
      setState(() {
        this._loading = false;
      });
    }
    else {
      print(_response.statusCode);
      print(_response.body.toString());
      throw Exception('Unable to start game');
    }
  }
}