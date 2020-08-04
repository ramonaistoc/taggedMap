import 'package:flutter/material.dart';

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  Widget container = Container();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.limeAccent[400],
        title: Text("Application Settings"),
      ),
      body: Container(
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 25,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Text(
                      "Tags",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () {
                      container = Container(
                        width: 30,
                        height: 40,
                        color: Colors.blueGrey,
                      );
                    },
                  ),
                  Text(
                    "@typetag",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ]),
            container,
            Text(
              "Map pin size",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            Text(
              "Map settings",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
