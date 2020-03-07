import 'package:flutter/material.dart';
import 'package:mafia_app/yourRolePage.dart';
import 'package:mafia_app/listRoles.dart';
import 'package:mafia_app/MafiaRoleStuff/argsClasses/mafiaRoleArguments.dart';
import 'package:mafia_app/CivilianStuff/CivilianRole.dart';
import 'package:mafia_app/CivilianStuff/CivilianRoleArgs.dart';
import 'createJoinGame.dart';
import 'gameLobby.dart';
import 'yourRolePage.dart';
import 'MafiaRoleStuff/pageClasses/mafiaRolePage.dart';
import 'MafiaRoleStuff/pageClasses/soloMafiaRolePage.dart';
import 'MafiaRoleStuff/argsClasses/soloMafiaRoleArguments.dart';
import 'MafiaRoleStuff/pageClasses/mafiaRevealPage.dart';
import 'MafiaRoleStuff/argsClasses/mafiaRevealArguments.dart';
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
            final MafiaRoleArguments arguments = settings.arguments;
            return MaterialPageRoute(builder: (context) => MafiaRolePage(arguments: arguments));
            break;
          case '/soloMafiaRole':
            final SoloMafiaRoleArguments arguments = settings.arguments;
            return MaterialPageRoute(builder: (context) => SoloMafiaRolePage(arguments: arguments));
            break;
          case '/mafiaReveal':
            final MafiaRevealArguments arguments = settings.arguments;
            return MaterialPageRoute(builder: (context) => MafiaRevealPage(arguments: arguments));
            break;
          case '/yourRolePage':
            return MaterialPageRoute(builder: (context) => YourRolePage());
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

  @override
  void initState() {
    super.initState();
    session.resetSession();
  }
}
