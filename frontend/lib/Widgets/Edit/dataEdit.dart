import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tagge_map/Pages/editPage.dart';
import 'package:tagge_map/Widgets/Edit/changepassword.dart';
import 'package:tagge_map/main.dart';
import '../SeparatorLine.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart' as pc;
import 'package:crypto/crypto.dart';

class DataEdit extends StatefulWidget {
  @override
  _DataEditState createState() => _DataEditState();
}

class _DataEditState extends State<DataEdit> {
  int request = 0;

  String firstName;
  String lastName;
  // String password;
  // String file;
  TextEditingController fnController = new TextEditingController();
  TextEditingController lnController = new TextEditingController();
  TextEditingController pController = new TextEditingController();
  String decryptedpassword;

  void update(String token, String firstn, String lastn) async {
    print("fn infoo");

    final fn = await http.post(
      'http://192.168.1.15:5000/update',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
        'first_name': firstn,
        'last_name': lastn,
      }),
    );

    if (fn.body == "updated") {
      Navigator.pushNamed(context, '/home');

      print("info updated");
    } else {
      print("info !updated");
    }
  }

  String t;

  @override
  Widget build(BuildContext context) {
    t = TokenProvider.of(context).getToken();
    print(t);
    print("from edit page");
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text(
                    "First Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 250,
                  child: TextField(
                    controller: fnController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Color(0xFF757575),
                        fontSize: 16,
                      ),
                      hintText: EditProvider.of(context).firstname,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text(
                    "Last Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 250,
                  child: TextField(
                    controller: lnController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Color(0xFF757575),
                        fontSize: 16,
                      ),
                      hintText: EditProvider.of(context).lastname,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 25),
                child: FlatButton(
                  color: Color(0xFF52489C),
                  textColor: Colors.white,
                  padding: EdgeInsets.only(
                    left: 5.0,
                    right: 5.0,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditProvider2(
                            token: t,
                            child: ChangePassword(),
                          );
                        });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Text(
                    "Change password",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 25),
                child: FlatButton(
                  color: Color(0xFF52489C),
                  textColor: Colors.white,
                  padding: EdgeInsets.only(
                    left: 5.0,
                    right: 5.0,
                  ),
                  onPressed: () {
                    update(t, fnController.text, lnController.text);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Text(
                    "Save changes",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          SeparatorLine(),
          // Container(
          //   margin: EdgeInsets.only(left: 15, right: 15, top: 10),
          //   child: Text(
          //     "If you want to change some information complete the text fields and click save button. The hint in text fileds show current data.",
          //     style: TextStyle(
          //       color: Colors.grey,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class EditProvider2 extends InheritedWidget {
  String token;

  final Widget child;
  EditProvider2({this.token, this.child}) : super(child: child);

  static EditProvider2 of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(EditProvider2);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
