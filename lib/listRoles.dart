import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mafia_app/createJoinGame.dart';

class ListRolesArguments{
  final List<dynamic> allRoles;
  ListRolesArguments(this.allRoles){
    allRoles.sort((a, b) => a.toString().compareTo(b.toString()));
  }
}

class ListRolesPage extends StatefulWidget {
  final ListRolesArguments args;
  ListRolesPage({this.args});


  @override
  _ListRolesPageState createState() => _ListRolesPageState();
}

class _ListRolesPageState extends State<ListRolesPage> {
  var roles = new List<String>();

  @override
  void initState() {
    super.initState();
    this.createList();
  }

  void createList(){
    String tmpRole = widget.args.allRoles[0];
    int counter = 0;

    for(int i = 0; i < widget.args.allRoles.length; i++){
      String role = widget.args.allRoles[i];
      if(role != tmpRole || i == widget.args.allRoles.length - 1){
        if(i == widget.args.allRoles.length - 1){
          counter++;
        }
        this.roles.add( tmpRole + " x" + counter.toString());
        tmpRole = role;
        counter = 1;
      }
      else{
        counter++;
      }
    }
  }

  // c,c,m,m

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Roles for this game"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Your Role'),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          // Does nothing: stay on the same page
                        },
                        child: Text('All Roles'),
                      ),
                    ),
                  ],
                ),
                Column(children: <Widget>[ for(String role in this.roles) Text (role) ]),
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  child: Text('back to role'),
                  //padding : EdgeInsets.fromLTRB(0, 0, 0, 200)
                )
              ]),
        ));
  }
}
