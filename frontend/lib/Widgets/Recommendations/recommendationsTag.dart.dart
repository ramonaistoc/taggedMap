import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tagge_map/Widgets/Tags/TagList_CreateTag.dart';
import 'package:tagge_map/Widgets/Tags/tagContainerWithoutX.dart';
import 'package:tagge_map/Widgets/Reviews/placeContainer.dart';
import 'package:tagge_map/main.dart';
import 'package:http/http.dart' as http;

class ReviewTag extends StatefulWidget {
  @override
  _ReviewTagState createState() => _ReviewTagState();
}

class _ReviewTagState extends State<ReviewTag> {
  List<Tag> allTags = [];
  List<Tag> allTagscopy = [];
  int doneReq = 0;

  var x = 1;

  List<int> tagIdsFiltering = [];
  List<int> tagIdsRemaining = [];

  List<String> recommendedLocationsIds = [];

  Future<void> filterLocations(String token, List<int> ids) async {
    print("asdsdsadasdas");
    var alltags = await http.post(
      'http://192.168.1.15:5000/reviewdefault',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'list_ids': ids,
        'token': token,
      }),
    );
    Map<String, dynamic> r = jsonDecode(alltags.body);
    print('APEL PT RECOMENDATIOND');
    print(r);
    setState(() {
      print('SETTTING LISST');
      print(r['list']);
      recommendedLocationsIds = [];
      for (int i = 0; i < r['list'].length; ++i) {
        recommendedLocationsIds.add(r['list'][i]);
      }
      print('A MERS ASTA');
    });
  }

  void returnAllTags(String token) async {
    print("RETURN ALL TAGS");
    var alltags = await http.post(
      'http://192.168.1.15:5000/returnalltags',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
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
      // print(alltagscopy);

      setState(() {
        allTags = allTagscopy;
        for (int i = 0; i < allTagscopy.length; ++i) {
          tagIdsRemaining.add(i);
        }
      });
    } else {
      print("all tags not loaded");
    }
  }

  void addFilter(String token, int id) {
    setState(() {
      tagIdsRemaining.remove(id);
      tagIdsFiltering.add(id);
      tagIdsFiltering.sort();
      tagIdsRemaining.sort();
    });
    List<int> filterIds = [];
    for (int i = 0; i < tagIdsFiltering.length; ++i) {
      filterIds.add(allTags[tagIdsFiltering[i]].id);
    }
    filterLocations(token, filterIds);
  }

  void removeFilter(String token, int id) {
    setState(() {
      tagIdsFiltering.remove(id);
      tagIdsRemaining.add(id);
      tagIdsFiltering.sort();
      tagIdsRemaining.sort();
    });
    List<int> filterIds = [];
    for (int i = 0; i < tagIdsFiltering.length; ++i) {
      filterIds.add(allTags[tagIdsFiltering[i]].id);
    }
    filterLocations(token, filterIds);
  }

  @override
  Widget build(BuildContext context) {
    print(tagIdsFiltering);

    String token = TokenProvider.of(context).getToken();
    if (doneReq == 0) {
      print("hhhhhh");
      print(doneReq);
      doneReq = 1;

      returnAllTags(token);
    }

    List<Widget> tagContainers = [];

    for (var i = 0; i < tagIdsRemaining.length; i++) {
      int x = tagIdsRemaining[i];
      tagContainers.add(
        InkWell(
          onTap: () {
            addFilter(token, x);
          },
          child: TagContainerWithoutX(
              allTags[x].id, allTags[x].tagText, allTags[x].tagColor, () {},
              () {
            // addTag(locationTags[x]);
          }),
        ),
      );
    }

    List<Widget> tagContainersFiltering = [];

    for (var i = 0; i < tagIdsFiltering.length; i++) {
      int x = tagIdsFiltering[i];
      tagContainersFiltering.add(
        InkWell(
          onTap: () {
            removeFilter(token, x);
          },
          child: TagContainerWithoutX(
              allTags[x].id, allTags[x].tagText, allTags[x].tagColor, () {},
              () {
            // addTag(locationTags[x]);
          }),
        ),
      );
    }

    List<Widget> recommendedPlacesWidgets = [];
    for (int i = 0; i < recommendedLocationsIds.length; ++i) {
      print('ReCOMANdATIOn IIIII');
      print(i);
      print(recommendedLocationsIds[i]);
      recommendedPlacesWidgets.add(PlaceContainer(recommendedLocationsIds[i]));
    }

    return Container(
      // decoration: new BoxDecoration(
      //   color: Color(0xFF52489C),
      //   borderRadius: new BorderRadius.all(
      //     Radius.circular(30.0),
      //   ),
      //   boxShadow: [
      //     BoxShadow(
      //       spreadRadius: 2,
      //       offset: Offset(0, 0),
      //       color: Colors.grey[400],
      //       blurRadius: 2,
      //     )
      //   ],
      // ),
      height: 0.3 * MediaQuery.of(context).size.height,
      width: 0.9 * MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
              top: 15,
              left: 15,
            ),
            child: Text(
              "Your tags: ",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            height: 40,
            margin: EdgeInsets.only(
              bottom: 20,
              top: 20,
              left: 10,
              right: 10,
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: tagContainersFiltering,
            ),
          ),
          Container(
            width: 80,
            margin: EdgeInsets.only(right: 25, left: 25),
            child: FlatButton(
              color: Color(0xFF96616B),
              onPressed: () {
                List<int> filterIds = [];
                for (int i = 0; i < tagIdsFiltering.length; ++i) {
                  filterIds.add(allTags[tagIdsFiltering[i]].id);
                }
                filterLocations(token, filterIds);
                // filterLocations(token, filterIds);
              },
              child: Text(
                "See recommanded locations",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
              top: 15,
              left: 15,
            ),
            child: Text(
              'Select from:',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            height: 40,
            margin: EdgeInsets.only(
              bottom: 20,
              top: 20,
              left: 10,
              right: 10,
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: tagContainers,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              // bottom: 20,
              // top: 20,
              left: 15,
              // right: 10,
            ),
            child: Text(
              'Recommandations based on selected tags:',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Column(children: recommendedPlacesWidgets),
        ],
      ),
    );
  }
}
