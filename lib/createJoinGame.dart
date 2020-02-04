import 'package:flutter/material.dart';

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
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  hintText: 'Your Name'
              ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
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
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  hintText: 'Game Code'
              ),
            ),
            TextField(
              controller: playerName,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  hintText: 'Your Name'
              ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}