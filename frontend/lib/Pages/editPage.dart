import 'dart:convert';
// import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tagge_map/Widgets/Edit/avatar.dart';
import 'package:tagge_map/Widgets/Edit/dataEdit.dart';
import 'package:tagge_map/Widgets/SeparatorLine.dart';
import 'package:tagge_map/main.dart';
import 'dart:io';
import 'package:tagge_map/main.dart';
// import 'dart:io';

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  String firstName;

  String lastName;

  String password;

  void userData(String token) async {
    print("user infoo");
    final data = await http.post(
      'http://192.168.1.15:5000/showUserdata',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
      }),
    );
    Map<String, dynamic> r = jsonDecode(data.body);

    if (r['result'] == 'yes') {
      setState(() {
        lastName = r['last_name'];
        firstName = r['first_name'];
        password = r['password'];
      });
    } else {
      print("tag not added in DB");
    }
  }

  int req = 0;
  @override
  Widget build(BuildContext context) {
    String t = TokenProvider.of(context).getToken();
    print('TOKEN DIN EPAGE');
    print(t);
    if (req == 0) {
      req = 1;
      userData(t);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF52489C),
        title: Text("Edit your profile"),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            EditProvider(
              firstname: firstName,
              lastname: lastName,
              token: t,
              // file: file,
              child: AvatarEdit(),
            ),
            SeparatorLine(),
            SizedBox(height: 10),
            EditProvider(
              firstname: firstName,
              lastname: lastName,
              token: t,
              // file: file,
              child: DataEdit(),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProvider extends InheritedWidget {
  String token;
  String firstname;
  String lastname;

  final Widget child;
  EditProvider({this.token, this.firstname, this.lastname, this.child})
      : super(child: child);

  static EditProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(EditProvider);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
