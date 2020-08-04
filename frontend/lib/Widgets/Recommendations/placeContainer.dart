import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tagge_map/Widgets/Tags/TagList_CreateTag.dart';
import 'package:tagge_map/Widgets/Tags/tagContainerWithoutX.dart';
import 'package:tagge_map/main.dart';
import 'package:http/http.dart' as http;

class PlaceContainer extends StatefulWidget {
  final String placeId;
  PlaceContainer(this.placeId);
  @override
  _PlaceContainerState createState() => _PlaceContainerState(this.placeId);
}

class _PlaceContainerState extends State<PlaceContainer> {
  String placeId;
  String formattedAddress = '', name = '', photoReferece = '';

  _PlaceContainerState(this.placeId) {
    makeRequest();
  }

  void makeRequest() async {
    var locationID = await http.post(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=' +
            placeId +
            '&fields=name,photo,formatted_address&key=KEY',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: "");

    Map<String, dynamic> a = jsonDecode(locationID.body);
    print(a);
    print('REQUEST MADE');
    setState(() {
      formattedAddress = a['result']['formatted_address'];
      name = a['result']['name'];
      photoReferece = a['result']['photos'][0]['photo_reference'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget photo = Container();
    if (photoReferece != '') {
      photo = Container(
        // margin: EdgeInsets.only(
        //   // left: 30,
        //   // top: 20,
        //   bottom: 10,
        //   // right: 10,
        // ),
        width: 80.0,
        height: 70.0,
        decoration: new BoxDecoration(
          // shape: BoxShape.circle,
          image: new DecorationImage(
            fit: BoxFit.fill,
            image: new NetworkImage(
                "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" +
                    photoReferece +
                    "&key=KEY"),
          ),
        ),
      );
    }
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/addtag', arguments: Null);
      },
      child: Container(
        decoration: BoxDecoration(
          // color: Color(0x88F4D35E),
          color: Colors.pink[50],
          borderRadius: new BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          top: 20,
          // left: 20,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 0.57 * MediaQuery.of(context).size.width,
              child: Flexible(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(formattedAddress),
                    // SeparatorLine(),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            photo,
          ],
        ),
      ),
    );
  }
}
