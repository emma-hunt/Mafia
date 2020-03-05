import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mafia_app/createJoinGame.dart';



class ListRolesArguments{
  final List<dynamic> allRoles;
  var roles = new List();
  ListRolesArguments(this.allRoles){
    //allRoles.sort((a, b) => a.toString().compareTo(b.toString()));

    String tmpRole = "";
    int counter = 0;
    for(var role in allRoles){
      this.roles.add(role);
      /*
      if(role != tmpRole){
        roles.add(role + " x" + counter);
        counter = 0;
        tmpRole = role;
      }
      else{
        counter++;
      }
      */
    }
  }
}

class ListRolesPage extends StatefulWidget {
  final ListRolesArguments args;
  ListRolesPage({this.args});

  @override
  _ListRolesPageState createState() => _ListRolesPageState();
}

class _ListRolesPageState extends State<ListRolesPage> {

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
                Column(children: <Widget>[ Text(widget.args.roles.toString()), for(String role in widget.args.allRoles) Text (role) ]),
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
