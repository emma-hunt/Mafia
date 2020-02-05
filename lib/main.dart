import 'package:flutter/material.dart';
import 'createJoinGame.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: WelcomePage(title: 'Mafia: Evolved'),
      routes: {
        '/createGame' : (context) => CreateGamePage(),
        '/joinGame' : (context) => JoinGamePage(),
        '/gameLobby' : (context) => GameLobbyPage(),
      },
    );
  }
}

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton (
              color: Colors.red[900],
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.redAccent[700],
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/createGame');
              },
              child: Text(
                "Create Game",
              ),
            ),
            FlatButton (
              color: Colors.red[900],
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.redAccent[700],
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/joinGame');
              },
              child: Text(
                "Join Game",
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
