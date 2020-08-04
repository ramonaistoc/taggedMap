import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tagge_map/Pages/followRequests.dart';
import 'package:tagge_map/Widgets/Conections/followingContainerwithX.dart';
import 'package:tagge_map/Widgets/Search/searchFriendsContainer.dart';
import 'package:tagge_map/main.dart';

class Followingc {
  var id;
  String firstname;
  String lastname;
  int nr_places;
  Followingc(this.id, this.firstname, this.lastname, this.nr_places);
}

class Following extends StatefulWidget {
  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  List<Followingc> infoList = [];
  var req = 0;

  void getFollowersList(String token) async {
    final isUser = await http.post(
      'http://192.168.1.15:5000/followinglist',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
      }),
    );
    Map<String, dynamic> r = jsonDecode(isUser.body);
    print(r);

    List<Followingc> fcopy = [];

    if (r['result'] == 'yes') {
      for (var i = 0; i < r['list'].length; i++) {
        print(r['list'][i]['firstname']);
        Followingc c = Followingc(r['list'][i]['id'], r['list'][i]['firstname'],
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
    setState(() {
      infoList.removeWhere((element) => (element.id == id));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> followersList = [];

    for (var i = 0; i < infoList.length; i++) {
      followersList.add(FollowingProvider(
        removeFromList: removeFromList,
        child: FollowingContainerwithX(infoList[i]),
      ));
    }
    String token = TokenProvider.of(context).getToken();
    if (req == 0) {
      req = 1;
      getFollowersList(token);
    }
    return Scaffold(
        body: Center(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 20,
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
              height: 80,
              width: MediaQuery.of(context).size.width,
              color: Color(0xFF52489C),
              child: Container(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  "FOLLOWING LIST",
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

class FollowingProvider extends InheritedWidget {
  final Function removeFromList;
  final Widget child;

  FollowingProvider({this.removeFromList, this.child}) : super(child: child);

  static FollowingProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(FollowingProvider);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
