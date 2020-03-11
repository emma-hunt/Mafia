import 'package:flutter/material.dart';
import 'package:mafia_app/voteLobbyPage.dart';
import 'package:mafia_app/yourRolePage.dart';
import 'package:mafia_app/listRoles.dart';
import 'package:mafia_app/CivilianRole.dart';
import 'createJoinGame.dart';
import 'gameLobby.dart';
import 'yourRolePage.dart';
import 'MafiaRolePages/mafiaRolePage.dart';
import 'MafiaRolePages/soloMafiaRolePage.dart';
import 'MafiaRolePages/mafiaRevealPage.dart';
import 'votePage.dart';
import 'dayNightPolling.dart';
import 'package:mafia_app/session.dart' as session;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mafia',
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
            return MaterialPageRoute(builder: (context) => CreatorGameLobbyPage());
            break;
          case '/joinerGameLobby':
            return MaterialPageRoute(builder: (context) => JoinerGameLobbyPage());
            break;
          case '/mafiaRole':
            return MaterialPageRoute(builder: (context) => MafiaRolePage());
            break;
          case '/soloMafiaRole':
            return MaterialPageRoute(builder: (context) => SoloMafiaRolePage());
            break;
          case '/mafiaReveal':
            MafiaRevealPageArguments arguments = MafiaRevealPageArguments(settings.arguments);
            return MaterialPageRoute(builder: (context) => MafiaRevealPage(arguments));
            break;
          case '/yourRolePage':
            return MaterialPageRoute(builder: (context) => YourRolePage());
            break;
          case '/listRoles':
            return MaterialPageRoute(builder: (context) => ListRolesPage());
            break;
          case '/civilianRole':
            return MaterialPageRoute(builder: (context) => CivilianRolePage());
            break;
          case '/vote':
            return MaterialPageRoute(builder: (context) => VotePage());
            break;
          case '/nightPolling':
            return MaterialPageRoute(builder: (context) => NightPollingPage());
            break;
          case '/dayPolling':
            return MaterialPageRoute(builder: (context) => DayPollingPage());
            break;
          case '/voteLobby':
            VoteLobbyArguments arguments = settings.arguments;
            return MaterialPageRoute(builder: (context) => VoteLobbyPage(arguments));
            break;
          default:
            return MaterialPageRoute(builder: (context) => WelcomePage(title: 'Mafia:Evolved'));
        }
      },
    );
  }
}

class WelcomePage extends StatefulWidget {
  final String title;

  WelcomePage({Key key, this.title}) : super(key: key);

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
                Navigator.pushNamed(context, '/createGame');
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
                Navigator.pushNamed(context, '/joinGame');
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

  @override
  void initState() {
    super.initState();
    session.resetSession();
  }
}
