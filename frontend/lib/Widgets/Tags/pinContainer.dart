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
  int seen = 0;
  String photoref = "";
  String phcopy = "";
  Image photo;
  String lastid = "";
  int r = 0;
  List<Tag> allTags = [];
  List<Tag> allTagscopy = [];
  String review = "";
  String token;

  void getLocationInfo() async {
    print("get location info");
    print(placeid);
    final locationID = await http.post(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=' +
            placeid +
            '&fields=name,photo,formatted_address&key=KEY',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: "");

    Map<String, dynamic> a = jsonDecode(locationID.body);
    // print(a);
    lcopy = a['result']['name'];
    acopy = a['result']['formatted_address'];
    phcopy = a['result']['photos'][0]['photo_reference'];
    print("////////////////////////////////////GET LOCATION");
    print(lcopy);
    print(acopy);
    print(phcopy);
    // final ph = await http.post(
    //     'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photreference' +
    //         phcopy +
    //         '&key=KEY',
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: "");
    // Map<String, dynamic> p = jsonDecode(ph.body);
    // print(ph.body);
    print("---------------------------------------");
    setState(() {
      locationName = lcopy;
      locationAddress = acopy;
      //   photoref = p; //phcopy;
      //   print("////////////////////////////////////GET LOCATION222222222");
      //   print(locationName);
      //   print(locationAddress);
      //   // print(photoref);
    });
  }

  void returnAllTags(String token, String placeid) async {
    print("RETURN ALL TAGS");
    var alltags = await http.post(
      //returnez tagurile + review
      'http://192.168.1.15:5000/returntagsforlocation',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
        'placeid': placeid,
      }),
    );
    Map<String, dynamic> r = jsonDecode(alltags.body);
    allTagscopy = [];

    if (r['success'] == 'yes') {
      //daca e succes vreau sa iau lista cu toate
      for (var i = 0; i < r['list'].length; i++) {
        List<String> a = r['list'][i]['color'].split(',');
        Color s = Color.fromRGBO(
            int.parse(a[0]), int.parse(a[1]), int.parse(a[2]), 1);
        Tag t = Tag(r['list'][i]['id'], r['list'][i]['name'], s);
        print(t.id);
        allTagscopy.add(t);
      }
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          allTags = allTagscopy;
          // print("ALL TAGS LOCATION");
          // print(allTags);
          review = r['review'];
        });
      });
    } else {
      print("all tags not loaded");
    }
  }

  void returnAllFriendTags(String token, String placeid, int id) async {
    print("RETURN ALL TAGS");
    var alltags = await http.post(
      //returnez tagurile + review
      'http://192.168.1.15:5000/returntagsforlocation_friend',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
        'placeid': placeid,
        'id': id.toString(),
      }),
    );
    Map<String, dynamic> r = jsonDecode(alltags.body);
    allTagscopy = [];

    if (r['success'] == 'yes') {
      //daca e succes vreau sa iau lista cu toate
      for (var i = 0; i < r['list'].length; i++) {
        List<String> a = r['list'][i]['color'].split(',');
        Color s = Color.fromRGBO(
            int.parse(a[0]), int.parse(a[1]), int.parse(a[2]), 1);
        Tag t = Tag(r['list'][i]['id'], r['list'][i]['name'], s);
        print(t.id);
        allTagscopy.add(t);
      }
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          allTags = allTagscopy;
          // print("ALL TAGS LOCATION");
          // print(allTags);
          review = r['review'];
        });
      });
    } else {
      print("all tags not loaded");
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(phcopy);
    token = TokenProvider.of(context).getToken();
    if (seen == 0) {
      seen = 1;
      print("PHAOCOCOAPCPC");
      getLocationInfo();
    }
    if (r == 0) {
      r = 1;
      if (id == null) {
        returnAllTags(token, placeid);
      } else {
        returnAllFriendTags(token, placeid, id);
      }
    }
    List<TagContainerWithoutX> tagContainers = [];

    for (var x = 0; x < allTags.length; x++) {
      tagContainers.add(
        TagContainerWithoutX(
            allTags[x].id, allTags[x].tagText, allTags[x].tagColor, () {}, () {
          // addTag(locationTags[x]);
        }),
      );
    }
    print('redered');
    return Container(
      decoration: new BoxDecoration(
        color: Color(0xFF52489C),
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
                          child: Flexible(
                            child: Text(
                              locationName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        this.id == null
                            ? InkWell(
                                onTap: () {
                                  var location = {
                                    'name': locationName,
                                    'formatted_address': locationAddress,
                                    'tags': allTags,
                                    'review': review,
                                    'phcopy': phcopy,
                                  };
                                  Navigator.pushNamed(
                                      context, '/addtagpageLocation',
                                      arguments: location);
                                },
                                child: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      child: Text(
                        locationAddress,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Flexible(
                flex: 2,
                child: Container(
                  width: 95.0,
                  height: 75.0,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(
                          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" +
                              phcopy +
                              "&key=KEY"),
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
              Container(
                height: 40,
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: tagContainers,
                ),
              ),
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
