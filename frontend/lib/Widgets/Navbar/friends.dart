import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:http/http.dart' as http;
import 'package:tagge_map/main.dart';
import 'dart:io';

class Fr {
  var id;
  String username;
  Fr(this.id, this.username);
}

class Friends extends StatefulWidget {
  final Function f;

  Friends(this.f);
  @override
  _FriendsState createState() => _FriendsState(this.f);
}

class _FriendsState extends State<Friends> {
  List<Fr> friendsList = [];
  List<Fr> friendsListCopy = [];
  var req = 0;
  final Function f;
  _FriendsState(this.f);

  void getFriends(String token) async {
    print("FRIENDS");
    print(token);
    final isUser = await http.post(
      'http://192.168.1.15:5000/friends',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
      }),
    );

    Map<String, dynamic> r = jsonDecode(isUser.body);
    if (r['result'] == 'yes') {
      for (var i = 0; i < r['list'].length; i++) {
        Fr f = Fr(r['list'][i]['id'], r['list'][i]['username']);
        friendsListCopy.add(f);
      }
    }
    print("the listtt");
    print(friendsListCopy);
    setState(() {
      friendsList = friendsListCopy;
    });
  }

  File image;

  File im2;
  void returnuserphoto(String token) async {
    final isUser = await http.post(
      'http://192.168.1.15:5000/editpagephoto',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
      }),
    );
    // print("SUNT AICIIII");
    // print(isUser.body);
    Map<String, dynamic> r = jsonDecode(isUser.body);

    if (r['response'] == 'yes') {
      var im2 = await File(
              '/storage/emulated/0/Android/data/com.example.tagge_map/files/Pictures/profile_picture_2.jpg')
          .writeAsBytes(
              base64Decode(r['file_path']).cast<int>()); //asa decotdez
      setState(() {
        rea = 1;
        print("immm2");
        print(im2);
        image = im2;
      });
    }
  }

  var rea = 0;
  String token;

  @override
  Widget build(BuildContext context) {
    token = TokenProvider.of(context).getToken();
    if (rea == 0) {
      returnuserphoto(token);
    }
    if (req == 0) {
      getFriends(token);
      req = 1;
    }

    List<Widget> widgetsss = [
      InkWell(
        child: Column(
          children: <Widget>[
            Container(
              width: 65,
              height: 65,
              margin: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 10,
                right: 10,
              ),
              //   width: 60,
              //   height: 60,
              //   decoration: new BoxDecoration(
              //     color: Colors.white70,
              //     shape: BoxShape.circle,
              //     image: new DecorationImage(
              //       fit: BoxFit.fill,
              //       image: new NetworkImage(
              //           "https://www.facebook.com/photo.php?fbid=2425990267500263&set=a.104929346273045&type=3&theater"),
              //     ),
              //   ),
              // ),
              child: CircleAvatar(
                  backgroundColor: Colors.purple[200],
                  radius: 30,
                  child: Icon(
                    Icons.map,
                    color: Colors.white,
                  )),
            ),
            Flexible(
              child: Text(
                'My Map',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          f(null);
        },
      ),
    ];

    for (var x = 0; x < friendsList.length; x++) {
      print(friendsList[x]);
      print("asdasd");
      widgetsss.add(
        InkWell(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                // padding: EdgeInsets.all(6),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // border: Border.all(width: 1),
                  ),
                  width: 65.0,
                  height: 65.0,
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
              Flexible(
                child: Text(friendsList[x].username,
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ],
          ),
          onTap: () {
            f(friendsList[x].id);
          },
        ),
      );
    }
    widgetsss.add(
      InkWell(
        child: Column(
          children: <Widget>[
            Container(
                width: 65,
                height: 65,
                margin: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 10,
                  right: 10,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.purple[200],
                  radius: 30,
                  child: Icon(
                    Icons.group_add,
                    color: Colors.white,
                  ),
                )),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, '/searchfriends');
        },
      ),
    );

    return Container(
      margin: EdgeInsets.all(4),
      decoration: new BoxDecoration(
          color: Color(0xFF52489C),
          borderRadius: new BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          )),
      height: 160,
      width: 0.9 * MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
              top: 15,
              left: 15,
            ),
            child: Text(
              "Following accounts: ",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            height: 100,
            margin: EdgeInsets.only(
              left: 15,
              bottom: 10,
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: widgetsss,
            ),
          ),
        ],
      ),
    );
  }
}
