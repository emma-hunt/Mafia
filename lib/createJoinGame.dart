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
              onSubmitted: (String value) {
                playerName = value;
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  hintText: 'Your Name'
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
                  Navigator.pushReplacementNamed(context, '/gameLobby');
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
              onSubmitted: (String value) {
                gameCode = value;
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  hintText: 'Game Code'
              ),
            ),
            TextField(
              controller: playerName,
              onSubmitted: (String value) {
                playerName = value;
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  hintText: 'Your Name'
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
                  Navigator.pushReplacementNamed(context, '/gameLobby');
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

class GameLobbyPage extends StatefulWidget {
  @override
  _GameLobbyPageState createState() => _GameLobbyPageState();
}

class _GameLobbyPageState extends State<GameLobbyPage> {
  Future<bool> apiSuccess;

  Future<bool> fetchPost() async {
    final response = await http.get('https://x0ldh7067a.execute-api.us-west-2.amazonaws.com/stage');
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
        title: Text("Game Lobby"),
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
          ],
        ),
      ),
    );
  }

}