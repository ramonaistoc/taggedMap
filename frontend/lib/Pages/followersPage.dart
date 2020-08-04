import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tagge_map/Widgets/Conections/followersContainerwithX.dart';
import 'package:tagge_map/Widgets/Search/searchFriendsContainer.dart';
import 'package:tagge_map/main.dart';

class Followersc {
  var id;
  String firstname;
  String lastname;
  int nr_places;
  Followersc(this.id, this.firstname, this.lastname, this.nr_places);
}

class Followers extends StatefulWidget {
  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  List<Followersc> infoList = [];
  var req = 0;

  void getFollowersList(String token) async {
    print("im inn");
    final isUser = await http.post(
      'http://192.168.1.15:5000/followerslist',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
      }),
    );
    Map<String, dynamic> r = jsonDecode(isUser.body);
    print("aici1");
    List<Followersc> fcopy = [];

    if (r['result'] == 'yes') {
      for (var i = 0; i < r['list'].length; i++) {
        print("aici2");

        print(r['list'][i]['nr_places']);
        Followersc c = Followersc(r['list'][i]['id'], r['list'][i]['firstname'],
            r['list'][i]['lastname'], r['list'][i]['nr_places']);
        fcopy.add(c);
      }

      setState(() {
        infoList = fcopy;
      });
    } else {
      print(" NO RESULT");
    }
  }

  void removeFromList(var id) {
    print("dffflwer");
    print(id);
    setState(() {
      infoList.removeWhere((element) => (element.id == id));
    });
  }

  @override
  Widget build(BuildContext context) {
    String token = TokenProvider.of(context).getToken();
    if (req == 0) {
      print("followersss");
      req = 1;
      getFollowersList(token);
    }
    List<Widget> followersList = [];

    for (var i = 0; i < infoList.length; i++) {
      followersList.add(FollowersProvider(
        removeFromList: removeFromList,
        child: FollowedContainerwithX(infoList[i]),
      ));
    }

    return Scaffold(
        body: Center(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width * .07,
            child: Container(
              margin: EdgeInsets.only(top: 50),
              width: MediaQuery.of(context).size.width * .86,
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: followersList,
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              color: Color(0xFF52489C),
              child: Container(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  "FOLLOWERS LIST",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class FollowersProvider extends InheritedWidget {
  final Function removeFromList;
  final Widget child;

  FollowersProvider({this.removeFromList, this.child}) : super(child: child);

  static FollowersProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(FollowersProvider);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
