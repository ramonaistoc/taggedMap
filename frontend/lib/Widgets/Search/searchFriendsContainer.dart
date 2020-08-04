import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tagge_map/Widgets/SeparatorLine.dart';
import 'package:tagge_map/main.dart';
import 'package:http/http.dart' as http;

class FriendsContainer extends StatefulWidget {
  final dynamic data;
  List<int> requestP;
  FriendsContainer(this.data, this.requestP);

  @override
  _FriendsContainerState createState() => _FriendsContainerState();
}

class _FriendsContainerState extends State<FriendsContainer> {
  List<int> requestedusers =
      []; // aici sunt persoanele catre care deja e trimisa cererea de urmarire

  void sendFriendRequest(String token, var id) async {
    final isUser = await http.post(
      'http://192.168.1.15:5000/sendfriendrequest',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
        'id': id.toString(),
      }),
    );

    Map<String, dynamic> r = jsonDecode(isUser.body);

    // List<int> copy = [];

    // for (var i = 0; i < r['list'].length; i++) {
    //   copy.add(r['list'][i]);
    // }

    if (isUser.body == "sent") {
      // setState(() {
      print("it s oke");
      //   requestedusers = copy;
      //   print(requestedusers);
      // });
    } else {
      print("error in searchfriendscontainer");
    }
  }

  bool showsend = false;

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

    Map<String, dynamic> r = jsonDecode(isUser.body);

    if (r['response'] == 'yes') {
      var im2 = await File(
              '/storage/emulated/0/Android/data/com.example.tagge_map/files/Pictures/profile_picture_2.jpg')
          .writeAsBytes(
              base64Decode(r['file_path']).cast<int>()); //asa decotdez
      setState(() {
        req = 1;
        print("immm2");
        print(im2);
        image = im2;
      });
    }
  }

  var req;
  String token;

  @override
  Widget build(BuildContext context) {
    token = TokenProvider.of(context).getToken();
    if (req == 0) {
      returnuserphoto(token);
    }
    requestedusers = widget.requestP;
    // String token = TokenProvider.of(context).getToken();
    // seerequestedusers(token);
    // print(requestedusers);
    // print("requestedusersr");
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        color: Color(0x88F4D35E),
        borderRadius: new BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
        top: 20,
        // left: 20,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                // padding: EdgeInsets.all(6),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1),
                  ),
                  width: 60.0,
                  height: 60.0,
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
              Column(
                children: <Widget>[
                  Text(
                    widget.data['firstname'] + " " + widget.data['lastname'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(widget.data['nr_places'].toString() +
                          " visited places")),
                ],
              ),
            ],
          ),
          //daca utilizatorul deja are o cerere de urmarire trimisa
          requestedusers.contains(widget.data['id'])
              ? InkWell(child: Icon(Icons.send))
              : InkWell(
                  onTap: () {
                    setState(() {
                      sendFriendRequest(token, widget.data['id']);
                      showsend = true;
                    });
                  },
                  child: showsend == true
                      ? Icon(Icons.send)
                      : Icon(Icons.person_add)),
        ],
      ),
    );
  }
}
