import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mafia_app/session.dart' as session;


class ListRolesPage extends StatefulWidget {

  ListRolesPage();

  @override
  _ListRolesPageState createState() => _ListRolesPageState();
}

class _ListRolesPageState extends State<ListRolesPage> {

  @override
  void initState() {
    super.initState();
    print(session.allRoles);
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
                          Navigator.pushReplacementNamed(
                              context, '/yourRolePage');
                        },
                        child: Text('Your Role'),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          // Does nothing: stay on the same page
                          //Navigator.pushReplacementNamed(context, '/listRoles');
                        },
                        child: Text('Roles'),
                      ),
                    ),
                  ],
                ),
                RaisedButton(
                  onPressed: () {
                    Fluttertoast.showToast(
                      msg: "take you to next screen",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  },
                  child: Text('time to sleep...'),
                  //padding : EdgeInsets.fromLTRB(0, 0, 0, 200)
                )
              ]),
        ));
  }
}
