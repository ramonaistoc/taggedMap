import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tagge_map/Widgets/Conections/followRequestContainer.dart';
import 'package:tagge_map/Widgets/Conections/followersContainerwithX.dart';
import 'package:tagge_map/Widgets/Search/searchFriendsContainer.dart';
import 'package:tagge_map/main.dart';

class FollowRequest {
  var id;
  String firstname;
  String lastname;
  int nr_places;
  FollowRequest(this.id, this.firstname, this.lastname, this.nr_places);
}

class FollowRequests extends StatefulWidget {
  @override
  _FollowRequestsState createState() => _FollowRequestsState();
}

class _FollowRequestsState extends State<FollowRequests> {
  List<FollowRequest> infoList = [];
  var req = 0;

  void getFollowersList(String token) async {
    print("friendddss");
    final isUser = await http.post(
      'http://192.168.1.15:5000/returnfollowrequests',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
      }),
    );
    Map<String, dynamic> r = jsonDecode(isUser.body);

    List<FollowRequest> fcopy = [];

    if (r['result'] == 'yes') {
      for (var i = 0; i < r['list'].length; i++) {
        print(r['list'][i]['firstname']);
        FollowRequest c = FollowRequest(
            r['list'][i]['id'],
            r['list'][i]['firstname'],
            r['list'][i]['lastname'],
            r['list'][i]['nr_places']);
        fcopy.add(c);
      }
      // print("fcopy din FR");

      // for (var i = 0; i < fcopy.length; i++) {
      //   print(fcopy[i].firstname);
      //   print(fcopy[i].lastname);
      //   print(fcopy[i].nr_places);
      // }
      setState(() {
        infoList = fcopy;
        // print(infoList);
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
    String token = TokenProvider.of(context).getToken();

    if (req == 0) {
      req = 1;
      getFollowersList(token);
    }
    List<Widget> followersList = [];

    for (var i = 0; i < infoList.length; i++) {
      followersList.add(FollowRequestProvider(
        removeFromList: removeFromList,
        child: FolloweRequestsContainer(infoList[i]),
      ));
    }

    return Scaffold(
        body: Center(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 15,
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
                  "FOLLOW REQUESTS",
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

class FollowRequestProvider extends InheritedWidget {
  final Function removeFromList;
  final Widget child;

  FollowRequestProvider({this.removeFromList, this.child})
      : super(child: child);

  static FollowRequestProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(FollowRequestProvider);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
