import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tagge_map/Pages/accountSettingsPage.dart';
import 'package:tagge_map/main.dart';

class Avatar extends StatefulWidget {
  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  File image;
  File im2;

  void stringtofile(String s) async {
    im2 = await File(
            '/storage/emulated/0/Android/data/com.example.tagge_map/files/Pictures/profile_picture_1.jpg')
        .writeAsBytes(base64Decode(s).cast<int>()); //asa decotdez

    print("immm2");

    print(im2);

    setState(() {
      image = im2;
      req = true;
    });
  }

  bool req = false;
  @override
  Widget build(BuildContext context) {
    print("from aata23423423423r");

    String username = AccountSProvider.of(context).username;
    String nrVsitedPlaces = AccountSProvider.of(context).nrVisitedPlaces;
    String filepath = AccountSProvider.of(context).f; //filepath

    print(username);
    print(nrVsitedPlaces);
    print(filepath);
    if (req == false) {
      stringtofile(filepath);
    }

    return Column(
      children: <Widget>[
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(6),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1),
              ),
              width: 70.0,
              height: 70.0,
              child: //imagecontainer,
                  image == null
                      ? Container(
                          width: 45,
                          height: 45,
                          decoration: new BoxDecoration(
                            color: Colors.white70,
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS4OWWKtdi__FtY485WKSUD0pBUb5AVSPBXlQ&usqp=CAU"),
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.file(
                            image,
                            fit: BoxFit.fill,
                          ),
                        ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              // "",
              username,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              " | ",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              nrVsitedPlaces + " visited places",
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
