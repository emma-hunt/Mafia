import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mafia_app/session.dart' as session;

class ListRolesPage extends StatefulWidget {

  ListRolesPage();

  @override
  _ListRolesPageState createState() => _ListRolesPageState();
}

class _ListRolesPageState extends State<ListRolesPage> {
  var roles = new List<String>();

  void createList(){
    List<dynamic> sortedRoles = session.allRoles;
    //sortedRoles..sort((a, b) => a.toString().compareTo(b.toString()));
    int counter = 0;
    String tmpRole = sortedRoles[0];

    for(int i = 0; i < sortedRoles.length; i++){
      String role = sortedRoles[i];
      if(role != tmpRole || i == sortedRoles.length - 1){
        if(i == sortedRoles.length - 1){
          counter++;
        }
        //if(counter != 0){
          this.roles.add( tmpRole + " x" + counter.toString());
          tmpRole = role;
          counter = 1;
        //}
      }
      else{
        counter++;
      }
    }

/*
    for(int i = 0; i < session.allRoles.length; i++){
      String role = session.allRoles[i];
      if(role != tmpRole || i == session.allRoles.length - 1){
        if(i == session.allRoles.length - 1){
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
    */
  }

  @override
  void initState() {
    super.initState();
    print(session.allRoles);
    this.createList();
  }

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
                Column(children: <Widget>[ for(String role in this.roles) Text(role )
              ]),
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
