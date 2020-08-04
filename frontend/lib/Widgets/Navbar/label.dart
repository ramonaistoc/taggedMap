import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tagge_map/Widgets/Tags/TagList_CreateTag.dart';
import 'package:tagge_map/Widgets/Tags/tagContainerWithoutX.dart';
import 'package:tagge_map/main.dart';
import 'package:http/http.dart' as http;

class Labels extends StatefulWidget {
  final int id;
  final Function filterLocations;
  Labels(this.id, this.filterLocations);
  @override
  _LabelsState createState() => _LabelsState(this.id, this.filterLocations);
}

class _LabelsState extends State<Labels> {
  List<Tag> allTags = [];
  List<Tag> allTagscopy = [];
  int doneReq = 0;
  var id;
  Function filterLocations;
  _LabelsState(this.id, this.filterLocations);
  var x = 1;

  List<int> tagIdsFiltering = [];
  List<int> tagIdsRemaining = [];

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

  void returnFriendAllTags(String token, int id) async {
    print("RETURN ALL TAGS");
    var alltags = await http.post(
      'http://192.168.1.15:5000/returnalltags_friend',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        // 'token': token,
        'id': id.toString()
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

  void addFilter(int id) {
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
    filterLocations(filterIds);
  }

  void removeFilter(int id) {
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
    filterLocations(filterIds);
  }

  @override
  Widget build(BuildContext context) {
    print(tagIdsFiltering);

    String token = TokenProvider.of(context).getToken();
    if (doneReq == 0) {
      doneReq = 1;

      print("hhhhhh");
      print(token);
      print(id);
      if (id == null) {
        returnAllTags(token);
      } else {
        returnFriendAllTags(token, id);
      }
    }

    List<Widget> tagContainers = [];

    for (var i = 0; i < tagIdsRemaining.length; i++) {
      int x = tagIdsRemaining[i];
      tagContainers.add(
        InkWell(
          onTap: () {
            addFilter(x);
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
            removeFilter(x);
          },
          child: TagContainerWithoutX(
              allTags[x].id, allTags[x].tagText, allTags[x].tagColor, () {},
              () {
            // addTag(locationTags[x]);
          }),
        ),
      );
    }

    return Container(
      decoration: new BoxDecoration(
        color: Color(0xFF52489C),
        borderRadius: new BorderRadius.all(
          Radius.circular(30.0),
        ),
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            offset: Offset(0, 0),
            color: Colors.grey[400],
            blurRadius: 2,
          )
        ],
      ),
      width: 0.9 * MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
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
                color: Colors.white,
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
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
              top: 15,
              left: 15,
            ),
            child: Text(
              'Select from:',
              style: TextStyle(
                color: Colors.white,
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
        ],
      ),
    );
  }
}
