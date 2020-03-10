import 'package:flutter/material.dart';
import 'package:mafia_app/session.dart' as session;

class SoloMafiaRolePage extends StatefulWidget {

  SoloMafiaRolePage();

  @override
  State<StatefulWidget> createState() {
    return _SoloMafiaRolePageState();
  }
}

class _SoloMafiaRolePageState extends State<SoloMafiaRolePage> {
  int _roleNum;
  bool _isCardSelected = false;
  List<bool> _isCenterButtonEnabled = [true, true, true];

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

  Widget _buildContinueButton() {
    return FlatButton (
      color: Colors.red[900],
      textColor: Colors.white,
      disabledColor: Colors.white,
      disabledTextColor: Colors.black,
      padding: EdgeInsets.all(8.0),
      splashColor: Colors.redAccent[700],
      onPressed: this._isCenterButtonEnabled.every((e) => e) ? null : () {
        for (int i = 0; i < 3; i++) {
          if (!this._isCenterButtonEnabled[i]) {
            this._roleNum = i;
            break;
          }
        }
        Navigator.pushReplacementNamed(context, '/mafiaReveal', arguments: _roleNum);
        return;
      },
      child: _isCardSelected ? Text("Continue") : Text("Choose a card to see it's role!"),
    );
  }

  Widget _buildCenterCardButton(int roleNum) {
    return FlatButton(
      color: Colors.grey,
      textColor: Colors.black,
      disabledColor: Colors.blueGrey,
      disabledTextColor: Colors.white,
      padding: EdgeInsets.all(8.0),
      onPressed: this._isCenterButtonEnabled[roleNum] ? () => _centerButtonClicked(roleNum) : null,
      child: Text("Center Card " + (roleNum + 1).toString()), // plus 1 to convert card number from 0 based to 1 based
    );
  }

  void _centerButtonClicked(int roleNum) {
    setState(() {
      for (int i = 0; i < 3; i++) {this._isCenterButtonEnabled[i] = true;}
      this._isCenterButtonEnabled[roleNum] = false;
      this._isCardSelected = true;
    });
  }
}