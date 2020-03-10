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
  List<String> _otherPlayers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vote'),
      ),
      body: Column(
        children: <Widget>[
          new Text('Cast your vote for whoever you want!'),
          Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .6,
            ),
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * .20),
              child: new ListView.builder(
                  itemCount: this._otherPlayers.length,
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
            onPressed: this._isAnyCandidateSelected() ? this._castVote : null,
            child: this._isAnyCandidateSelected() ? Text("Cast Vote") : Text("Select a player!"),
          ),
          FlatButton (
            color: Colors.red[900],
            textColor: Colors.white,
            disabledColor: Colors.white,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.redAccent[700],
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            child: Text("Vote for no one"),
          )
        ]
      )
    );
  }

  bool _isAnyCandidateSelected() {
    for (int index = 0; index < this._otherPlayers.length; index++) {
      if (_isCandidateSelected[index]) {
        return true;
      }
    }
    return false;
  }

  void _castVote() {
    for (int i = 0; i < this._otherPlayers.length; i++) {
      if (this._isCandidateSelected[i]) {
        String candidate = this._otherPlayers[i];
        print("_castVote: will vote for " + candidate);
        Navigator.pushReplacementNamed(context, '/');
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
      child: Text(this._otherPlayers[index]), // plus 1 to convert card number from 0 based to 1 based
    );
  }


  void _selectCandidate(int index) {
    setState(() {
      for (int i = 0; i < this._otherPlayers.length; i++) {
          this._isCandidateSelected[i] = false;
      }
      this._isCandidateSelected[index] = true;
    });
  }

  @override
  void initState() {
    for (int i = 0; i < session.playerList.length; i++) {
      if (session.playerList[i] == session.playerName) continue;
      this._isCandidateSelected.add(false);
      this._otherPlayers.add(session.playerList[i]);
    }
    super.initState();
  }
}