import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mafia_app/MafiaRoleStuff/argsClasses/mafiaRoleArgs.dart';
import 'package:mafia_app/MafiaRoleStuff/argsClasses/soloMafiaRoleArgs.dart';


class MafiaRole extends StatefulWidget {
  final MafiaRoleArgs args;

  MafiaRole({this.args});

  @override
  State<StatefulWidget> createState() {
    return _MafiaRoleState();
  }
}

class _MafiaRoleState extends State<MafiaRole> {
  String otherMafiaName = "loading...";
  bool isContinueButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mafia Role"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(otherMafiaName),
            _buildContinueButton(),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildContinueButton() {
    if (!isContinueButtonEnabled) return CircularProgressIndicator();
    return FlatButton (
      color: Colors.red[900],
      textColor: Colors.white,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      padding: EdgeInsets.all(8.0),
      splashColor: Colors.redAccent[700],
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/');
      },
      child: Text(
        "Continue",
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getOtherMafiaName(widget.args);
  }

  void getOtherMafiaName(MafiaRoleArgs args) async {

    String url = "https://0jdwp56wo2.execute-api.us-west-1.amazonaws.com/dev/role/friends";
    String body = '{"personId": "' + args.personId + '", "gameId": "' + args.gameId + '", "role": "mafia"}';
    print("url: " + url);
    print("body: " + body);
    final response = await http.put(url, body: body);
    if (response.statusCode == 200) {
      print("getOtherMafiaMemberName: " + response.statusCode.toString());
      print(response.body.toString());
      List<dynamic> friends = jsonDecode(response.body)["friends"];

      String otherMafiaPlayerName = "";
      if (friends.isEmpty) {
        print("only one mafia exists... going to soloMafiaRole screen...");
        Navigator.pushReplacementNamed(context, '/soloMafiaRole', arguments: SoloMafiaRoleArgs(args));
        return;

      } else {
        otherMafiaPlayerName = "The other mafia member is: " + friends[0]; //will only ever be one other mafia or none other...
      }

      setState(() {
        this.otherMafiaName = otherMafiaPlayerName;
        this.isContinueButtonEnabled = true;
      });

    }
    else {
      print(response.statusCode);
      print(response.body.toString());
      throw Exception('ERROR: getOtherMafiaMemeberName failed.');
    }
  }
}