import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tagge_map/Pages/homePage.dart';
import 'package:tagge_map/Widgets/Tags/LocationTitleAddTag.dart';
import 'package:tagge_map/Widgets/Tags/TagList_CreateTag.dart';
import 'package:tagge_map/Widgets/SeparatorLine.dart';
import 'package:tagge_map/Widgets/Tags/LocationTagsList.dart';
import 'package:tagge_map/Widgets/Tags/LocationComments.dart';
import 'package:http/http.dart' as http;
import 'package:tagge_map/main.dart';

class AddTagPage extends StatefulWidget {
  final dynamic locationArgument;
  AddTagPage(this.locationArgument);

  @override
  _AddTagPageState createState() => _AddTagPageState(locationArgument);
}

class _AddTagPageState extends State<AddTagPage> {
  final dynamic locationArgument;
  _AddTagPageState(this.locationArgument) {}

  String locationAddress = '';
  TextEditingController commentsController = new TextEditingController();

  List<Tag> locationTags = [];

  void addTagToList(Tag t) {
    setState(() {
      locationTags.add(t);
    });
  }

  List<Tag> returnLocationTags() {
    return locationTags;
  }

  void deleteTag(String s, Color c) {
    setState(() {
      locationTags.removeWhere(
          (element) => element.tagColor == c && element.tagText == s);
    });
  }

  void addLocationTagsDB(
      String token, List<Tag> lo, dynamic locationArgument, String text) async {
    List<int> l = [];
    print("TTTTTTTTTT");
    for (var i = 0; i < locationTags.length; i++) {
      print(locationTags[i].id);
      l.add(locationTags[i].id);
    }
    final addLocation = await http.post(
      'http://192.168.1.15:5000/addplacestags',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'token': token,
        'id': l,
        'place_id': locationArgument['place_id'],
        'text': text
      }),
    );
    print("PAS 3");
    if (addLocation.body == 'DB') {
      print("added");
    } else {
      print("tag not added in DB");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(locationArgument);
    String token = TokenProvider.of(context).getToken();
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  spreadRadius: 4,
                  offset: Offset(0, 0),
                  color: Colors.grey[400],
                  blurRadius: 4,
                )
              ],
              color: Color(0xFF52489C),
            ),
            padding: EdgeInsets.only(
              top: 20,
              bottom: 20,
              left: 10,
              right: 30,
            ),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  child: Text(
                    "SAVE THIS LOCATION",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 2),
                    child: InkWell(
                      onTap: () {
                        print("duaaa");
                        addLocationTagsDB(token, locationTags, locationArgument,
                            commentsController.text);
                        Future.delayed(const Duration(milliseconds: 600), () {
                          Navigator.pushNamed(context, '/home');
                        });
                        //addlocation(getUserToken, locationArgument['place_id']);
                      },
                      child: Text(
                        "SAVE",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // height: MediaQuery.of(context).size.height - 64,
            child: Container(
              // color: Color(0xff31081F),
              child: ListView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  LocationTitle(locationArgument),
                  SizedBox(height: 30),
                  AddTagPageProvider(
                    getTags: returnLocationTags,
                    addTag: addTagToList,
                    removeTag: deleteTag,
                    child: TagList(),
                  ),
                  // SeparatorLine(),
                  AddTagPageProvider(
                    getTags: returnLocationTags,
                    addTag: addTagToList,
                    removeTag: deleteTag,
                    child: SelectCreateTag(),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 250,
                      width: 0.9 * MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 20, top: 40),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              'Enrich it with a comment',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 4,
                            controller: commentsController,
                            style: TextStyle(fontSize: 14),
                            onTap: () {
                              print(commentsController);
                            },
                            onChanged: (text) {
                              commentsController.text = text.substring(0, 150);
                              commentsController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: commentsController.text.length));
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.yellow[50],
                              hoverColor: Colors.pink[50],
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                              // focusedBorder: OutlineInputBorder(
                              //   borderRadius: new BorderRadius.all(
                              //     Radius.circular(30.0),
                              //   ),
                              // ),
                              // enabledBorder: InputBorder.none,
                              // errorBorder: InputBorder.none,
                              // disabledBorder: InputBorder.none,
                              hintText: "My time here was ... ",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(title: Text('New location'), actions: <Widget>[
    //     // action button
    //     IconButton(
    //       icon: Icon(Icons.check),
    //       onPressed: () {
    //         print("duaaa");
    //         addLocationTagsDB(
    //             token, locationTags, locationArgument, commentsController.text);
    //         Future.delayed(const Duration(milliseconds: 600), () {
    //           Navigator.pushNamed(context, '/home');
    //         });
    //         //addlocation(getUserToken, locationArgument['place_id']);
    //       },
    //     ),
    //   ]),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: <Widget>[
    //         LocationTitle(locationArgument),
    //         SeparatorLine(),
    //         AddTagPageProvider(
    //             getTags: returnLocationTags,
    //             addTag: addTagToList,
    //             removeTag: deleteTag,
    //             child: TagList()),
    //         SeparatorLine(),
    //         AddTagPageProvider(
    //           getTags: returnLocationTags,
    //           addTag: addTagToList,
    //           removeTag: deleteTag,
    //           child: SelectCreateTag(),
    //         ),
    //         SeparatorLine(),
    //         Align(
    //           alignment: Alignment.topLeft,
    //           child: Container(
    //             height: 0.1 * MediaQuery.of(context).size.height,
    //             width: 0.9 * MediaQuery.of(context).size.width,
    //             padding: EdgeInsets.only(left: 20),
    //             child: Flexible(
    //               child: TextField(
    //                 keyboardType: TextInputType.multiline,
    //                 maxLines: 4,
    //                 controller: commentsController,
    //                 style: TextStyle(fontSize: 14),
    //                 onTap: () {
    //                   print(commentsController);
    //                 },
    //                 decoration: InputDecoration(
    //                   border: InputBorder.none,
    //                   focusedBorder: InputBorder.none,
    //                   enabledBorder: InputBorder.none,
    //                   errorBorder: InputBorder.none,
    //                   disabledBorder: InputBorder.none,
    //                   hintText: "Write a comment... ",
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //         // Align(
    //         //   alignment: Alignment.bottomRight,
    //         //   child: Container(
    //         //     margin: EdgeInsets.only(right: 25),
    //         //     child: FlatButton(
    //         //       color: Color(0xFF52489C),
    //         //       textColor: Colors.white,
    //         //       padding: EdgeInsets.only(
    //         //         left: 5.0,
    //         //         right: 5.0,
    //         //       ),
    //         //       onPressed: () {},
    //         //       shape: RoundedRectangleBorder(
    //         //           borderRadius: BorderRadius.circular(18.0)),
    //         //       child: Text(
    //         //         "Add review",
    //         //         style: TextStyle(fontSize: 15.0),
    //         //       ),
    //         //     ),
    //         //   ),
    //         // ),
    //         // LocationCommments(locationArgument['place_id']),
    //         SeparatorLine(),
    //       ],
    //     ),
    //   ),
    // );
  }
}

class AddTagPageProvider extends InheritedWidget {
  final Function removeTag;
  final Function addTag;
  final Function getTags;
  final Widget child;

  AddTagPageProvider({this.removeTag, this.addTag, this.getTags, this.child})
      : super(child: child);

  static AddTagPageProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AddTagPageProvider);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
