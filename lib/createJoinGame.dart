import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class CreateGamePage extends StatefulWidget {
  @override
  _CreateGamePageState createState() => _CreateGamePageState();

}

class _CreateGamePageState extends State<CreateGamePage> {
  var playerName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Game"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: playerName,
              onChanged: (String value) {
                playerName = value;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                hintText: 'Your Name',
                labelText: 'Name',
              ),
            ),
            RaisedButton(
              onPressed: () {
                if (playerName == null) {
                  Fluttertoast.showToast(
                    msg: "You must enter a name",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
                else {
                  Navigator.pushReplacementNamed(context, '/creatorGameLobby', arguments: CreateGameArguments(playerName));
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      )
    );
  }
}

class CreateGameArguments{
  final String playerName;

  CreateGameArguments(this.playerName);
}

class JoinGamePage extends StatefulWidget {
  @override
  _JoinGamePageState createState() => _JoinGamePageState();

}

class _JoinGamePageState extends State<JoinGamePage> {
  var playerName;
  var gameCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Join Game"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: gameCode,
              onChanged: (String value) {
                gameCode = value;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                hintText: '5 character code',
                labelText: 'Game Code',
              ),
            ),
            TextField(
              controller: playerName,
              onChanged: (String value) {
                playerName = value;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                hintText: 'Your Name',
                labelText: 'Name',
              ),
            ),
            RaisedButton(
              onPressed: () {
                if (playerName == null && gameCode == null) {
                  Fluttertoast.showToast(
                    msg: "You must enter a name and game code",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
                else if (playerName == null) {
                  Fluttertoast.showToast(
                    msg: "You must enter a name",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
                else if (gameCode == null) {
                  Fluttertoast.showToast(
                    msg: "You must enter a game code",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
                else {
                  Navigator.pushReplacementNamed(context, '/joinerGameLobby');
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
