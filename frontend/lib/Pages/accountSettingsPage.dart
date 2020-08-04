import 'dart:convert';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:tagge_map/Widgets/Account/avatar.dart';
import 'package:tagge_map/Widgets/Account/seettings1.dart';
import 'package:tagge_map/Widgets/Account/settings2.dart';
import 'package:tagge_map/Widgets/Account/settings3.dart';
import 'package:tagge_map/Widgets/SeparatorLine.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../main.dart';

class AccountSettings extends StatefulWidget {
  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  int requestDone = 0;
  String username;
  String nrVsitedPlaces;
  String followingnr;
  String followernr;
  String filepath;

  void getUserInfo(String token) async {
    final isUser = await http.post(
      'http://192.168.1.15:5000/accountsettingsinfo',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
      }),
    );
    print("SUNT AICIIII in avvatar acc s");
    print(isUser.body);
    Map<String, dynamic> r = jsonDecode(isUser.body);

    if (r['response'] == 'yes') {
      setState(() {
        username = r['username'];
        nrVsitedPlaces = r['places_number'].toString();
        followingnr = r['nr_following'].toString();
        followernr = r['nr_followers'].toString();
        filepath = r['file_path'];
        print("din acc set");

        print(followingnr);
        print(followernr);
        print(username);
        print(nrVsitedPlaces);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String token = TokenProvider.of(context).getToken();

    if (requestDone == 0) {
      requestDone = 1;
      getUserInfo(token);
    }
    print("file path from account settings");
    print(filepath);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF52489C),
        title: Text("Account settings"),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/edit');
            },
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AccountSProvider(
                f: filepath,
                nrfollowers: followernr,
                nrfollowing: followingnr,
                username: username,
                nrVisitedPlaces: nrVsitedPlaces,
                child: Avatar()),
            SeparatorLine(),
            AccountSProvider(
              nrfollowers: followernr,
              nrfollowing: followingnr,
              username: username,
              nrVisitedPlaces: nrVsitedPlaces,
              child: Settings1(),
            ),
            // SeparatorLine(),
            // Settings2(),
            SeparatorLine(),
            Settings3()
          ],
        ),
      ),
    );
  }
}

class AccountSProvider extends InheritedWidget {
  String username;
  String nrVisitedPlaces;
  final Widget child;
  String nrfollowers;
  String nrfollowing;
  String f;

  AccountSProvider(
      {this.username,
      this.nrVisitedPlaces,
      this.nrfollowers,
      this.nrfollowing,
      this.f,
      this.child})
      : super(child: child);

  static AccountSProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AccountSProvider);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
