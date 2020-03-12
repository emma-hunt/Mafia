import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mafia_app/session.dart' as session;

class CreateGamePage extends StatefulWidget {

  @override
  _CreateGamePageState createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Game"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Container(
            child: TextField(
              onChanged: (String value) {
                session.playerName = value;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                hintText: 'Your Name',
                labelText: 'Name',
              ),
            ),
          ),
          Container (
            child: RaisedButton(
              onPressed: () {
                if (session.playerName == "") {
                  Fluttertoast.showToast(
                    msg: "You must enter a name",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
                else {
                  Navigator.pushNamedAndRemoveUntil(context, '/creatorGameLobby', (Route<dynamic> route) => false);
                }
              },
              child: Text('Submit'),
            ),
          )
        ],
      ),
    );
  }
}


class JoinGamePage extends StatefulWidget {

  @override
  _JoinGamePageState createState() => _JoinGamePageState();
}

class _JoinGamePageState extends State<JoinGamePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Join Game"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Container (
            child: TextField(
              onChanged: (String value) {
                session.gameID = value;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                hintText: '4 character code',
                labelText: 'Game Code',
              ),
            ),
          ),
          Container (
            child: TextField(
              onChanged: (String value) {
                session.playerName = value;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                hintText: 'Your Name',
                labelText: 'Name',
              ),
            ),
          ),
          Container (
            child: RaisedButton(
              onPressed: () {
                if (session.playerName == "" && session.gameID == "") {
                  Fluttertoast.showToast(
                    msg: "You must enter a name and game code",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
                else if (session.playerName == "") {
                  Fluttertoast.showToast(
                    msg: "You must enter a name",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
                else if (session.gameID == "") {
                  Fluttertoast.showToast(
                    msg: "You must enter a game code",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
                else {
                  Navigator.pushNamedAndRemoveUntil(context, '/joinerGameLobby', (Route<dynamic> route) => false);
                }
              },
              child: Text('Submit'),
            ),
          )
        ],
      ),
    );
  }
}
