import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tagge_map/Widgets/Tags/LocationTagsList.dart';
import 'package:tagge_map/Widgets/Tags/TagList_CreateTag.dart';
import 'package:tagge_map/Widgets/Tags/tagContainerWithoutX.dart';
import 'package:tagge_map/main.dart';

class MarkContainer extends StatefulWidget {
  final String placeid;
  var id;
  MarkContainer(this.placeid, this.id);

  @override
  _MarkContainerState createState() =>
      _MarkContainerState(this.placeid, this.id);
}

class _MarkContainerState extends State<MarkContainer> {
  final String placeid;
  var id;
  _MarkContainerState(this.placeid, this.id);

  String locationName = "";
  String locationAddress = "";
  String acopy = "";
  String lcopy = "";
  var seen = 0;
  String photoref = "";
  String phcopy = "";
  Image photo;
  String lastid = "";
  var r = 0;
  List<Tag> allTags = [];
  List<Tag> allTagscopy = [];
  String review = "";
  String token;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.red, //Color(0xFF52489C),
        borderRadius: new BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      // height: 0.4 * MediaQuery.of(context).size.height,
      width: 0.9 * MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          // width: 0.6 * MediaQuery.of(context).size.width,
                          child: Text(
                            locationName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            var location = {
                              'name': locationName,
                              'formatted_address': locationAddress,
                              'tags': allTags,
                              'review': review,
                            };
                            Navigator.pushNamed(context, '/addtagpageLocation',
                                arguments: location);
                          },
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      // width: 0.5 * MediaQuery.of(context).size.width,
                      // width: double.infinity,
                      // width: ,
                      // child: Flexible(
                      child: Text(
                        locationAddress,
                        style: TextStyle(color: Colors.white),
                      ),

                      // ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Flexible(
                flex: 2,
                child: Container(
                  // margin: EdgeInsets.only(
                  //   left: 30,
                  //   top: 20,
                  //   bottom: 5,
                  //   right: 15,
                  // ),
                  width: 90.0,
                  height: 70.0,
                  decoration: new BoxDecoration(
                    // shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(
                          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" +
                              phcopy +
                              "&key=yourkey"),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 0.8 * MediaQuery.of(context).size.width,
                child: Text(
                  "Location tags:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              // Container(
              //   height: 40,
              //   margin: EdgeInsets.symmetric(
              //     vertical: 10,
              //   ),
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: tagContainers,
              //   ),
              // ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                width: 0.8 * MediaQuery.of(context).size.width,
                child: Text(
                  "Location review:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Container(
                width: 0.8 * MediaQuery.of(context).size.width,
                child: Text(
                  "\" " + review + " \"",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
