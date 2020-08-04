import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tagge_map/main.dart';
import 'package:http/http.dart' as http;

class LocationCommments extends StatefulWidget {
  String locationArgument;
  LocationCommments(locationArgument);

  @override
  _LocationCommmentsState createState() =>
      _LocationCommmentsState(this.locationArgument);
}

class _LocationCommmentsState extends State<LocationCommments> {
  TextEditingController commentsController = new TextEditingController();
  String locationArgument;
  _LocationCommmentsState(this.locationArgument);
  Widget successContainer = Container();
  String token;

  @override
  Widget build(BuildContext context) {
    token = TokenProvider.of(context).getToken();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            height: 0.1 * MediaQuery.of(context).size.height,
            width: 0.9 * MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 20),
            child: Flexible(
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                controller: commentsController,
                style: TextStyle(fontSize: 14),
                onTap: () {
                  print(commentsController);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "Write a comment... ",
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.only(right: 25),
            child: FlatButton(
              color: Color(0xFF52489C),
              textColor: Colors.white,
              padding: EdgeInsets.only(
                left: 5.0,
                right: 5.0,
              ),
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              child: Text(
                "Add review",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
