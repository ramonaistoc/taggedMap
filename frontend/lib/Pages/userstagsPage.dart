import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tagge_map/Widgets/Reviews/searchlocaftertag.dart';
import 'package:tagge_map/Widgets/selectTags/containers.dart';
import 'package:tagge_map/main.dart';

class SelectTags extends StatefulWidget {
  @override
  _SelectTagsState createState() => _SelectTagsState();
}

class _SelectTagsState extends State<SelectTags> {
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

  void insertuserstags(String userstags, BuildContext context) async {
    String token = TokenProvider.of(context).getToken();
    final adduserstags = await http.post(
      'http://192.168.1.15:5000/addusertags',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
        'usertags': userstags,
      }),
    );
    if (adduserstags.body == "tagsadded") {
      Navigator.pushNamed(context, '/home');
    } else {
      print("error while adding tags");
    }
  }

  String userstags = "";

  @override
  Widget build(BuildContext context) {
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
    print("users tags");
    print(userstags);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                  margin: EdgeInsets.only(top: 80),
                  width: 0.8 * MediaQuery.of(context).size.width,
                  height: 0.43 * MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 20, bottom: 10),
                        child: Text(
                          "What tags would describe your favourite place?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        width: 270,
                        child: TextField(
                          onSubmitted: (String s) {
                            a = 255; //random.nextInt(255);
                            r = random.nextInt(255);
                            g = random.nextInt(255);
                            b = random.nextInt(255);
                            Color c = Color.fromARGB(a, r, g, b);

                            SearchedContainers newc = SearchedContainers(s, c);
                            userstags += "," + s;
                            addTag(newc);
                            clearTextInput();
                          },
                          controller: searchtext,
                          cursorColor: Colors.purple,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                              hintText: "Enter word here",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        width: 0.7 * MediaQuery.of(context).size.width,
                        height: 40,
                        child: ListView(
                          children: cont,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 60),
                        width: 270,
                        child: Text(
                          "Based on the tags entered, you will be able to see which people have the same location preferences as you. To view the list check \"Find new people\" page",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  )),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              width: 0.4 * MediaQuery.of(context).size.width,
              height: 0.3 * MediaQuery.of(context).size.height,
              child: Image.asset(
                'assets/images/logo.png',
                // width: 100,
                // height: 100,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          insertuserstags(userstags, context);
        },
        backgroundColor: Colors.deepPurple[800],
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
