import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tagge_map/Widgets/Tags/createTagContainer.dart';
import 'package:tagge_map/Pages/addTagPage.dart';
import 'package:http/http.dart' as http;
import 'package:tagge_map/main.dart';

class Tag {
  int id;
  String tagText;
  Color tagColor;
  Tag(this.id, this.tagText, this.tagColor);
}

class SelectCreateTag extends StatefulWidget {
  @override
  _SelectCreateTagState createState() => _SelectCreateTagState();
}

class _SelectCreateTagState extends State<SelectCreateTag> {
  //---------------------declarari-------------------------
  // tags list
  List<Tag> allTags = [];
// create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  List<Tag> alltagscopy;
  int request = 0;

  TextEditingController tagController = new TextEditingController();

//----------------------functii------------------------

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void deleteTag(String token, Tag t) async {
    //in functia asta o sa fac request ul pt ca doar daca sterg de aici vreau sa le sterg de tot
    final addLocation = await http.post(
      'http://192.168.1.15:5000/deleteTag',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
        'id': t.id.toString(),
      }),
    );

    if (addLocation.body == 'deleted') {
      print("tag deleted");
    } else {
      print("not deleted");
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        returnAllTags(token);
      });
    });
  }

  void addTagToTagsList(Tag t) {
    setState(() {
      allTags.add(t);
    });
  }

  //------------------------------------requests----------------------------

  void addTag(String token, String color, String name) async {
    print("TOKEN ADD TAG");
    print(token);
    final addLocation = await http.post(
      'http://192.168.1.15:5000/addtag',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
        'color': color,
        'name': name,
      }),
    );

    if (addLocation.body == 'added') {
      print("added");
    } else {
      print("tag not added in DB");
    }
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
    alltagscopy = [];

    if (r['success'] == 'yes') {
      //daca e succes vreau sa iau lista cu toate

      for (var i = 0; i < r['list'].length; i++) {
        List<String> a = r['list'][i]['color'].split(',');
        Color s = Color.fromRGBO(
            int.parse(a[0]), int.parse(a[1]), int.parse(a[2]), 1);
        Tag t = Tag(r['list'][i]['id'], r['list'][i]['name'], s);
        alltagscopy.add(t);
      }
      print(alltagscopy);
      setState(() {
        allTags = alltagscopy;
      });
    } else {
      print("all tags not loaded");
    }
  }

  void clearTextInput() {
    tagController.clear();
  }

  //-----------------------------------build function------------------------

  @override
  Widget build(BuildContext context) {
    String token = TokenProvider.of(context).getToken();

    if (request == 0) {
      request = 1;
      returnAllTags(token);
    }

    List<CreateTagContainer> tagList = [];

    for (int x = 0; x < allTags.length; x++) {
      tagList.add(CreateTagContainer(
          allTags[x].id, allTags[x].tagText, allTags[x].tagColor, () {
        deleteTag(token, allTags[x]);
      }, () {
        AddTagPageProvider.of(context).addTag(allTags[x]);
      }));
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 10,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text("You can choose from:",
                style: TextStyle(
                  color: Color(0xcc000000),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                )),
          ),
        ),
        SizedBox(height: 5),
        Container(
          // margin: EdgeInsets.all(20),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
            bottom: 10,
          ),
          height: 56.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: tagList,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 5,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              child: Row(
                children: <Widget>[
                  Text(
                    "or you can",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Create a brand new tag",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("How do you feel about this place?"),
                      content: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: tagController,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "This place is ...",
                              ),
                            ),
                            ColorPicker(
                              pickerColor: currentColor,
                              onColorChanged: changeColor,
                              colorPickerWidth: 300.0,
                              pickerAreaHeightPercent: 0.3,
                              enableAlpha: true,
                              displayThumbColor: true,
                              paletteType: PaletteType.hsv,
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        MaterialButton(
                          child: Text(
                            "Drop",
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        MaterialButton(
                          child: Text(
                            "Create",
                          ),
                          onPressed: () {
                            print(pickerColor);
                            String color = pickerColor.red.toString() +
                                "," +
                                pickerColor.green.toString() +
                                "," +
                                pickerColor.blue.toString() +
                                "," +
                                pickerColor.alpha.toString();
                            print(color);
                            addTag(token, color, tagController.text);
                            Future.delayed(const Duration(milliseconds: 200),
                                () {
                              setState(() {
                                request = 0;
                                // returnAllTags(token);
                              });
                            });
                            clearTextInput();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
