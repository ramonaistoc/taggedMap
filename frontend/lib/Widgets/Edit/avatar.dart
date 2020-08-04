import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:tagge_map/Pages/editPage.dart';
import 'package:tagge_map/Widgets/Edit/dataEdit.dart';
import 'package:tagge_map/Widgets/SeparatorLine.dart';
import 'package:tagge_map/main.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

class AvatarEdit extends StatefulWidget {
  // Function userData;
  // AvatarEdit(this.userData);
  @override
  _AvatarEditState createState() => _AvatarEditState();
}

class _AvatarEditState extends State<AvatarEdit> {
  // Function userData;
  // _AvatarEditState(this.userData);
  String username = "";
  var req = 0;
  String usernamec = "";
  String encryptedfilepath;

  void addimageuser(String filepath, String token, var img) async {
    // String token = TokenProvider.of(context).getToken();

    final isUser = await http.post(
      'http://192.168.1.15:5000/adduserphoto',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
        'filepath': filepath,
      }),
    );

    if (isUser.body == "photo") {
      print("added");
    } else {
      print("not added photo");
    }

    setState(() {
      Navigator.pop(context);
      image = img;
    });
  }

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
        print("immm2");
        print(im2);
        image = im2;
      });
    }
  }

  File image;

  cameraConnect(String token) async {
    print('Picker is Called');

    File img = await ImagePicker.pickImage(source: ImageSource.camera);

    print(base64Encode(img.readAsBytesSync()));

    String strImg =
        base64Encode(img.readAsBytesSync()); //asta bag in baza de date

    print(img);

    if (img != null) {
      addimageuser(strImg, token, img);
    }
  }

  galleryConnect(String token) async {
    print('Picker is Called');

    File img = await ImagePicker.pickImage(source: ImageSource.gallery);

    print(base64Encode(img.readAsBytesSync()));

    String strImg =
        base64Encode(img.readAsBytesSync()); //asta bag in baza de date

    if (img != null) {
      addimageuser(strImg, token, img);
    }
  }

  Future<void> showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            height: 150,
            width: 0.9 * MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Text(
                    "Select photo from gallery",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  onTap: () {
                    galleryConnect(token);
                  },
                ),
                SizedBox(height: 10),
                SeparatorLine(),
                SizedBox(height: 10),
                InkWell(
                  child: Text(
                    "Take a photo",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  onTap: () {
                    cameraConnect(token);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  String token;
  bool havetoken = false;
  @override
  Widget build(BuildContext context) {
    if (havetoken == false) {
      setState(() {
        havetoken = true;
        print("token din avatareditcamera");
        token = TokenProvider.of(context).getToken();
        returnuserphoto(token);
        print(token);
      });
    }

    return Stack(
      children: <Widget>[
        Center(
            child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1),
          ),
          margin: EdgeInsets.only(
            top: 30,
            bottom: 15,
          ),
          width: 80.0,
          height: 80.0,
          child: //imagecontainer,
              image == null
                  ? Container(
                      width: 20,
                      height: 20,
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
        )),
        Positioned(
          top: 80,
          right: 145,
          child: Align(
            child: InkWell(
              onTap: () {
                showChoiceDialog(context);
              },
              child: new Container(
                width: 25,
                height: 25,
                decoration: new BoxDecoration(
                  color: Colors.pink[100], //Color(0xFF52489),
                  shape: BoxShape.circle,
                ),
                child: new Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
