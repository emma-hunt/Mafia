import 'package:flutter/material.dart';
import 'package:mafia_app/yourRolePage.dart';
import 'package:mafia_app/listRoles.dart';
import 'package:mafia_app/CivilianStuff/CivilianRole.dart';
import 'package:mafia_app/CivilianStuff/CivilianRoleArgs.dart';
import 'createJoinGame.dart';
import 'gameLobby.dart';
import 'yourRolePage.dart';
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
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => WelcomePage(title: 'Mafia:Evolved'));
            break;
          case '/createGame':
            return MaterialPageRoute(builder: (context) => CreateGamePage());
            break;
          case '/joinGame':
            return MaterialPageRoute(builder: (context) => JoinGamePage());
            break;
          case '/creatorGameLobby':
            final CreateGameArguments arguments = settings.arguments;
            return MaterialPageRoute(builder: (context) => CreatorGameLobbyPage(args: arguments));
            break;
          case '/joinerGameLobby':
            final JoinGameArguments arguments = settings.arguments;
            return MaterialPageRoute(builder: (context) => JoinerGameLobbyPage(args: arguments));
            break;
          case '/yourRolePage':
            final YourRoleArguments arguments = settings.arguments;
            return MaterialPageRoute(builder: (context) => YourRolePage(args: arguments));
            break;
          case '/listRoles':
            final ListRolesArguments arguments = settings.arguments;
            return MaterialPageRoute(builder: (context) => ListRolesPage(args: arguments));
            break;
          case '/civilianRole':
            final CivilianRoleArgs arguments = settings.arguments;
            return MaterialPageRoute(builder: (context) => CivilianRole(args: arguments));
            break;
          default:
            return MaterialPageRoute(builder: (context) => WelcomePage(title: 'Mafia:Evolved'));
        }
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
            FlatButton (
              color: Colors.red[900],
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.redAccent[700],
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/civilianRole');
              },
              child: Text(
                "Civilian Role",
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
