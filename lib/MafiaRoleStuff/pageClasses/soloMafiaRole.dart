import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mafia_app/MafiaRoleStuff/argsClasses/mafiaRevealArgs.dart';
import 'package:mafia_app/MafiaRoleStuff/argsClasses/soloMafiaRoleArgs.dart';


class SoloMafiaRole extends StatefulWidget {
  final SoloMafiaRoleArgs args;

  SoloMafiaRole({this.args});

  @override
  State<StatefulWidget> createState() {
    return _SoloMafiaRoleState(args: this.args);
  }
}

class _SoloMafiaRoleState extends State<SoloMafiaRole> {
  SoloMafiaRoleArgs args;
  int roleNum;
  bool isCardSelected = false;

  _SoloMafiaRoleState({this.args});

  List<bool> isCenterButtonEnabled = [true, true, true];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solo Mafia Role'),
      ),
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Container(
                padding: EdgeInsets.all(50),
                child: Text("You are the only mafia! Therefore you are priveledged with viewing one of the center cards! Choose one to continue"),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                _buildCenterCardButton(0),
                _buildCenterCardButton(1),
                _buildCenterCardButton(2),
                Container(
                  child: _buildContinueButton(),
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
              ]
            ),
        ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildContinueButton() {

    return FlatButton (
      color: Colors.red[900],
      textColor: Colors.white,
      disabledColor: Colors.white,
      disabledTextColor: Colors.black,
      padding: EdgeInsets.all(8.0),
      splashColor: Colors.redAccent[700],
      onPressed: this.isCenterButtonEnabled.every((e) => e) ? null : () {
        for (int i = 0; i < 3; i++) {
          if (!this.isCenterButtonEnabled[i]) {
            this.roleNum = i;
            break;
          }
        }
        Navigator.pushReplacementNamed(context, '/mafiaReveal', arguments: MafiaRevealArgs(this.args, this.roleNum));
        return;
      },
      child: isCardSelected ? Text("Continue") : Text("Choose a card to see it's role!"),
    );
  }

  Widget _buildCenterCardButton(int roleNum) {
    return FlatButton(
      color: Colors.grey,
      textColor: Colors.black,
      disabledColor: Colors.blueGrey,
      disabledTextColor: Colors.white,
      padding: EdgeInsets.all(8.0),
      onPressed: this.isCenterButtonEnabled[roleNum] ? () => _centerButtonClicked(roleNum) : null,
      child: Text("Center Card " + (roleNum + 1).toString()), // plus 1 to convert card number from 0 based to 1 based
    );
  }

  void _centerButtonClicked(int roleNum) {
    setState(() {
      for (int i = 0; i < 3; i++) {this.isCenterButtonEnabled[i] = true;}
      this.isCenterButtonEnabled[roleNum] = false;
      this.isCardSelected = true;
    });
  }
}