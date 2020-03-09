import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mafia_app/session.dart' as session;
import 'package:fluttertoast/fluttertoast.dart';


class VotePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _VotePageState();
}

class _VotePageState extends State<VotePage> {
  List<bool> _isCandidateSelected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vote'),
      ),
      body: Column(
        children: <Widget>[
          new Text('Cast your vote for who is a Mafia member!'),
          new Expanded(
              child: new ListView.builder(
                  itemCount: session.playerList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildVoteButton(index);
                  }
                )
          ),
          FlatButton (
            color: Colors.red[900],
            textColor: Colors.white,
            disabledColor: Colors.white,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.redAccent[700],
            onPressed: this._isAnyCandidateSelected() ? this.castVote : null,
            child: this._isAnyCandidateSelected() ? Text("Cast Vote") : Text("Select a player!"),
          )
        ]
      )
    );
  }

  bool _isAnyCandidateSelected() {
    for (int index = 0; index < session.playerList.length; index++) {
      if (_isCandidateSelected[index]) {
        return true;
      }
    }
    return false;
  }

  void castVote() {
    for (int i = 0; i < session.playerList.length; i++) {
      if (this._isCandidateSelected[i]) {
        Fluttertoast.showToast(
          msg: session.playerList[i],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
        break;
      }
    }
  }

  Widget _buildVoteButton(int index) {
    return FlatButton(
      color: Colors.grey,
      textColor: Colors.black,
      disabledColor: Colors.blueGrey,
      disabledTextColor: Colors.white,
      padding: EdgeInsets.all(8.0),
      onPressed: this._isCandidateSelected[index] ? null : () => _selectCandidate(index),
      child: Text(session.playerList[index]), // plus 1 to convert card number from 0 based to 1 based
    );
  }


  void _selectCandidate(int index) {
    setState(() {
      for (int i = 0; i < session.playerList.length; i++) {
          this._isCandidateSelected[i] = false;
      }
      this._isCandidateSelected[index] = true;
    });
  }

  @override
  void initState() {
    for (int i = 0; i < session.playerList.length; i++) {
      this._isCandidateSelected.add(false);
    }
    super.initState();
  }
}