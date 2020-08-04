import 'dart:convert';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class DrawerHead extends StatefulWidget {
  String token;
  DrawerHead(this.token);

  @override
  _DrawerHeadState createState() => _DrawerHeadState();
}

class _DrawerHeadState extends State<DrawerHead> {
  String username = "";
  String encryptedfilepath;
  var nrVisitedPlaces;
  File image;
  File im2;

  void getUserInfo(String token) async {
    final isUser = await http.post(
      'http://192.168.1.15:5000/drawer',
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
      im2 = await File(
              '/storage/emulated/0/Android/data/com.example.tagge_map/files/Pictures/profile_picture_2.jpg')
          .writeAsBytes(
              base64Decode(r['file_path']).cast<int>()); //asa decotdez
      setState(() {
        username = r['username'];
        nrVisitedPlaces = r['places_number'].toString();
        encryptedfilepath = r['file_path'];

        print("immm2");

        print(im2);

        image = im2;

        print(encryptedfilepath);
        // print(encryptedfilepath);
      });
    }
  }

  // void stringtofile(String s) async {
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    if (username == "") {
      getUserInfo(widget.token);
      // stringtofile(encryptedfilepath);
    }
    print("DRAWEWEWEW\n\n\n");
    print(image);
    return Row(
      children: [
        Container(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // border: Border.all(width: 3),
            ),
            margin: EdgeInsets.only(
              left: 30,
              top: 30,
              bottom: 15,
            ),
            width: 70.0,
            height: 70.0,
            child: //imagecontainer,
                image == null
                    ? Container(
                        width: 15,
                        height: 15,
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
        SizedBox(width: 10),
        /*1*/
        Flexible(
          child: Container(
            margin: EdgeInsets.only(top: 20),
            padding: const EdgeInsets.only(left: 3, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Text(
                  // '@user',
                  username,

                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  // '@places',
                  nrVisitedPlaces + " visited places",
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
