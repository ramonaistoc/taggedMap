import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tagge_map/Widgets/Reviews/placeContainer.dart';
import 'package:tagge_map/main.dart';

class SearchedContainers {
  String text;
  Color color;
  SearchedContainers(this.text, this.color);
}

class SearchLocationAfterTag extends StatefulWidget {
  @override
  _SearchLocationAfterTagState createState() => _SearchLocationAfterTagState();
}

class _SearchLocationAfterTagState extends State<SearchLocationAfterTag> {
  TextEditingController searchtext = new TextEditingController();
  List<SearchedContainers> searchtags = [];
  var a;
  var r;
  var g;
  var b;
  var random = new Random();
  void addTag(SearchedContainers t) {
    setState(() {
      searchtags.add(t);
    });
  }

  void clearTextInput() {
    searchtext.clear();
  }

  List<String> recommendedLocationsIds = [];

  void recommandedbytag(List<SearchedContainers> searchtags) async {
    List<String> searchedtagtext = [];

    for (var i = 0; i < searchtags.length; i++) {
      searchedtagtext.add(searchtags[i].text);
    }
    print(searchedtagtext);
    print(searchtags);
    print("innnnnn");
    final userID = await http.post('http://192.168.1.15:5000/reviewtag',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'tags': searchedtagtext,
        }));
    print("ouuuuuuuuuuuuuut");
    Map<String, dynamic> r = jsonDecode(userID.body);
    print(r);

    // print(r['list'][1]);
    setState(() {
      print('SEARCH AFTER TAG LISST');
      print(r['list']);
      for (int i = 0; i < r['place_ids'].length; ++i) {
        print(r['list'][i]);
        recommendedLocationsIds.add(r['place_ids'][i]);
      }
      print('A MERS ASTA');
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> recommendedPlacesWidgets = [];
    for (int i = 0; i < recommendedLocationsIds.length; ++i) {
      print('ReCOMANdATIOn searh tag');
      print(i);
      print(recommendedLocationsIds[i]);
      recommendedPlacesWidgets.add(PlaceContainer(recommendedLocationsIds[i]));
    }

    String token = TokenProvider.of(context).getToken();
    List<Container> cont = [];

    for (var i = 0; i < searchtags.length; i++) {
      Container t = new Container(
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          color: searchtags[i].color,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(right: 10),
        child: Row(
          children: <Widget>[
            Text(
              searchtags[i].text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  searchtags.removeWhere((element) =>
                      (element.text == searchtags[i].text &&
                          element.color == searchtags[i].color));
                });
              },
              child: Icon(
                Icons.clear,
                color: Colors.white,
                size: 12,
              ),
            ),
          ],
        ),
      );
      cont.add(t);
    }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 1,
                    offset: Offset(0, 0),
                    color: Colors.grey[400],
                    blurRadius: 1,
                  )
                ],
              ),
              width: MediaQuery.of(context).size.width * .9,
              child: TextField(
                onSubmitted: (String s) {
                  a = 255; //random.nextInt(255);
                  r = random.nextInt(255);
                  g = random.nextInt(255);
                  b = random.nextInt(255);
                  Color c = Color.fromARGB(a, r, g, b);

                  SearchedContainers newc = SearchedContainers(s, c);

                  addTag(newc);
                  clearTextInput();
                },
                controller: searchtext,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter tag name ',
                ),
              ),
            ),
            //listview cu taguri
            Container(
              margin: EdgeInsets.only(top: 20),
              width: 0.9 * MediaQuery.of(context).size.width,
              height: 40,
              child: ListView(
                children: cont,
                scrollDirection: Axis.horizontal,
              ),
            ),
            Container(
              width: 0.8 * MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(right: 25, left: 25, top: 20),
              child: FlatButton(
                color: Color(0xFF96616B),
                child: Text(
                  "See recommanded locations",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  print("here pressed");
                  recommandedbytag(searchtags);
                },
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(
                  // bottom: 20,
                  top: 15,
                  left: 10,
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
            ),
            Column(children: recommendedPlacesWidgets),
          ],
        ),
      ),
    );
  }
}
