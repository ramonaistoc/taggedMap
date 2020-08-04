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
import 'package:tagge_map/Widgets/Tags/createTagContainer.dart';
import 'package:tagge_map/main.dart';
import 'package:tagge_map/Pages/addTagPage.dart';

class IdLocationPage extends StatefulWidget {
  final dynamic info;
  IdLocationPage(this.info);

  @override
  _IdLocationPageState createState() => _IdLocationPageState(this.info);
}

class _IdLocationPageState extends State<IdLocationPage> {
  final dynamic info;
  _IdLocationPageState(this.info) {}

  String locationAddress = '';
  TextEditingController commentsController = new TextEditingController();

  List<Tag> locationTags = [];

  void addTagToList(Tag t) {
    setState(() {
      if (!info['tags'].contains(t)) {
        info['tags'].add(t);
      }
    });
  }

  List<Tag> returnLocationTags() {
    return info['tags'];
  }

  void deleteTag(String s, Color c) {
    setState(() {
      info['tags'].removeWhere(
          (element) => element.tagColor == c && element.tagText == s);
    });
  }

  @override
  Widget build(BuildContext context) {
    String token = TokenProvider.of(context).getToken();
    print("token din id location page");
    print(info);
    List<CreateTagContainer> tagList = [];

    for (int x = 0; x < info['tags'].length; x++) {
      tagList.add(CreateTagContainer(
          info['tags'][x].id, info['tags'][x].tagText, info['tags'][x].tagColor,
          () {
        deleteTag(info['tags'][x].tagText, info['tags'][x].tagColor);
      }, () {
        AddTagPageProvider.of(context).addTag(info['allTags'][x]);
      }));
    }

    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text('See location data')),
          backgroundColor: Color(0xff52489c),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            LocationTitle(info),
            SeparatorLine(),
            AddTagPageProvider(
              getTags: returnLocationTags,
              addTag: addTagToList,
              removeTag: deleteTag,
              child: Container(
                height: 37,
                margin: EdgeInsets.only(
                  bottom: 20,
                  top: 20,
                  left: 10,
                  right: 10,
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: tagList,
                ),
              ),
            ),
            SeparatorLine(),
            AddTagPageProvider(
              getTags: returnLocationTags,
              addTag: addTagToList,
              removeTag: deleteTag,
              child: SelectCreateTag(),
            ),
            SeparatorLine(),
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
                      hintText: info['review'] ==
                              "This location doesn't have a review"
                          ? "Write a comment... "
                          : info['review'],
                    ),
                  ),
                ),
              ),
            ),
            SeparatorLine(),
          ],
        ),
      ),
    );
  }
}
